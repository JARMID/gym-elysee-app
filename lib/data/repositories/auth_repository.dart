import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/api_service.dart';
import '../../presentation/providers/branch_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(storageServiceProvider),
    ref.read(apiServiceProvider),
  );
});

class AuthRepository {
  final StorageService _storageService;
  final ApiService _apiService;

  AuthRepository(this._storageService, this._apiService);

  Future<UserModel> login(String email, String password) async {
    try {
      // 1. Login with Supabase
      final response = await sb.Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);

      final user = response.user;
      final session = response.session;

      if (user == null || session == null) {
        throw const AuthException();
      }

      // 2. Exchange Token with Backend to get Sanctum Token
      // This ensures we are authenticated in the Laravel backend
      final exchangeResponse = await _apiService.post(
        '/auth/exchange',
        options: Options(
          headers: {'Authorization': 'Bearer ${session.accessToken}'},
        ),
      );

      final sanctumToken = exchangeResponse.data['token'];
      final backendUser = exchangeResponse.data['user'];

      // 3. Save Sanctum Token for API calls
      await _storageService.saveAccessToken(sanctumToken);
      if (session.refreshToken != null) {
        await _storageService.saveRefreshToken(session.refreshToken!);
      }

      // 4. Construct User Model from Backend Data
      // Mapping 'type' -> 'role', 'photo' -> 'avatar_url', int id -> String id
      final userModel = UserModel.fromJson({
        ...backendUser,
        'role': backendUser['type'],
        'id': backendUser['id'].toString(),
        'avatar_url': backendUser['photo'],
      });

      await _storageService.saveUserData(userModel.toJson().toString());

      return userModel;
    } catch (e) {
      if (e is sb.AuthException) {
        if (e.message.toLowerCase().contains('invalid login credentials')) {
          throw const AuthException(AuthErrorCode.invalidCredentials);
        }
        throw AuthException(AuthErrorCode.unknown, e.message);
      }
      // Handle Dio errors from exchange
      throw const AuthException(AuthErrorCode.unknown);
    }
  }

  Future<UserModel> register(Map<String, dynamic> data) async {
    try {
      // 1. Sign Up with Supabase
      final response = await sb.Supabase.instance.client.auth.signUp(
        email: data['email'],
        password: data['password'],
        data: {
          'first_name': data['first_name'],
          'last_name': data['last_name'],
          'phone': data['phone'],
        },
      );

      final user = response.user;
      final session = response.session;

      if (user == null) {
        throw const AuthException();
      }

      // 2. If we have a session (auto-login), exchange token immediately
      if (session != null) {
        final exchangeResponse = await _apiService.post(
          '/auth/exchange',
          options: Options(
            headers: {'Authorization': 'Bearer ${session.accessToken}'},
          ),
        );

        final sanctumToken = exchangeResponse.data['token'];
        final backendUser = exchangeResponse.data['user'];

        await _storageService.saveAccessToken(sanctumToken);

        final userModel = UserModel.fromJson({
          ...backendUser,
          'role': backendUser['type'],
          'id': backendUser['id'].toString(),
          'avatar_url': backendUser['photo'],
        });

        await _storageService.saveUserData(userModel.toJson().toString());
        return userModel;
      } else {
        // Email confirmation required case - return partial model
        // Or handle as pending
        throw const AuthException(
          AuthErrorCode.unknown,
          "Email confirmation required",
        );
      }
    } catch (e) {
      if (e is sb.AuthException) {
        if (e is sb.AuthApiException) {
          switch (e.code) {
            case 'email_address_invalid':
              throw const AuthException(AuthErrorCode.emailInvalid);
            case 'over_email_send_rate_limit':
              throw const AuthException(AuthErrorCode.rateLimit);
            case 'user_already_exists':
              throw const AuthException(AuthErrorCode.userExists);
            default:
              if (e.statusCode == '400' && e.message.contains('password')) {
                throw const AuthException(AuthErrorCode.weakPassword);
              }
          }
        }
        throw AuthException(AuthErrorCode.unknown, e.message);
      }

      debugPrint('Registration Error: $e');
      throw AuthException(AuthErrorCode.unknown, e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await sb.Supabase.instance.client.auth.signOut();
    } finally {
      await _storageService.clearAll();
    }
  }

  Future<void> deleteAccount() async {
    try {
      // 1. Delete from Laravel Backend (Data)
      await _apiService.delete('/auth/me');
    } catch (e) {
      debugPrint('Warning: Backend deletion failed: $e');
      // Continue to Supabase logout anyway
    } finally {
      // 2. Logout from Supabase (We can't delete Supabase user without Admin Key)
      await logout();
    }
  }

  Future<UserModel> getCurrentUser() async {
    final user = sb.Supabase.instance.client.auth.currentUser;
    if (user == null) throw const AuthException();

    try {
      // Use maybeSingle() to return null instead of throwing if not found
      Map<String, dynamic>? profileData = await sb.Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      // Lazy creation if profile is missing
      if (profileData == null) {
        // Attempt to create it again (best effort)
        final now = DateTime.now().toUtc();
        final metadata = user.userMetadata ?? {};

        final newProfile = {
          'id': user.id,
          'email': user.email,
          'first_name': metadata['first_name'] ?? 'Membre',
          'last_name': metadata['last_name'] ?? '',
          'role': 'member',
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        };

        try {
          await sb.Supabase.instance.client.from('profiles').upsert(newProfile);
          profileData = newProfile;
        } catch (e) {
          debugPrint('Warning: Lazy profile creation failed: $e');
          // Fallback to ephemeral model so UI doesn't crash
          profileData = newProfile;
        }
      }

      return UserModel.fromJson(profileData);
    } catch (e) {
      // If even the fallback fails, throw ServerException but logged
      debugPrint('Error in getCurrentUser: $e');
      throw const ServerException();
    }
  }

  Future<void> forgotPassword(String email) async {
    await sb.Supabase.instance.client.auth.resetPasswordForEmail(email);
  }

  Future<void> resetPassword({
    required String email,
    required String token, // OTP
    required String password,
    required String passwordConfirmation,
  }) async {
    // For Supabase, this flow is usually:
    // 1. Verify OTP (signInWithOtp)
    // 2. updateUser({password})
    final res = await sb.Supabase.instance.client.auth.verifyOTP(
      email: email,
      token: token,
      type: sb.OtpType.recovery,
    );

    if (res.session != null) {
      await sb.Supabase.instance.client.auth.updateUser(
        sb.UserAttributes(password: password),
      );
    } else {
      throw const AuthException();
    }
  }

  Future<void> changePassword(
    String
    currentPassword, // Supabase doesn't require verification of old pw for update if logged in
    String newPassword,
  ) async {
    await sb.Supabase.instance.client.auth.updateUser(
      sb.UserAttributes(password: newPassword),
    );
  }

  Future<bool> isAuthenticated() async {
    final session = sb.Supabase.instance.client.auth.currentSession;
    return session != null;
  }

  /// Update user profile data (name, phone, bio, etc.)
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? gender,
    String? bio,
    DateTime? birthDate,
  }) async {
    final user = sb.Supabase.instance.client.auth.currentUser;
    if (user == null) throw const AuthException();

    try {
      final updates = <String, dynamic>{};
      if (firstName != null) updates['first_name'] = firstName;
      if (lastName != null) updates['last_name'] = lastName;
      if (phone != null) updates['phone'] = phone;
      if (gender != null) updates['gender'] = gender;
      if (bio != null) updates['bio'] = bio;
      if (birthDate != null) {
        updates['birth_date'] = birthDate.toIso8601String().split('T').first;
      }

      await sb.Supabase.instance.client
          .from('profiles')
          .update(updates)
          .eq('id', user.id);

      // Fetch and return updated profile
      return getCurrentUser();
    } catch (e) {
      throw const ServerException();
    }
  }

  /// Upload or replace user avatar
  /// [imageBytes] - The image data as Uint8List (from image_picker or file)
  /// [fileExtension] - File extension like 'jpg', 'png'
  /// Returns the public URL of the uploaded avatar
  Future<String> uploadAvatar(
    Uint8List imageBytes,
    String fileExtension,
  ) async {
    final user = sb.Supabase.instance.client.auth.currentUser;
    if (user == null) throw const AuthException();

    try {
      final storagePath = '${user.id}/avatar.$fileExtension';

      // Upload with upsert to replace existing
      await sb.Supabase.instance.client.storage
          .from('avatars')
          .uploadBinary(
            storagePath,
            imageBytes,
            fileOptions: const sb.FileOptions(upsert: true),
          );

      // Get public URL
      final publicUrl = sb.Supabase.instance.client.storage
          .from('avatars')
          .getPublicUrl(storagePath);

      // Update profile with new avatar URL
      await sb.Supabase.instance.client
          .from('profiles')
          .update({'avatar_url': publicUrl})
          .eq('id', user.id);

      return publicUrl;
    } catch (e) {
      throw const ServerException();
    }
  }

  /// Delete user's avatar from storage and clear profile reference
  Future<void> deleteAvatar() async {
    final user = sb.Supabase.instance.client.auth.currentUser;
    if (user == null) throw const AuthException();

    try {
      // List files in user's avatar folder and delete them
      final files = await sb.Supabase.instance.client.storage
          .from('avatars')
          .list(path: user.id);

      if (files.isNotEmpty) {
        final filePaths = files.map((f) => '${user.id}/${f.name}').toList();
        await sb.Supabase.instance.client.storage
            .from('avatars')
            .remove(filePaths);
      }

      // Clear avatar_url in profile
      await sb.Supabase.instance.client
          .from('profiles')
          .update({'avatar_url': null})
          .eq('id', user.id);
    } catch (e) {
      throw const ServerException();
    }
  }
}

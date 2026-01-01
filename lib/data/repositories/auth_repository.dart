import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class AuthRepository {
  final StorageService _storageService;

  AuthRepository(this._storageService);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await sb.Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);

      final user = response.user;
      final session = response.session;

      if (user == null || session == null) {
        throw const AuthException();
      }

      // Fetch Profile Data from 'profiles' table to construct UserModel
      final profileData = await sb.Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      final userModel = UserModel.fromJson(profileData);

      // Save token for legacy compatibility
      await _storageService.saveAccessToken(session.accessToken);
      if (session.refreshToken != null) {
        await _storageService.saveRefreshToken(session.refreshToken!);
      }
      await _storageService.saveUserData(userModel.toJson().toString());

      return userModel;
    } catch (e) {
      if (e is sb.AuthException) {
        rethrow;
      }
      throw const AuthException();
    }
  }

  Future<UserModel> register(Map<String, dynamic> data) async {
    try {
      final response = await sb.Supabase.instance.client.auth.signUp(
        email: data['email'],
        password: data['password'],
        data: {
          'first_name': data['first_name'],
          'last_name': data['last_name'],
          // 'role': 'member', // Handled by Database Trigger
        },
      );

      final user = response.user;
      final session =
          response.session; // Might be null if email confirmation enabled

      if (user == null) {
        throw const AuthException();
      }

      // If session exists (no email confirm needed), save session
      if (session != null) {
        await _storageService.saveAccessToken(session.accessToken);
      }

      // Construct Initial User Model (Profile trigger might take a ms, so use local data)
      final tempUser = UserModel(
        id: user.id,
        type: 'member',
        firstName: data['first_name'],
        lastName: data['last_name'],
        email: user.email!,
        phone: null,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _storageService.saveUserData(tempUser.toJson().toString());

      return tempUser;
    } catch (e) {
      throw const AuthException(); // Wrap Supabase exception
    }
  }

  Future<void> logout() async {
    try {
      await sb.Supabase.instance.client.auth.signOut();
    } finally {
      await _storageService.clearAll();
    }
  }

  Future<UserModel> getCurrentUser() async {
    final user = sb.Supabase.instance.client.auth.currentUser;
    if (user == null) throw const AuthException();

    try {
      final profileData = await sb.Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return UserModel.fromJson(profileData);
    } catch (e) {
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
}

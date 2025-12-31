import '../../core/constants/api_constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthRepository {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthRepository(this._apiService, this._storageService);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final user = UserModel.fromJson(response.data['user']);
      final token = response.data['token'] as String;
      final refreshToken = response.data['refresh_token'] as String?;

      await _storageService.saveAccessToken(token);
      if (refreshToken != null) {
        await _storageService.saveRefreshToken(refreshToken);
      }
      await _storageService.saveUserData(user.toJson().toString());

      return user;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw const AuthException(); // Generic auth error
    }
  }

  Future<UserModel> register(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
        ApiConstants.register,
        data: data,
      );

      final user = UserModel.fromJson(response.data['user']);
      final token = response.data['token'] as String;

      await _storageService.saveAccessToken(token);
      await _storageService.saveUserData(user.toJson().toString());

      return user;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw const AuthException();
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post(ApiConstants.logout);
    } catch (e) {
      // Continue even if API call fails
    } finally {
      await _storageService.clearAll();
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiService.get(ApiConstants.me);
      return UserModel.fromJson(response.data);
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw const ServerException();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _apiService.post(
        ApiConstants.forgotPassword,
        data: {'email': email},
      );
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw const AuthException();
    }
  }

  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await _apiService.post(
        ApiConstants.resetPassword,
        data: {
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw const AuthException();
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await _apiService.post(
        '/auth/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPassword,
        },
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw const AuthException();
    }
  }

  Future<bool> isAuthenticated() async {
    final token = await _storageService.getAccessToken();
    return token != null && token.isNotEmpty;
  }
}

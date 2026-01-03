class AppException implements Exception {
  final String? message;
  final int? statusCode;

  const AppException([this.message, this.statusCode]);

  @override
  String toString() => message ?? 'AppException';
}

class NetworkException extends AppException {
  const NetworkException([super.message]);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message]);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message]);
}

class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  const ValidationException(super.message, {this.errors});
}

class ServerException extends AppException {
  const ServerException([super.message]);
}

class CacheException extends AppException {
  const CacheException([super.message]);
}

class QRCodeException extends AppException {
  const QRCodeException([super.message]);
}

class SubscriptionException extends AppException {
  const SubscriptionException([super.message]);
}

enum AuthErrorCode {
  emailInvalid,
  rateLimit,
  userExists,
  weakPassword,
  invalidCredentials,
  networkError,
  unknown,
}

class AuthException extends AppException {
  final AuthErrorCode code;
  const AuthException([this.code = AuthErrorCode.unknown, super.message]);
}

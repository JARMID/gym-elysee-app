import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';

class ErrorHandler {
  static String getErrorMessage(BuildContext context, Object error) {
    final l10n = AppLocalizations.of(context)!;

    if (error is NetworkException || error is NetworkFailure) {
      return l10n.errorNetwork;
    }

    if (error is ServerException || error is ServerFailure) {
      return l10n.errorServer;
    }

    if (error is AuthException) {
      switch (error.code) {
        case AuthErrorCode.emailInvalid:
          return l10n.authEmailInvalid;
        case AuthErrorCode.rateLimit:
          return l10n.authRateLimit;
        case AuthErrorCode.userExists:
          return l10n.authUserExists;
        case AuthErrorCode.weakPassword:
          return l10n.authWeakPassword;
        default:
          return error.message ?? l10n.errorAuth;
      }
    }

    if (error is AuthFailure) {
      return l10n.errorAuth;
    }

    if (error is CacheException || error is CacheFailure) {
      return l10n.errorCache;
    }

    // Handle string errors (legacy)
    if (error is String) {
      return error;
    }

    return l10n.errorUnknown;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';

import '../enums/exception_origin_types.dart';

class ServerException implements Exception {
  final String message;
  final String code;
  final ExceptionOriginTypes origin;

  ServerException(this.message, this.code, this.origin);
}

class LocalException implements Exception {
  final String message;
  final String code;
  final ExceptionOriginTypes origin;

  LocalException(this.message, this.code, this.origin);
}

ServerException getServerExceptionFromFirebaseAuth(
  FirebaseAuthException exception,
) {
  switch (exception.code) {
    case 'invalid-email':
      return ServerException(
        'firebase-auth-exceptions.invalid-email'.tr(),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
      );
      break;
    case 'user-disabled':
      return ServerException(
        'firebase-auth-exceptions.user-disabled'.tr(),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
      );
      break;
    case 'user-not-found':
      return ServerException(
        'firebase-auth-exceptions.user-not-found'.tr(),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
      );
      break;
    case 'wrong-password':
      return ServerException(
        'auth-exceptions.wrong-password'.tr(),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
      );
      break;
    default:
      return ServerException(
        'generic-exception'.tr(),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
      );
  }
}

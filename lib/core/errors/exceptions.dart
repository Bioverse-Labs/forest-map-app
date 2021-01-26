import 'package:firebase_auth/firebase_auth.dart';
import 'package:forestMapApp/core/util/localized_string.dart';

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
  LocalizedString localizedString,
) {
  switch (exception.code) {
    case 'invalid-email':
      return ServerException(
        localizedString
            .getLocalizedString('firebase-auth-exceptions.invalid-email'),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
      );
      break;
    case 'user-disabled':
      return ServerException(
        localizedString
            .getLocalizedString('firebase-auth-exceptions.user-disabled'),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
      );
      break;
    case 'user-not-found':
      return ServerException(
        localizedString
            .getLocalizedString('firebase-auth-exceptions.user-not-found'),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
      );
      break;
    case 'wrong-password':
      return ServerException(
        localizedString.getLocalizedString('auth-exceptions.wrong-password'),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
      );
      break;
    default:
      return ServerException(
        localizedString.getLocalizedString('generic-exception'),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
      );
  }
}

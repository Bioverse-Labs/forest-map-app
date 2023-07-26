import 'package:firebase_auth/firebase_auth.dart';

import '../enums/exception_origin_types.dart';
import '../util/localized_string.dart';

class ServerException implements Exception {
  final String? message;
  final String code;
  final ExceptionOriginTypes origin;
  final StackTrace? stackTrace;

  ServerException(this.message, this.code, this.origin, {this.stackTrace});
}

class LocalException implements Exception {
  final String? message;
  final String code;
  final ExceptionOriginTypes origin;
  final StackTrace? stackTrace;

  LocalException(this.message, this.code, this.origin, {this.stackTrace});
}

class LocationException implements Exception {
  final String message;
  final bool hasPermission;
  final bool isGpsEnabled;
  final StackTrace? stackTrace;

  LocationException(this.message, this.hasPermission, this.isGpsEnabled,
      {this.stackTrace});
}

ServerException getServerExceptionFromFirebaseAuth(
  FirebaseAuthException exception,
  LocalizedString? localizedString,
) {
  switch (exception.code) {
    case 'invalid-email':
      return ServerException(
        localizedString!.getLocalizedString('auth-exceptions.invalid-email'),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
        stackTrace: exception.stackTrace,
      );
    case 'user-disabled':
      return ServerException(
        localizedString!.getLocalizedString('auth-exceptions.user-disabled'),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
        stackTrace: exception.stackTrace,
      );
    case 'user-not-found':
      return ServerException(
        localizedString!.getLocalizedString('auth-exceptions.user-not-found'),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
        stackTrace: exception.stackTrace,
      );
    case 'wrong-password':
      return ServerException(
        localizedString!.getLocalizedString('auth-exceptions.wrong-password'),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
        stackTrace: exception.stackTrace,
      );
    case 'email-already-in-use':
      return ServerException(
        localizedString!.getLocalizedString('auth-exceptions.email-in-use'),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
        stackTrace: exception.stackTrace,
      );
    default:
      return ServerException(
        localizedString!.getLocalizedString('generic-exception'),
        exception.code,
        ExceptionOriginTypes.firebaseAuth,
        stackTrace: exception.stackTrace,
      );
  }
}

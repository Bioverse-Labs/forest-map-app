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

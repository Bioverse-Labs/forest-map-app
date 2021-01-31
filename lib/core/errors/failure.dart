import 'package:equatable/equatable.dart';
import 'package:forestMapApp/core/enums/exception_origin_types.dart';

abstract class Failure extends Equatable {
  final List properties;

  Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

// General Failures
class ServerFailure extends Failure {
  final String message;
  final String code;
  final ExceptionOriginTypes origin;
  final StackTrace stackTrace;

  ServerFailure(this.message, this.code, this.origin, {this.stackTrace})
      : super([
          message,
          code,
          origin,
          stackTrace,
        ]);
}

class LocalFailure extends Failure {
  final String message;
  final String code;
  final ExceptionOriginTypes origin;

  LocalFailure(this.message, this.code, this.origin)
      : super([
          message,
          code,
          origin,
        ]);
}

class NoInternetFailure extends Failure {}

class CameraCancelFailure extends Failure {}

class CameraFailure extends Failure {}

class LocationFailure extends Failure {
  final String message;

  LocationFailure(this.message) : super([message]);
}

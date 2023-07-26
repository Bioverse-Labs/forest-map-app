import 'package:equatable/equatable.dart';

import '../enums/exception_origin_types.dart';

abstract class Failure extends Equatable {
  final List properties;

  Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

// General Failures
class ServerFailure extends Failure {
  final String? message;
  final String code;
  final ExceptionOriginTypes origin;
  final StackTrace? stackTrace;

  ServerFailure(this.message, this.code, this.origin, {this.stackTrace})
      : super([
          message,
          code,
          origin,
          stackTrace,
        ]);
}

class LocalFailure extends Failure {
  final String? message;
  final String code;
  final ExceptionOriginTypes origin;
  final StackTrace? stackTrace;

  LocalFailure(this.message, this.code, this.origin, {this.stackTrace})
      : super([
          message,
          code,
          origin,
          stackTrace,
        ]);
}

class NoInternetFailure extends Failure {}

class CameraCancelFailure extends Failure {}

class CameraFailure extends Failure {}

class LocationFailure extends Failure {
  final String message;
  final bool hasPermission;
  final bool isGPSEnabled;
  final StackTrace? stackTrace;

  LocationFailure(this.message, this.hasPermission, this.isGPSEnabled,
      {this.stackTrace})
      : super([
          message,
          hasPermission,
          isGPSEnabled,
          stackTrace,
        ]);
}

class GenericFailure extends Failure {
  GenericFailure(List<dynamic> properties) : super(properties);
}

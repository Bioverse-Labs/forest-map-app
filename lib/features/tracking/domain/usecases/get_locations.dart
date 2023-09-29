import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/location.dart';
import '../repositories/location_repository.dart';

class GetLocationsParams extends Equatable {
  final String? userId;

  GetLocationsParams(this.userId);

  @override
  List<Object?> get props => [userId];
}

class GetLocations implements UseCase<List<Location>, GetLocationsParams> {
  final LocationRepository? _repository;

  GetLocations(this._repository);

  @override
  Future<Either<Failure, List<Location>>> call(GetLocationsParams params) {
    return _repository!.getLocations(params.userId);
  }
}

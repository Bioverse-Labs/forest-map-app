import 'package:forest_map/features/tracking/data/models/location_model.dart';

import '../../../../core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/location_repository.dart';

import 'package:equatable/equatable.dart';

class SaveLocationParams extends Equatable {
  final String? userId;
  final LocationModel location;

  SaveLocationParams({
    required this.userId,
    required this.location,
  });

  @override
  List<Object?> get props => [userId, location];
}

class SaveLocation implements UseCase<void, SaveLocationParams> {
  final LocationRepository? _repository;

  SaveLocation(this._repository);

  @override
  Future<Either<Failure, void>> call(SaveLocationParams params) {
    return _repository!.saveLocation(params.userId, params.location);
  }
}

import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:forest_map_app/features/map/domain/entities/geolocation_data_properties.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../organization/domain/entities/organization.dart';
import '../../domain/usecases/get_geolocation_data.dart';
import '../../domain/usecases/get_geolocation_files.dart';

abstract class MapNotifier {
  Future<void> getGeolocationData(Organization organization);
  Future<void> getGeolocationFiles(Organization organization);
}

class MapNotifierImpl extends ChangeNotifier implements MapNotifier {
  final GetGeolocationData getGeolocationDataUseCase;
  final GetGeolocationFiles getGeolocationFilesUseCase;

  MapNotifierImpl({
    @required this.getGeolocationDataUseCase,
    @required this.getGeolocationFilesUseCase,
  });

  bool _loading = false;
  bool get isLoading => _loading;

  bool _hasCompleted = false;
  bool get hasCompleted => _hasCompleted;

  List<File> _files = [];
  List<File> get geolocationFiles => _files;

  StreamController<Either<Failure, List<GeolocationDataProperties>>>
      // ignore: close_sinks
      _geoStrController =
      StreamController<Either<Failure, List<GeolocationDataProperties>>>();
  StreamController<Either<Failure, List<GeolocationDataProperties>>>
      get geoStrController => _geoStrController;

  StreamController<Either<Failure, File>> _filestrController;

  int _currentZoom = 16;
  int get currentZoom => _currentZoom;

  @override
  Future<void> getGeolocationData(
    Organization organization,
  ) async {
    final failureOrOrganization = await getGeolocationDataUseCase(
      GetGeolocationDataParams(
        organization: organization,
        files: _files,
        strController: _geoStrController,
      ),
    );

    failureOrOrganization?.fold((failure) => throw failure, (r) => null);
  }

  @override
  Future<void> getGeolocationFiles(Organization organization) async {
    if (organization.geolocationData.length > 0) {
      _loading = true;
      _hasCompleted = false;
      _files = [];
      notifyListeners();

      _filestrController?.sink?.close();

      final failureOrStream = await getGeolocationFilesUseCase(
        GetGeolocationFilesParams(organization: organization),
      );

      failureOrStream.fold(
        (failure) => throw failure,
        (strController) {
          _filestrController = strController;
          strController.stream.listen((failureOrFile) {
            failureOrFile.fold(
              (failure) => throw failure,
              (file) {
                _files.add(file);
                if (_files.length == organization.geolocationData.length) {
                  strController.sink.close();
                  _loading = false;
                  _hasCompleted = true;
                  notifyListeners();
                }
              },
            );
          });
        },
      );
    }
  }

  void setZoom(int zoom) {
    _currentZoom = zoom;
    notifyListeners();
  }
}

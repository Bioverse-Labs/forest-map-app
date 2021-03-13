import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../../../core/errors/failure.dart';
import '../../../organization/domain/entities/organization.dart';
import '../../domain/usecases/get_geolocation_data.dart';
import '../../domain/usecases/get_geolocation_files.dart';

abstract class MapNotifier {
  Future<Either<Failure, Organization>> getGeolocationData(
    Organization organization,
  );
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

  StreamController<Either<Failure, File>> _strController;

  @override
  Future<Either<Failure, Organization>> getGeolocationData(
    Organization organization,
  ) async {
    _loading = true;
    notifyListeners();

    final failureOrOrganization = await getGeolocationDataUseCase(
      GetGeolocationDataParams(organization: organization),
    );

    _loading = false;
    notifyListeners();

    return failureOrOrganization;
  }

  @override
  Future<void> getGeolocationFiles(Organization organization) async {
    if (organization.geolocationData.length > 0) {
      _loading = true;
      _hasCompleted = false;
      _files = [];
      notifyListeners();

      _strController?.sink?.close();

      final failureOrStream = await getGeolocationFilesUseCase(
        GetGeolocationFilesParams(organization: organization),
      );

      failureOrStream.fold(
        (failure) => throw failure,
        (strController) {
          _strController = strController;
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
}

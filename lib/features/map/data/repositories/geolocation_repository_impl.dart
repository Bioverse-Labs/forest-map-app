import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../../core/adapters/firebase_storage_adapter.dart';
import '../../../../core/adapters/http_adapter.dart';
import '../../../../core/enums/exception_origin_types.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/util/dir.dart';
import '../../../../core/util/geojson.dart';
import '../../../../core/util/geojson_to_model.dart';
import '../../../../core/util/localized_string.dart';
import '../../../organization/data/models/organization_model.dart';
import '../../../organization/domain/entities/organization.dart';
import '../../domain/repositories/geolocation_repository.dart';

class GeolocationRepositoryImpl implements GeolocationRepository {
  final FirebaseStorageAdapterImpl firebaseStorageAdapter;
  final HttpAdapter httpAdapter;
  final GeoJsonUtils geoJsonUtils;
  final DirUtils dirUtils;
  final LocalizedString localizedString;

  GeolocationRepositoryImpl({
    @required this.firebaseStorageAdapter,
    @required this.httpAdapter,
    @required this.geoJsonUtils,
    @required this.dirUtils,
    @required this.localizedString,
  });

  @override
  Future<Either<Failure, OrganizationModel>> getGeolocationData(
    Organization organization,
  ) async {
    try {
      final params = {
        'geolocationData':
            organization.geolocationData.map<String>((e) => e).toList(),
        'storageAdapter': firebaseStorageAdapter,
        'httpAdapter': httpAdapter,
        'geoJsonUtils': geoJsonUtils,
        'docDir': await dirUtils.getDocumentsDirectory(),
        'localizedStrings': localizedString,
      };

      final geodata = await parseGeoJsonToModel(params);

      return Right(OrganizationModel.fromEntity(organization)
          .copyWith(geolocationData: geodata));
    } catch (error) {
      return Left(GenericFailure([error, error.toString()]));
    }
  }

  @override
  Future<Either<Failure, StreamController<Either<Failure, File>>>>
      getGolocationFiles(
    Organization organization,
  ) async {
    if (organization.geolocationData.length > 0) {
      final docDir = await dirUtils.getDocumentsDirectory();
      // ignore: close_sinks
      final strController = StreamController<Either<Failure, File>>();

      organization.geolocationData.forEach((filename) async {
        try {
          final localFile = File('${docDir.path}/$filename.geojson');

          if (!await localFile.exists()) {
            await localFile.create();
            final downloadUrl = await firebaseStorageAdapter.getDownloadUrl(
              '/geolocation-data/$filename.geojson',
            );
            final resp = await httpAdapter.downloadFile(downloadUrl);
            await localFile.writeAsBytes(resp.readAsBytesSync());
          }

          strController.sink.add(Right(localFile));
        } on FirebaseException catch (error) {
          strController.sink.add(Left(ServerFailure(
            error.message,
            error.code,
            ExceptionOriginTypes.firebaseStorage,
            stackTrace: error.stackTrace,
          )));
        } catch (error) {
          strController.sink.add(Left(LocalFailure(
            error?.message,
            error?.code,
            ExceptionOriginTypes.unkown,
            stackTrace: StackTrace.fromString(error.toString()),
          )));
        }
      });

      return Right(strController);
    }

    return null;
  }
}

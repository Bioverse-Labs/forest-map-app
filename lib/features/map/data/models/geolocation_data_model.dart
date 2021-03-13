import 'package:meta/meta.dart';

import '../../../../core/models/model.dart';
import '../../domain/entities/geolocation_data.dart';
import '../../domain/entities/geolocation_data_properties.dart';
import '../hive/geolocation_data.dart';
import '../hive/geolocation_data_properties.dart';
import 'geolocation_data_properties_model.dart';

class GeolocationDataModel extends GeolocationData
    implements Model<GeolocationDataModel, GeolocationDataHive> {
  GeolocationDataModel({
    @required String name,
    @required List<GeolocationDataProperties> dataProperties,
  }) : super(name: name, dataProperties: dataProperties);

  factory GeolocationDataModel.fromMap(Map<String, dynamic> map) {
    return GeolocationDataModel(
      name: map['name'],
      dataProperties: map['dataProperties'],
    );
  }

  factory GeolocationDataModel.fromEntity(GeolocationData geolocationData) {
    return GeolocationDataModel(
      name: geolocationData.name,
      dataProperties: geolocationData.dataProperties,
    );
  }

  factory GeolocationDataModel.fromHive(
    GeolocationDataHive geolocationDataHive,
  ) {
    return GeolocationDataModel(
      name: geolocationDataHive.name,
      dataProperties: geolocationDataHive.dataProperties
          .map((dataHive) => GeolocationDataPropertiesModel.fromHive(dataHive))
          .toList(),
    );
  }

  @override
  GeolocationDataModel copyWith(
      {String name, List<GeolocationDataProperties> dataProperties}) {
    return GeolocationDataModel(
      name: name,
      dataProperties: dataProperties ?? this.dataProperties,
    );
  }

  @override
  GeolocationDataHive toHiveAdapter() {
    return GeolocationDataHive()
      ..name = name
      ..dataProperties = dataProperties
          .map<GeolocationDataPropertiesHive>(
            (property) => GeolocationDataPropertiesModel.fromEntity(
              property,
            ).toHiveAdapter(),
          )
          .toList();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dataProperties': dataProperties,
    };
  }
}

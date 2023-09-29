import 'package:hive/hive.dart';

import '../enums/exception_origin_types.dart';
import '../errors/exceptions.dart';

class HiveAdapter<T> {
  final String boxName;
  final HiveInterface hive;
  late LazyBox<T> _box;

  HiveAdapter(this.boxName, this.hive);

  Future<void> init() async {
    final box = await hive.openLazyBox<T>(boxName);
    _box = box;
  }

  Future<void> close() => _box.close();

  Future<T?> get(String? id) async {
    try {
      final res = await _box.get(id);

      return res;
    } on HiveError catch (error) {
      throw LocalException(
        error.message,
        'get',
        ExceptionOriginTypes.hive,
        stackTrace: error.stackTrace,
      );
    } catch (error) {
      throw LocalException(
        error.toString(),
        'get',
        ExceptionOriginTypes.hive,
        stackTrace: StackTrace.fromString(error.toString()),
      );
    }
  }

  Iterable<dynamic> getKeys() {
    try {
      return _box.keys;
    } on HiveError catch (error) {
      throw LocalException(
        error.message,
        'get',
        ExceptionOriginTypes.hive,
        stackTrace: error.stackTrace,
      );
    }
  }

  Future<void> put(String? id, T payload) async {
    try {
      return _box.put(id, payload);
    } on HiveError catch (error) {
      throw LocalException(
        error.message,
        'save',
        ExceptionOriginTypes.hive,
        stackTrace: error.stackTrace,
      );
    }
  }

  Future<void> delete(String? id) async {
    try {
      return _box.delete(id);
    } on HiveError catch (error) {
      throw LocalException(
        error.message,
        'save',
        ExceptionOriginTypes.hive,
        stackTrace: error.stackTrace,
      );
    }
  }

  Future<void> deleteAll() async {
    try {
      final keys = _box.keys;
      keys.forEach((key) async {
        await _box.delete(key);
      });
    } on HiveError catch (error) {
      throw LocalException(
        error.message,
        'save',
        ExceptionOriginTypes.hive,
        stackTrace: error.stackTrace,
      );
    }
  }
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:forest_map/core/platform/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([
  DataConnectionChecker,
  Connectivity,
])
void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockConnectivity mockConnectivity;
  late MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    mockConnectivity = MockConnectivity();
    networkInfoImpl = NetworkInfoImpl(
      mockDataConnectionChecker,
      mockConnectivity,
    );
  });

  group('NetworkInfo', () {
    group('isConnected', () {
      test(
        'should forward the function call to DataConnectionChecker.hasConnection',
        () async {
          when(mockDataConnectionChecker.hasConnection)
              .thenAnswer((_) => Future.value(true));

          final result = await networkInfoImpl.isConnected;
          verify(mockDataConnectionChecker.hasConnection);
          expect(result, true);
        },
      );
    });

    group('isWifi', () {
      test(
        'should return true when ConnectivityResult is wifi',
        () async {
          when(mockConnectivity.checkConnectivity())
              .thenAnswer((_) async => ConnectivityResult.wifi);

          final result = await networkInfoImpl.isWifi;

          verify(mockConnectivity.checkConnectivity());
          expect(result, true);
        },
      );
    });
  });
}

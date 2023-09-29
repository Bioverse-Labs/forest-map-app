import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:forest_map/core/platform/network_info.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockConnectivity mockConnectivity;
  MockDataConnectionChecker mockDataConnectionChecker;

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
          final tHasConnectionFuture = Future.value(true);
          when(mockDataConnectionChecker.hasConnection)
              .thenAnswer((_) => tHasConnectionFuture);

          final result = networkInfoImpl.isConnected;
          verify(mockDataConnectionChecker.hasConnection);
          expect(result, tHasConnectionFuture);
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

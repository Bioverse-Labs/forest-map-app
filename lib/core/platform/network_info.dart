import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Future<bool> get isWifi;
  Stream<DataConnectionStatus> get connectionStatusStream;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker connectionChecker;
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectionChecker, this.connectivity);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;

  @override
  Future<bool> get isWifi async =>
      (await connectivity.checkConnectivity()) == ConnectivityResult.wifi;

  @override
  Stream<DataConnectionStatus> get connectionStatusStream =>
      connectionChecker.onStatusChange;
}

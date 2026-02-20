import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;

  Stream<InternetConnectionStatus> get onStatusChange;
}

class NetworkInfoWeb implements NetworkInfo {
  @override
  Future<bool> get isConnected => Future.value(true);

  @override
  Stream<InternetConnectionStatus> get onStatusChange => const Stream.empty();
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async => await connectionChecker.hasConnection;

  @override
  Stream<InternetConnectionStatus> get onStatusChange =>
      connectionChecker.onStatusChange;
}

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkService {
  static Stream<bool> get connectivityStream async* {
    await for (var _ in Connectivity().onConnectivityChanged) {
      bool connected = await InternetConnectionChecker().hasConnection;
      yield connected;
    }
  }
}

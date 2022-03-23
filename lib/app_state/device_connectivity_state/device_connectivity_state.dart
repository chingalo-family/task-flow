import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceConnectivityState with ChangeNotifier {
  bool? _isConnectedToNetwork = false;

  bool? get connectivityStatus => _isConnectedToNetwork;

  void changeConnectivityStatus({bool? isConnected}) {
    _isConnectedToNetwork = isConnected;
    notifyListeners();
  }

  void initializeConnectionStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    _isConnectedToNetwork = connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
    notifyListeners();
  }
}

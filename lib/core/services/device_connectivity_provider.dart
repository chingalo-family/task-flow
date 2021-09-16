import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/app_state/device_connectivity_state/device_connectivity_state.dart';
import 'package:provider/provider.dart';

class DeviceConnectivityProvider {
  StreamSubscription checkChangeOfDeviceConnectionStatus(BuildContext context) {
    return Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) async {
      if (connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile) {
        Provider.of<DeviceConnectivityState>(context, listen: false)
            .changeConnectivityStatus(isConnected: true);
      } else if (connectivityResult == ConnectivityResult.none) {
        Provider.of<DeviceConnectivityState>(context, listen: false)
            .changeConnectivityStatus(isConnected: false);
      } else {
        Provider.of<DeviceConnectivityState>(context, listen: false)
            .changeConnectivityStatus(isConnected: false);
      }
    });
  }
}

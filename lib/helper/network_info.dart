import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../features/splash/controllers/splash_controller.dart';
import '../main.dart';

class NetworkInfo {
  final Connectivity connectivity;
  NetworkInfo(this.connectivity);

  Future<bool> get isConnected async {
    final results = await connectivity.checkConnectivity();
    if (results.isEmpty) return false;
    return !results.contains(ConnectivityResult.none);
  }

  static void checkConnectivity(BuildContext context) {
    final Connectivity connectivity = Connectivity();

    connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final bool isNotConnected = results.contains(ConnectivityResult.none) || results.isEmpty;

      final splashController = Provider.of<SplashController>(Get.context!, listen: false);

      if (splashController.firstTimeConnectionCheck) {
        splashController.setFirstTimeConnectionCheck(false);
        return;
      }

      // Hide previous snack bar
      isNotConnected? SizedBox() : ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

      // Show connection status
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'No connection' : 'Connected',
            textAlign: TextAlign.center,
          ),
        ),
      );
    });
  }
}


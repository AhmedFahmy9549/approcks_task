import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class ConnectivityChecker with ChangeNotifier {
  String _connectivityState = '';

  // ignore: cancel_subscriptions
  StreamSubscription<ConnectivityResult> subscription;

  String get connectivityState => _connectivityState;

  void checkConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      switch (result.index) {
        case 0:
          _connectivityState = 'wifi';
          notifyListeners();
          break;
        case 1:
          _connectivityState = 'cellular';
          notifyListeners();
          break;
        case 2:
          _connectivityState = 'disconnected';
          notifyListeners();
          break;
        default:
          _connectivityState = 'disconnected';
          notifyListeners();
          break;
      }
    });
  }

  void cancelSubscription() => subscription.cancel();
}

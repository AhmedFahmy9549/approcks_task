import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationServices {
  var location = new Location();
  SharedPreferences pref;

  Future<LocationData> getLocation() async {
    LocationData currentLocation;

    try {
      currentLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
      currentLocation = null;
    }
    saveToSharedPref(currentLocation);
    return currentLocation;
  }

  Future<bool> requestForPermission() async {
    bool checker = await location.requestPermission();
    return checker;
  }

  Future<bool> checkHasPermission() async {
    return await location.hasPermission();
  }

  Future<bool> checkServiceEnabled() async {
    return await location.serviceEnabled();
  }

  void saveToSharedPref(currentLocation) async {
    pref = await SharedPreferences.getInstance();
    pref.setDouble("long", currentLocation.longitude);
    pref.setDouble("lat", currentLocation.latitude);
  }
}

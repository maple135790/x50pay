import 'dart:math' as math;

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:location/location.dart';
import 'package:x50pay/repository/repository.dart';

enum RemoteOpenShop {
  firstShop((lat: 25.0455991, lng: 121.5027702), doorName: 'door'),
  secondShop((lat: 25.0455991, lng: 121.5027702), doorName: 'door2');

  final ({double lat, double lng}) location;
  final String doorName;
  const RemoteOpenShop(this.location, {required this.doorName});
}

mixin RemoteOpenMixin {
  /// Radius of the earth in km
  static const R = 6371;
  final _repo = Repository();
  final _location = Location();

  double _deg2rad(double deg) => deg * (math.pi / 180);

  double _getDistance(double lat1, double lng1, double lat2, double lng2) {
    var dLat = _deg2rad(lat2 - lat1); // deg2rad below
    var dLon = _deg2rad(lng2 - lng1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(lat1)) *
            math.cos(_deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var d = R * c; // Distance in km
    return d;
  }

  void checkRemoteOpen({required RemoteOpenShop shop}) async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    EasyLoading.show();

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        await EasyLoading.dismiss();
        return;
      }
    }

    locationData = await _location.getLocation();
    double myLat = locationData.latitude!;
    double myLng = locationData.longitude!;
    String result = await _repo.remoteOpenDoor(
      _getDistance(25.0455991, 121.5027702, myLat, myLng),
      doorName: shop.doorName,
    );
    EasyLoading.dismiss();
    await Future.delayed(const Duration(milliseconds: 250));
    EasyLoading.showInfo(result.replaceFirst(',', '\n'));
  }
}

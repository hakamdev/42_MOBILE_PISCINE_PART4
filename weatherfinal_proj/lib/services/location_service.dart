import 'package:location/location.dart';

class LocationService {
  // Singleton stuff
  LocationService._();

  static final LocationService _instance = LocationService._();

  static LocationService get instance => _instance;

  final Location _location = Location();
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;

  Future<bool> init() async {
    // Check and enable location service if not enabled
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return Future.error("Location Service couldn't be enabled!");
      }
    }

    // Check and accept location permission if not accepted
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        if (_permissionGranted == PermissionStatus.denied) {
          return Future.error("Permission to access location was denied!");
        } else if (_permissionGranted == PermissionStatus.deniedForever) {
          return Future.error(
              "Permission to access location was permanently denied and can only be accepted from System settings.");
        }
      }
    }

    return true;
  }

  Future<LocationData?> getLocation() async {
    if (!_serviceEnabled || _permissionGranted != PermissionStatus.granted) {
        final result = await init();
        if (result == true) {
          return getLocation();
        }
        return null;
    }
    return _location.getLocation();
  }
}

import 'package:geolocator/geolocator.dart';

class EmergencyLocationService {
  const EmergencyLocationService._();

  static const String permissionMessage =
      'Please allow location permission to share your location.';

  static Future<EmergencyLocationData?> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return null;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    return EmergencyLocationData.fromPosition(position);
  }
}

class EmergencyLocationData {
  const EmergencyLocationData({
    required this.latitude,
    required this.longitude,
  });

  factory EmergencyLocationData.fromPosition(Position position) {
    return EmergencyLocationData(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  final double latitude;
  final double longitude;

  String get googleMapsLink =>
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
}

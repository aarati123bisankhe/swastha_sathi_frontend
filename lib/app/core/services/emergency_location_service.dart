import 'dart:async';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class EmergencyLocationService {
  const EmergencyLocationService._();

  static const String permissionMessage =
      'Please allow location permission to share your location.';

  static Future<EmergencyLocationData?> getCurrentLocation({
    String? fallbackDistrict,
  }) async {
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

    return enrichPosition(position, fallbackDistrict: fallbackDistrict);
  }

  static Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 15,
      ),
    );
  }

  static Future<EmergencyLocationData> enrichPosition(
    Position position, {
    String? fallbackDistrict,
  }) async {
    final reverseGeocoded = await _reverseGeocode(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    return EmergencyLocationData.fromPosition(
      position,
      city: reverseGeocoded?.city ?? fallbackDistrict ?? 'Current city',
      province: reverseGeocoded?.province ?? 'Current province',
      address: reverseGeocoded?.address ?? _buildFallbackAddress(position),
    );
  }

  static Future<_ReverseGeocodeResult?> _reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final dio = Dio(
        BaseOptions(
          headers: {'User-Agent': 'Swasthasathi Live Location/1.0'},
          receiveTimeout: const Duration(seconds: 10),
          connectTimeout: const Duration(seconds: 10),
        ),
      );

      final response = await dio.get<Map<String, dynamic>>(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'jsonv2',
          'lat': latitude,
          'lon': longitude,
        },
      );

      final data = response.data ?? {};
      final addressData = data['address'] as Map<String, dynamic>? ?? {};

      final city =
          addressData['city']?.toString() ??
          addressData['town']?.toString() ??
          addressData['village']?.toString() ??
          addressData['municipality']?.toString() ??
          addressData['county']?.toString();
      final province =
          addressData['state']?.toString() ??
          addressData['region']?.toString() ??
          addressData['state_district']?.toString();
      final address =
          data['display_name']?.toString() ??
          [
            city,
            province,
          ].whereType<String>().where((item) => item.isNotEmpty).join(', ');

      if ((city == null || city.isEmpty) &&
          (province == null || province.isEmpty) &&
          address.isEmpty) {
        return null;
      }

      return _ReverseGeocodeResult(
        city: city,
        province: province,
        address: address,
      );
    } catch (_) {
      return null;
    }
  }

  static String _buildFallbackAddress(Position position) {
    return 'Lat ${position.latitude.toStringAsFixed(5)}, '
        'Lng ${position.longitude.toStringAsFixed(5)}';
  }
}

class EmergencyLocationData {
  const EmergencyLocationData({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.province,
    required this.address,
    required this.accuracy,
  });

  factory EmergencyLocationData.fromPosition(
    Position position, {
    required String city,
    required String province,
    required String address,
  }) {
    return EmergencyLocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      city: city,
      province: province,
      address: address,
      accuracy: position.accuracy,
    );
  }

  final double latitude;
  final double longitude;
  final String city;
  final String province;
  final String address;
  final double accuracy;

  String get cityProvinceLabel => '$city, $province';
  String get addressLabel => address;

  String get googleMapsLink =>
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
}

class _ReverseGeocodeResult {
  const _ReverseGeocodeResult({
    required this.city,
    required this.province,
    required this.address,
  });

  final String? city;
  final String? province;
  final String address;
}

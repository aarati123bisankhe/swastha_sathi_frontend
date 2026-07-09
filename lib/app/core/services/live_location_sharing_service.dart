import 'dart:async';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:swasthasathi/app/core/api/api_client.dart';
import 'package:swasthasathi/app/core/api/api_endpoints.dart';
import 'package:swasthasathi/app/core/services/emergency_location_service.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';

class LiveLocationSharingService {
  LiveLocationSharingService._();

  static final LiveLocationSharingService instance =
      LiveLocationSharingService._();

  final ApiClient _apiClient = ApiClient();

  StreamSubscription<Position>? _positionSubscription;
  LiveLocationSession? _activeSession;
  DateTime? _lastBackendUpdateAt;
  bool _isStarting = false;

  bool get isSharing => _activeSession != null;
  LiveLocationSession? get activeSession => _activeSession;

  Future<LiveLocationSession> startSharing({
    required AuthUser? user,
    required EmergencyLocationData location,
  }) async {
    if (_activeSession != null) {
      return _activeSession!;
    }

    if (_isStarting) {
      throw const LiveLocationException('Live location is already starting.');
    }

    _isStarting = true;

    try {
      final response = await _apiClient.post(
        ApiEndpoints.locationStart,
        data: {
          'userId': user?.id.trim().isNotEmpty == true
              ? user!.id.trim()
              : 'guest',
          'name': user?.fullName.trim().isNotEmpty == true
              ? user!.fullName.trim()
              : 'Emergency User',
          'phone': user?.phoneNumber.trim().isNotEmpty == true
              ? user!.phoneNumber.trim()
              : 'Not provided',
          'latitude': location.latitude,
          'longitude': location.longitude,
          'address': location.addressLabel,
        },
      );

      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      final session = LiveLocationSession(
        shareId: data['shareId'] as String? ?? '',
        trackingLink: data['trackingLink'] as String? ?? '',
        status: data['status'] as String? ?? 'active',
      );

      _activeSession = session;
      _lastBackendUpdateAt = DateTime.now();
      await _startPositionUpdates(user: user);
      return session;
    } on DioException catch (error) {
      throw LiveLocationException(_extractApiError(error));
    } finally {
      _isStarting = false;
    }
  }

  Future<void> stopSharing() async {
    final session = _activeSession;
    if (session == null) {
      return;
    }

    try {
      await _apiClient.put(
        ApiEndpoints.locationStop,
        data: {'shareId': session.shareId},
      );
    } on DioException catch (error) {
      throw LiveLocationException(_extractApiError(error));
    } finally {
      await _positionSubscription?.cancel();
      _positionSubscription = null;
      _activeSession = null;
      _lastBackendUpdateAt = null;
    }
  }

  Future<void> sendShareContact({
    required String userId,
    required String shareId,
    required String trackingLink,
    required String message,
  }) async {
    try {
      await _apiClient.post(
        ApiEndpoints.locationShareContact,
        data: {
          'userId': userId,
          'shareId': shareId,
          'trackingLink': trackingLink,
          'message': message,
        },
      );
    } on DioException catch (error) {
      throw LiveLocationException(_extractApiError(error));
    }
  }

  Future<void> dispose() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  Future<void> _startPositionUpdates({required AuthUser? user}) async {
    await _positionSubscription?.cancel();

    _positionSubscription = EmergencyLocationService.getPositionStream().listen(
      (position) async {
        final session = _activeSession;
        if (session == null) {
          return;
        }

        final lastUpdated = _lastBackendUpdateAt;
        if (lastUpdated != null &&
            DateTime.now().difference(lastUpdated) <
                const Duration(seconds: 10)) {
          return;
        }

        try {
          final location = await EmergencyLocationService.enrichPosition(
            position,
            fallbackDistrict: user?.district,
          );

          await _apiClient.put(
            ApiEndpoints.locationUpdate,
            data: {
              'shareId': session.shareId,
              'latitude': location.latitude,
              'longitude': location.longitude,
              'address': location.addressLabel,
            },
          );

          _lastBackendUpdateAt = DateTime.now();
        } catch (_) {
          // Keep the stream alive even if one backend update fails.
        }
      },
      onError: (_) {},
    );
  }

  String _extractApiError(DioException error) {
    final data = error.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString().trim();
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }

    return 'Unable to complete live location sharing right now.';
  }
}

class LiveLocationSession {
  const LiveLocationSession({
    required this.shareId,
    required this.trackingLink,
    required this.status,
  });

  final String shareId;
  final String trackingLink;
  final String status;
}

class LiveLocationException implements Exception {
  const LiveLocationException(this.message);

  final String message;

  @override
  String toString() => message;
}

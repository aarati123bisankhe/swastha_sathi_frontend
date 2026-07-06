import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();
  static const int port = 6000;

  // Runtime overrides:
  // 1) Physical devices (Android + iOS):
  //    flutter run --dart-define=API_HOST=192.168.1.70
  // 2) Android emulator:
  //    flutter run --dart-define=API_HOST_ANDROID=10.0.2.2
  // 3) iOS simulator:
  //    flutter run --dart-define=API_HOST_IOS=localhost
  // 4) Full URL override (highest priority):
  //    flutter run --dart-define=API_BASE_URL=http://192.168.1.70:6060/api
  //    flutter run --dart-define=API_UPLOAD_BASE_URL=http://192.168.1.70:6060
  static const String apiBaseUrlOverride = String.fromEnvironment(
    'API_BASE_URL',
  );
  static const String apiUploadBaseUrlOverride = String.fromEnvironment(
    'API_UPLOAD_BASE_URL',
  );
  static const String apiHost = String.fromEnvironment('API_HOST');
  static const String apiHostAndroid = String.fromEnvironment(
    'API_HOST_ANDROID',
  );
  static const String apiHostIos = String.fromEnvironment('API_HOST_IOS');

  static const String computerIpAddress = "192.168.18.41";

  // static String get baseUrl {
  //   if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
  //     return "http://$computerIpAddress:$port/api";
  //   }

  //   // if (kIsWeb) {
  //   //   return "http://localhost:$port/api";
  //   // }

  //   if (Platform.isAndroid) {
  //     return "http://10.0.2.2:$port/api";
  //   }

  //   if (Platform.isIOS) {
  //     return "http://localhost:$port/api";
  //   }

  //   return "http://localhost:$port/api";
  // }
  static String get baseUrl {
    final override = _normalizeAbsoluteUrl(apiBaseUrlOverride);
    if (override != null) {
      return override;
    }
    return "http://${_resolveHost()}:$port/api";
  }

  static String get uploadBaseUrl {
    final override = _normalizeAbsoluteUrl(apiUploadBaseUrlOverride);
    if (override != null) {
      return override;
    }
    return "http://${_resolveHost()}:$port";
  }

  static void debugPrintResolvedEndpoints() {
    // Use this in app startup when diagnosing device connectivity issues.
    // ignore: avoid_print
    print('ApiEndpoints.baseUrl=$baseUrl');
    // ignore: avoid_print
    print('ApiEndpoints.uploadBaseUrl=$uploadBaseUrl');
  }

  static String _resolveHost() {
    // Web always talks to localhost in local setup.
    if (kIsWeb) return 'localhost';

    // Global override first.
    if (apiHost.trim().isNotEmpty) return apiHost.trim();

    // Platform-specific overrides.
    if (Platform.isAndroid && apiHostAndroid.trim().isNotEmpty) {
      return apiHostAndroid.trim();
    }
    if (Platform.isIOS && apiHostIos.trim().isNotEmpty) {
      return apiHostIos.trim();
    }

    // Android emulators reach the host machine through 10.0.2.2.
    if (Platform.isAndroid) return '10.0.2.2';

    // iOS simulators can use localhost directly.
    if (Platform.isIOS) return 'localhost';

    // Desktop and physical-device fallback.
    return computerIpAddress;
  }

  static String? _normalizeAbsoluteUrl(String raw) {
    final value = raw.trim().replaceAll('"', '').replaceAll("'", '');
    if (value.isEmpty) return null;

    final repaired = value
        .replaceFirst(RegExp(r'^hwhattp://', caseSensitive: false), 'http://')
        .replaceFirst(RegExp(r'^htttp://', caseSensitive: false), 'http://')
        .replaceFirst(RegExp(r'^ttp://', caseSensitive: false), 'http://');

    final uri = Uri.tryParse(repaired);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return null;
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return null;
    }
    return repaired;
  }

  static String uploadUrl(String relativePath) {
    if (relativePath.startsWith('http')) return relativePath;
    final normalized = relativePath.replaceAll('\\', '/').trim();
    final cleaned = normalized.startsWith('/')
        ? normalized.substring(1)
        : normalized;
    return "$uploadBaseUrl/$cleaned";
  }

  /// Profile image URL
  static String profileImageUrl(String fileName) {
    if (fileName.startsWith('http')) return fileName;
    if (fileName.contains('/') || fileName.contains('\\')) {
      return uploadUrl(fileName);
    }

    // if (isPhysicalDevice) {
    //   return "http://$computerIpAddress:$port/uploads/profile/$fileName";
    // }

    return uploadUrl("uploads/profile/$fileName");
  }

  /// Cover image URL
  static String coverImageUrl(String fileName) {
    if (fileName.startsWith('http')) return fileName;
    if (fileName.contains('/') || fileName.contains('\\')) {
      return uploadUrl(fileName);
    }

    // if (isPhysicalDevice) {
    //   return "http://$computerIpAddress:$port/uploads/cover/$fileName";
    // }

    return uploadUrl("uploads/cover/$fileName");
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String login = '/auth/login';
  static const String signup = '/auth/register';
}

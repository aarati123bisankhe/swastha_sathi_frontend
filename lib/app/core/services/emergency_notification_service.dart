import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class EmergencyNotificationService {
  const EmergencyNotificationService._();

  static const String _storageKey = 'emergency_notifications';

  static Future<List<EmergencyNotificationItem>> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    final savedItems = raw == null || raw.isEmpty
        ? <EmergencyNotificationItem>[]
        : (jsonDecode(raw) as List<dynamic>)
              .map(
                (item) => EmergencyNotificationItem.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList();

    return [...savedItems, ..._defaultNotifications];
  }

  static Future<void> addSosSentNotification() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await loadSavedNotificationsOnly();

    existing.insert(
      0,
      EmergencyNotificationItem(
        title: 'Emergency SOS Sent',
        subtitle:
            'Your emergency contacts have been notified with your location.',
        type: EmergencyNotificationType.ambulance,
        createdAt: DateTime.now(),
      ),
    );

    await prefs.setString(
      _storageKey,
      jsonEncode(existing.map((item) => item.toJson()).toList()),
    );
  }

  static Future<List<EmergencyNotificationItem>>
  loadSavedNotificationsOnly() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    if (raw == null || raw.isEmpty) {
      return <EmergencyNotificationItem>[];
    }

    return (jsonDecode(raw) as List<dynamic>)
        .map(
          (item) =>
              EmergencyNotificationItem.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  static List<EmergencyNotificationItem> get _defaultNotifications {
    final now = DateTime.now();

    return [
      EmergencyNotificationItem(
        title: 'Urgent Blood Needed',
        subtitle: 'O+ Blood required at Bir Hospital for emergency surgery',
        type: EmergencyNotificationType.blood,
        createdAt: now.subtract(const Duration(minutes: 2)),
      ),
      EmergencyNotificationItem(
        title: 'Emergency Help Request',
        subtitle: 'Patient need ambulance support near kathmandu',
        type: EmergencyNotificationType.ambulance,
        createdAt: now.subtract(const Duration(minutes: 5)),
      ),
      EmergencyNotificationItem(
        title: 'Vaccination Camp',
        subtitle: 'Free vaccination program available this sunday',
        type: EmergencyNotificationType.vaccine,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      EmergencyNotificationItem(
        title: 'Health Camp Alert',
        subtitle: 'Free health checkup camp at local community Center',
        type: EmergencyNotificationType.hospital,
        createdAt: now.subtract(const Duration(hours: 12)),
      ),
      EmergencyNotificationItem(
        title: 'Pregnancy Awareness Program',
        subtitle: 'Women’s health awareness session start from tomorrow',
        type: EmergencyNotificationType.pregnancy,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}

enum EmergencyNotificationType {
  blood,
  ambulance,
  vaccine,
  hospital,
  pregnancy,
}

class EmergencyNotificationItem {
  const EmergencyNotificationItem({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.createdAt,
  });

  factory EmergencyNotificationItem.fromJson(Map<String, dynamic> json) {
    return EmergencyNotificationItem(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      type: EmergencyNotificationType.values.byName(
        json['type'] as String? ?? EmergencyNotificationType.ambulance.name,
      ),
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  final String title;
  final String subtitle;
  final EmergencyNotificationType type;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

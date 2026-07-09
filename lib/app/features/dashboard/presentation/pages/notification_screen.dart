import 'package:flutter/material.dart';
import 'package:swasthasathi/app/core/services/emergency_notification_service.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key, this.user});

  final AuthUser? user;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<EmergencyNotificationItem> _notifications = const [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _NotificationHeader(),
              const SizedBox(height: 18),
              const _NotificationFilterRow(),
              const SizedBox(height: 26),
              ..._notifications.map(
                (notification) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _NotificationCard.fromItem(notification),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadNotifications() async {
    final notifications =
        await EmergencyNotificationService.loadNotifications();

    if (!mounted) return;

    setState(() {
      _notifications = notifications;
    });
  }
}

class _NotificationHeader extends StatelessWidget {
  const _NotificationHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Transform.translate(
            offset: const Offset(-8, 0),
            child: const Padding(
              padding: EdgeInsets.only(top: 8, right: 10),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF193767),
                size: 20,
              ),
            ),
          ),
        ),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notification',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF24229A),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Health alerts and community support',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(Icons.notifications, color: Color(0xFF193767), size: 30),
        ),
      ],
    );
  }
}

class _NotificationFilterRow extends StatelessWidget {
  const _NotificationFilterRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        SizedBox(
          width: 95,
          height: 38,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF1E84EA),
              borderRadius: BorderRadius.all(Radius.circular(23)),
            ),
            child: Center(
              child: Text(
                'All',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Spacer(),
        Text(
          'Mark as read',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFFC3A600),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.cardColor,
    required this.borderColor,
    this.icon,
    this.iconColor,
    this.emoji,
  });

  factory _NotificationCard.fromItem(EmergencyNotificationItem item) {
    switch (item.type) {
      case EmergencyNotificationType.blood:
        return _NotificationCard(
          title: item.title,
          subtitle: item.subtitle,
          timeLabel: _timeLabel(item.createdAt),
          cardColor: const Color(0xFFF9C3C3),
          borderColor: const Color(0xFFFF160D),
          icon: Icons.bloodtype,
          iconColor: const Color(0xFFE11B1B),
        );
      case EmergencyNotificationType.ambulance:
        return _NotificationCard(
          title: item.title,
          subtitle: item.subtitle,
          timeLabel: _timeLabel(item.createdAt),
          cardColor: const Color(0xFFEBD9D9),
          borderColor: const Color(0xFFFF8D8D),
          emoji: '🚑',
        );
      case EmergencyNotificationType.vaccine:
        return _NotificationCard(
          title: item.title,
          subtitle: item.subtitle,
          timeLabel: _timeLabel(item.createdAt),
          cardColor: const Color(0xFFBEDBF3),
          borderColor: const Color(0xFF0E86FF),
          icon: Icons.vaccines_rounded,
          iconColor: const Color(0xFF7FA7D7),
        );
      case EmergencyNotificationType.hospital:
        return _NotificationCard(
          title: item.title,
          subtitle: item.subtitle,
          timeLabel: _timeLabel(item.createdAt),
          cardColor: const Color(0xFFC2ECD9),
          borderColor: const Color(0xFF00A54A),
          icon: Icons.local_hospital_rounded,
          iconColor: const Color(0xFF84959B),
        );
      case EmergencyNotificationType.pregnancy:
        return _NotificationCard(
          title: item.title,
          subtitle: item.subtitle,
          timeLabel: _timeLabel(item.createdAt),
          cardColor: const Color(0xFFE8D9F4),
          borderColor: const Color(0xFFB329C6),
          emoji: '🤰',
        );
    }
  }

  final String title;
  final String subtitle;
  final String timeLabel;
  final Color cardColor;
  final Color borderColor;
  final IconData? icon;
  final Color? iconColor;
  final String? emoji;

  @override
  Widget build(BuildContext context) {
    Widget avatarChild;

    if (emoji != null) {
      avatarChild = Text(emoji!, style: const TextStyle(fontSize: 28));
    } else {
      avatarChild = Icon(icon, color: iconColor, size: 30);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 7, 12, 9),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.6),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Text(
              timeLabel,
              style: const TextStyle(
                fontSize: 9,
                color: Color(0xFF5F5F5F),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 1.2),
                  ),
                  child: Center(child: avatarChild),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2F3134),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 10.4,
                          height: 1.25,
                          color: Color(0xFF393B3E),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _timeLabel(DateTime createdAt) {
    final difference = DateTime.now().difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hour ago';
    }

    if (difference.inDays == 1) {
      return 'Yesterday';
    }

    return '${difference.inDays} days ago';
  }
}

import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key, this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEAF5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _NotificationHeader(),
              SizedBox(height: 18),
              _NotificationFilterRow(),
              SizedBox(height: 26),
              _NotificationCard(
                title: 'Urgent Blood Needed',
                subtitle:
                    'O+ Blood required at Bir Hospital for\nemergency surgery',
                timeLabel: '2 min ago',
                cardColor: Color(0xFFF9C3C3),
                borderColor: Color(0xFFFF160D),
                icon: Icons.bloodtype,
                iconColor: Color(0xFFE11B1B),
              ),
              SizedBox(height: 16),
              _NotificationCard(
                title: 'Emergency Help Request',
                subtitle: 'Patient need ambulance support near\nkathmandu',
                timeLabel: '5 min ago',
                cardColor: Color(0xFFEBD9D9),
                borderColor: Color(0xFFFF8D8D),
                emoji: '🚑',
              ),
              SizedBox(height: 16),
              _NotificationCard(
                title: 'Vaccination Camp',
                subtitle: 'Free vaccination program available this\nsunday',
                timeLabel: '2 hour ago',
                cardColor: Color(0xFFBEDBF3),
                borderColor: Color(0xFF0E86FF),
                icon: Icons.vaccines_rounded,
                iconColor: Color(0xFF7FA7D7),
              ),
              SizedBox(height: 16),
              _NotificationCard(
                title: 'Health Camp Alert',
                subtitle: 'Free health checkup camp at local community\nCenter',
                timeLabel: '12 hour ago',
                cardColor: Color(0xFFC2ECD9),
                borderColor: Color(0xFF00A54A),
                icon: Icons.local_hospital_rounded,
                iconColor: Color(0xFF84959B),
              ),
              SizedBox(height: 16),
              _NotificationCard(
                title: 'Pregnancy Awareness Program',
                subtitle:
                    'Women’s health awareness session start from\ntomorrow',
                timeLabel: 'Yesterday',
                cardColor: Color(0xFFE8D9F4),
                borderColor: Color(0xFFB329C6),
                emoji: '🤰',
              ),
            ],
          ),
        ),
      ),
    );
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
    offset: const Offset(-8, 0), // move left
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
}

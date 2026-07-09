import 'package:flutter/material.dart';
import 'package:swasthasathi/app/core/localization/app_text.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:swasthasathi/app/features/support/presentation/pages/chat_support_screen.dart';
import 'package:swasthasathi/app/features/support/presentation/pages/first_aid_box_screen.dart';
import 'package:swasthasathi/app/features/support/presentation/pages/health_awareness_screen.dart';
import 'package:swasthasathi/app/features/support/presentation/pages/symptom_checker_screen.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key, this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SupportHeader(user: user),

              const SizedBox(height: 0),

              _SupportActionGrid(user: user),

              Transform.translate(
                offset: const Offset(0, -12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tx('Quick Help Topics', 'छिटो सहयोग विषयहरू'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF184D81),
                      ),
                    ),

                    const SizedBox(height: 11),

                    const _SupportTopicCard(
                      icon: Icons.thermostat_rounded,
                      iconColor: Color(0xFF5AA9FF),
                      iconBackground: Color(0xFFE6F1FF),
                      title: 'Fever and Cold',
                      subtitle: 'Causes, symptoms and treatment',
                    ),

                    const SizedBox(height: 13),

                    const _SupportTopicCard(
                      icon: Icons.pregnant_woman_rounded,
                      iconColor: Color(0xFF2FC7B9),
                      iconBackground: Color(0xFFE3FAF7),
                      title: 'Pregnancy Care',
                      subtitle: 'Care, tips and important information',
                    ),

                    const SizedBox(height: 13),

                    const _SupportTopicCard(
                      icon: Icons.healing_rounded,
                      iconColor: Color(0xFFFFB27A),
                      iconBackground: Color(0xFFFFF0E6),
                      title: 'Bleeding and Injuries',
                      subtitle: 'First aid and when to seek help',
                    ),

                    const SizedBox(height: 13),

                    const _SupportTopicCard(
                      icon: Icons.vaccines_rounded,
                      iconColor: Color(0xFFA28BFF),
                      iconBackground: Color(0xFFF0ECFF),
                      title: 'Vaccination Help',
                      subtitle: 'Vaccine information and schedules',
                    ),

                    const SizedBox(height: 13),

                    const _SupportTopicCard(
                      icon: Icons.coronavirus_rounded,
                      iconColor: Color(0xFFFF78A6),
                      iconBackground: Color(0xFFFFEDF4),
                      title: 'Chronic Disease Management',
                      subtitle: 'Diabetes, BP, asthma and more',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        activeTab: DashboardNavTab.support,
        user: user,
      ),
    );
  }
}

class _SupportHeader extends StatelessWidget {
  const _SupportHeader({this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tx('Support', 'सहयोग'),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF184D81),
                ),
              ),
              SizedBox(height: 4),
              Text(
                context.tx(
                  'We are here to help you',
                  'हामी तपाईंलाई सहयोग गर्न यहाँ छौं',
                ),
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => NotificationScreen(user: user),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.notifications,
              color: Color(0xFF193767),
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}

class _SupportActionGrid extends StatelessWidget {
  const _SupportActionGrid({this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SupportActionCard(
                imageAssetPath: 'assets/images/support_chat_card.png',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => ChatSupportScreen(user: user),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: _SupportActionCard(
                imageAssetPath: 'assets/images/support_first_aid_card.png',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => FirstAidBoxScreen(user: user),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 0),
        Transform.translate(
          offset: const Offset(0, -21),
          child: Row(
            children: [
              Expanded(
                child: _SupportActionCard(
                  imageAssetPath:
                      'assets/images/support_symptom_checker_card.png',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => SymptomCheckerScreen(user: user),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: _SupportActionCard(
                  imageAssetPath:
                      'assets/images/support_health_awareness_card.png',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => HealthAwarenessScreen(user: user),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SupportActionCard extends StatelessWidget {
  const _SupportActionCard({required this.imageAssetPath, this.onTap});

  final String imageAssetPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 160,
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Align(
            alignment: Alignment.topCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imageAssetPath,
                width: 182,
                height: 182,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SupportTopicCard extends StatelessWidget {
  const _SupportTopicCard({
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(11),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: iconColor, size: 25),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF6D7380),
                    fontWeight: FontWeight.w500,
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

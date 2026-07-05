import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key, this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEAF5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _SupportHeader(),

              SizedBox(height: 46),

              _SupportActionGrid(),

              SizedBox(height: 62),

              Text(
                'Quick Help Topics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF184D81),
                ),
              ),

              SizedBox(height: 18),

              _SupportTopicCard(
                icon: Icons.thermostat_rounded,
                iconColor: Color(0xFF5AA9FF),
                iconBackground: Color(0xFFE6F1FF),
                title: 'Fever and Cold',
                subtitle: 'Causes, symptoms and treatment',
              ),

              SizedBox(height: 14),

              _SupportTopicCard(
                icon: Icons.pregnant_woman_rounded,
                iconColor: Color(0xFF2FC7B9),
                iconBackground: Color(0xFFE3FAF7),
                title: 'Pregnancy Care',
                subtitle: 'Care, tips and important information',
              ),

              SizedBox(height: 14),

              _SupportTopicCard(
                icon: Icons.healing_rounded,
                iconColor: Color(0xFFFFB27A),
                iconBackground: Color(0xFFFFF0E6),
                title: 'Bleeding and Injuries',
                subtitle: 'First aid and when to seek help',
              ),

              SizedBox(height: 14),

              _SupportTopicCard(
                icon: Icons.vaccines_rounded,
                iconColor: Color(0xFFA28BFF),
                iconBackground: Color(0xFFF0ECFF),
                title: 'Vaccination Help',
                subtitle: 'Vaccine information and schedules',
              ),

              SizedBox(height: 14),

              _SupportTopicCard(
                icon: Icons.coronavirus_rounded,
                iconColor: Color(0xFFFF78A6),
                iconBackground: Color(0xFFFFEDF4),
                title: 'Chronic Disease Management',
                subtitle: 'Diabetes, BP, asthma and more',
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
  const _SupportHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Support',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF184D81),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'We are here to help you',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(Icons.notifications, color: Color(0xFF193767), size: 30),
        ),
      ],
    );
  }
}

class _SupportActionGrid extends StatelessWidget {
  const _SupportActionGrid();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SupportActionCard(
                imageAssetPath: 'assets/images/support_chat_card.png',
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: _SupportActionCard(
                imageAssetPath: 'assets/images/support_first_aid_card.png',
              ),
            ),
          ],
        ),
        SizedBox(height: 0),
        Row(
          children: [
            Expanded(
              child: _SupportActionCard(
                imageAssetPath:
                    'assets/images/support_symptom_checker_card.png',
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: _SupportActionCard(
                imageAssetPath:
                    'assets/images/support_health_awareness_card.png',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SupportActionCard extends StatelessWidget {
  const _SupportActionCard({required this.imageAssetPath});

  final String imageAssetPath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
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

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
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
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
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.notifications,
                      color: Color(0xFF193767),
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const _SupportHero(),
              Transform.translate(
                offset: const Offset(0, -58),
                child: const _SupportActionGrid(),
              ),
              Transform.translate(
                offset: const Offset(0, -26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Quick Help Topics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
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

class _SupportHero extends StatelessWidget {
  const _SupportHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 188,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F4FF), Color(0xFFCFE4FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 22,
            left: 20,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.38),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Positioned(
            left: 30,
            top: 34,
            child: Icon(
              Icons.support_agent_rounded,
              size: 66,
              color: Color(0xFF1765C1),
            ),
          ),
          const Positioned(
            left: 26,
            bottom: 26,
            child: Text(
              'Quick help,\ntrusted guidance',
              style: TextStyle(
                fontSize: 22,
                height: 1.1,
                fontWeight: FontWeight.w800,
                color: Color(0xFF184D81),
              ),
            ),
          ),
        ],
      ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _SupportActionCard(
                title: 'Chat\nSupport',
                icon: Icons.chat_bubble_rounded,
                colors: [Color(0xFF4D9BFF), Color(0xFF256FCA)],
                height: 132,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _SupportActionCard(
                title: 'First Aid\nGuide',
                icon: Icons.medical_services_rounded,
                colors: [Color(0xFF27C7B4), Color(0xFF119C8B)],
                height: 132,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _SupportActionCard(
                title: 'Symptom\nChecker',
                icon: Icons.health_and_safety_rounded,
                colors: [Color(0xFF77B8FF), Color(0xFF3E85E2)],
                height: 132,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _SupportActionCard(
                title: 'Health\nAwareness',
                icon: Icons.ondemand_video_rounded,
                colors: [Color(0xFF5AD8D0), Color(0xFF18A8A0)],
                height: 132,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SupportActionCard extends StatelessWidget {
  const _SupportActionCard({
    required this.title,
    required this.icon,
    required this.colors,
    required this.height,
  });

  final String title;
  final IconData icon;
  final List<Color> colors;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 46, color: Colors.white),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                height: 1.12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 10,
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
              borderRadius: BorderRadius.circular(16),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13.5,
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

import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key, this.user});

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
                          'Emergency Dashboard',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFAE0E0E),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Quick emergency support anytime',
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
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.notifications,
                      color: Color(0xFF193767),
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const _EmergencyHero(),
              const SizedBox(height: 26),
              const _EmergencyActionGrid(),
              const SizedBox(height: 30),
              const Text(
                'Emergency Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 18),
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _EmergencyContactCard(
                      title: 'Family\nContact',
                      avatar: Icons.face_4_outlined,
                    ),
                    SizedBox(width: 14),
                    _EmergencyContactCard(
                      title: 'Nearby\nHospital',
                      avatar: Icons.local_hospital_outlined,
                    ),
                    SizedBox(width: 14),
                    _EmergencyContactCard(
                      title: 'Local Health\nWorker',
                      avatar: Icons.health_and_safety_outlined,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        activeTab: DashboardNavTab.emergency,
        user: user,
      ),
    );
  }
}

class _EmergencyHero extends StatelessWidget {
  const _EmergencyHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Center(
        child: Image.asset(
          'assets/images/emergency_sos_center.png',
          width: 320,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _EmergencyActionGrid extends StatelessWidget {
  const _EmergencyActionGrid();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _EmergencyActionCard(
                title: 'Call\nAmbulance',
                icon: Icons.emergency,
                colors: [Color(0xFFFF0D19), Color(0xFFE60000)],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _EmergencyActionCard(
                title: 'Call\nDoctor',
                icon: Icons.person_search_rounded,
                colors: [Color(0xFF2C95F7), Color(0xFF146ECD)],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _EmergencyActionCard(
                title: 'Blood\nRequest',
                icon: Icons.water_drop,
                colors: [Color(0xFFBC0404), Color(0xFF8E0202)],
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _EmergencyActionCard(
                title: 'Emergency\nSMS',
                icon: Icons.mail_outline,
                colors: [Color(0xFFFF9815), Color(0xFFFF7D00)],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _EmergencyActionCard(
                title: 'Share\nLocation',
                icon: Icons.navigation,
                colors: [Color(0xFF13BB4D), Color(0xFF0DA13F)],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _EmergencyActionCard(
                title: 'Police\nHelp',
                icon: Icons.local_police_outlined,
                colors: [Color(0xFF1F4DB5), Color(0xFF143B93)],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EmergencyActionCard extends StatelessWidget {
  const _EmergencyActionCard({
    required this.title,
    required this.icon,
    required this.colors,
  });

  final String title;
  final IconData icon;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.92,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 16, 12, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 42, color: Colors.white),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                height: 1.15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmergencyContactCard extends StatelessWidget {
  const _EmergencyContactCard({
    required this.title,
    required this.avatar,
  });

  final String title;
  final IconData avatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 182,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x29000000),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              height: 1.15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFDDDDDD)),
                ),
                child: Icon(avatar, size: 30, color: const Color(0xFF2A5B9B)),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFF166EF3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.call, color: Colors.white, size: 28),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    final fullName = user?.fullName.trim().isNotEmpty == true
        ? user!.fullName.trim()
        : 'Anisha Sharma';
    final district = user?.district.trim().isNotEmpty == true
        ? user!.district.trim()
        : 'Kathmandu, Nepal';
    final bloodGroup = user?.bloodGroup?.trim().isNotEmpty == true
        ? user!.bloodGroup!.trim()
        : 'O+ Positive';
    final phoneNumber = user?.phoneNumber.trim().isNotEmpty == true
        ? user!.phoneNumber.trim()
        : '+977 9865432369';

    return Scaffold(
      backgroundColor: const Color(0xFFDCEAF5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 120),
          child: Column(
            children: [
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF24229A),
                ),
              ),
              const SizedBox(height: 25),
              const _ProfileAvatar(),
              const SizedBox(height: 18),
              Text(
                fullName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF2E3338),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'HealthCare Campanion users',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF434A51)),
              ),
              const SizedBox(height: 18),
              _ProfileStatsCard(
                bloodGroup: bloodGroup,
                district: district,
                phoneNumber: phoneNumber,
              ),
              const SizedBox(height: 24),
              const _ProfileMenuCard(
                icon: Icons.person_rounded,
                iconBackground: Color(0xFF1E88F7),
                title: 'Personal Information',
              ),
              const SizedBox(height: 16),
              const _ProfileMenuCard(
                icon: Icons.medical_services_rounded,
                iconBackground: Color(0xFF16BF70),
                title: 'Health Record',
              ),
              const SizedBox(height: 16),
              const _ProfileMenuCard(
                icon: Icons.language_rounded,
                iconBackground: Color(0xFFFF8A00),
                title: 'Language Setting',
              ),
              const SizedBox(height: 16),
              const _ProfileToggleCard(),
              const SizedBox(height: 26),
              const _LogoutButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        activeTab: DashboardNavTab.profile,
        user: user,
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 166,
      height: 166,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF9EC0F2), Color(0xFF87A6D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Icon(
        Icons.person_rounded,
        size: 104,
        color: Color(0xFF4B2C22),
      ),
    );
  }
}

class _ProfileStatsCard extends StatelessWidget {
  const _ProfileStatsCard({
    required this.bloodGroup,
    required this.district,
    required this.phoneNumber,
  });

  final String bloodGroup;
  final String district;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFB3DCF0), Color(0xFFD7DFE4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ProfileInfoItem(
                  icon: Icons.bloodtype,
                  iconBackground: Color(0xFFE8B2B2),
                  iconColor: Color(0xFFE11B1B),
                  title: 'Blood Group',
                  subtitle: bloodGroup,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: _ProfileInfoItem(
                  icon: Icons.check_box_rounded,
                  iconBackground: Color(0xFFAEE28E),
                  iconColor: Color(0xFF10B91D),
                  title: 'Health Status',
                  subtitle: 'Excellent',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _ProfileInfoItem(
                  icon: Icons.location_on_rounded,
                  iconBackground: Color(0xFFC9B8E9),
                  iconColor: Color(0xFF1F3F6B),
                  title: 'Location',
                  subtitle: district,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ProfileInfoItem(
                  icon: Icons.call_rounded,
                  iconBackground: const Color(0xFFC9DDB7),
                  iconColor: const Color(0xFF4C5650),
                  title: 'Emergency Contact',
                  subtitle: phoneNumber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoItem extends StatelessWidget {
  const _ProfileInfoItem({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 30),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A5056),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileMenuCard extends StatelessWidget {
  const _ProfileMenuCard({
    required this.icon,
    required this.iconBackground,
    required this.title,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF7C7F86),
            size: 34,
          ),
        ],
      ),
    );
  }
}

class _ProfileToggleCard extends StatelessWidget {
  const _ProfileToggleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('🌙', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: 76,
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF6D4FB3),
              borderRadius: BorderRadius.circular(21),
            ),
            alignment: Alignment.centerRight,
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF2287EE),
        borderRadius: BorderRadius.circular(36),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Logout',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

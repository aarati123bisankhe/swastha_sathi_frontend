import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/emergency_screen.dart';

enum DashboardNavTab { home, emergency, support, record, profile }

class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({
    super.key,
    required this.activeTab,
    this.user,
  });

  final DashboardNavTab activeTab;
  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 79,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      child: Transform.translate(
        offset: const Offset(0, -7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomNavItem(
              icon: Icons.home,
              label: 'Home',
              active: activeTab == DashboardNavTab.home,
              onTap: () => _openTab(context, DashboardNavTab.home),
            ),
            _BottomNavItem(
              icon: Icons.call,
              label: 'Emergency',
              active: activeTab == DashboardNavTab.emergency,
              onTap: () => _openTab(context, DashboardNavTab.emergency),
            ),
            _BottomNavItem(
              icon: Icons.headset_mic,
              label: 'Support',
              active: activeTab == DashboardNavTab.support,
              onTap: () => _openTab(context, DashboardNavTab.support),
            ),
            _BottomNavItem(
              icon: Icons.assignment_outlined,
              label: 'Record',
              active: activeTab == DashboardNavTab.record,
              onTap: () => _openTab(context, DashboardNavTab.record),
            ),
            _BottomNavItem(
              icon: Icons.person,
              label: 'Profile',
              active: activeTab == DashboardNavTab.profile,
              onTap: () => _openTab(context, DashboardNavTab.profile),
            ),
          ],
        ),
      ),
    );
  }

  void _openTab(BuildContext context, DashboardNavTab tab) {
    if (tab == activeTab) return;

    if (tab == DashboardNavTab.home) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => DashboardScreen(user: user),
        ),
      );
      return;
    }

    if (tab == DashboardNavTab.emergency) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (context) => EmergencyScreen(user: user),
        ),
      );
    }
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF0B73E8) : const Color(0xFF183B66);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: color,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: active ? color : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

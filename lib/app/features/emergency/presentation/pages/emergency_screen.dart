import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/blood_request_screen.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/call_ambulance_screen.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/emergency_message_screen.dart';

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
              ),

              const SizedBox(height: 26),

              const _EmergencyHero(),

              const SizedBox(height: 6),

              Transform.translate(
                offset: const Offset(0, -65),
                child: _EmergencyActionGrid(user: user),
              ),

              Transform.translate(
                offset: const Offset(0, -40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Contacts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 18),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _EmergencyContactCard(
                            title: 'Family\nContact',
                            avatar: ClipOval(
                              child: Image.asset(
                                'assets/images/family_contact_avatar.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          _EmergencyContactCard(
                            title: 'Nearby\nHospital',
                            avatar: Image.asset(
                              'assets/images/hospital_contact_icon.png',
                              width: 27,
                              height: 27,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(width: 12),
                          _EmergencyContactCard(
                            title: 'Local Health\nWorker',
                            avatar: Text(
                              '🧑‍⚕️',
                              style: TextStyle(fontSize: 18),
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
      child: Transform.translate(
        offset: const Offset(0, -49),
        child: Center(
          child: Image.asset(
            'assets/images/emergency_sos_center.png',
            width: 390,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _EmergencyActionGrid extends StatelessWidget {
  const _EmergencyActionGrid({this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _EmergencyActionCard(
                title: 'Call\nAmbulance',
                icon: Icons.emergency,
                colors: const [Color(0xFFFF0505), Color(0xFFE60000)],
                imageAsset: 'assets/images/ambulance_icon.png',
                height: 130,
                fontSize: 21,
                iconSize: 54,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => CallAmbulanceScreen(user: user),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              flex: 3,
              child: const _EmergencyActionCard(
                title: 'Call\nDoctor',
                icon: Icons.person_search_rounded,
                colors: [Color(0xFF159AF2), Color(0xFF0878D8)],
                height: 126,
                fontSize: 18,
                iconSize: 44,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              flex: 3,
              child: _EmergencyActionCard(
                title: 'Blood\nRequest',
                icon: Icons.water_drop,
                colors: const [Color(0xFFC40000), Color(0xFF990000)],
                height: 126,
                fontSize: 18,
                iconSize: 46,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => BloodRequestScreen(user: user),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: _EmergencyActionCard(
                title: 'Emergency\nSMS',
                icon: Icons.mail_outline,
                colors: const [Color(0xFFFF8A00), Color(0xFFFF7600)],
                height: 132,
                fontSize: 18,
                iconSize: 49,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => EmergencyMessageScreen(user: user),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              flex: 3,
              child: const _EmergencyActionCard(
                title: 'Share\nLocation',
                icon: Icons.navigation,
                colors: [Color(0xFF10B84D), Color(0xFF069B3E)],
                height: 132,
                fontSize: 18,
                iconSize: 46,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              flex: 3,
              child: const _EmergencyActionCard(
                title: 'Police\nHelp',
                icon: Icons.local_police_outlined,
                colors: [Color(0xFF104DB2), Color(0xFF073681)],
                height: 132,
                fontSize: 18,
                iconSize: 46,
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
    required this.height,
    required this.fontSize,
    required this.iconSize,
    this.imageAsset,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final List<Color> colors;
  final double height;
  final double fontSize;
  final double iconSize;
  final String? imageAsset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: height,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
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
              if (imageAsset != null)
                Image.asset(
                  imageAsset!,
                  width: iconSize,
                  height: iconSize - 8,
                  fit: BoxFit.contain,
                )
              else
                Icon(icon, size: iconSize, color: Colors.white),

              const Spacer(),

              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  maxLines: 2,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: fontSize,
                    height: 1.12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmergencyContactCard extends StatelessWidget {
  const _EmergencyContactCard({required this.title, required this.avatar});

  final String title;
  final Widget avatar;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115,
      padding: const EdgeInsets.fromLTRB(8.8, 8.8, 8.8, 8.2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(
            color: Color(0x29000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 9.8,
              height: 1.15,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 7),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFDDDDDD)),
                ),
                child: Center(child: avatar),
              ),

              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF166EF3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.call, color: Colors.white, size: 15.5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class PoliceHelpScreen extends StatelessWidget {
  const PoliceHelpScreen({super.key, this.user});

  final AuthUser? user;

  static const List<_PoliceStation> _stations = [
    _PoliceStation(
      name: 'Kathamandu Police Station',
      officer: 'Officer: Kathmandu',
      location: 'Kathmandu',
      status: 'Available Now',
      phone: '100',
      avatarBackground: Color(0xFFE6F2FF),
      avatarAccent: Color(0xFF2D75D7),
      initials: 'KP',
    ),
    _PoliceStation(
      name: 'Lalitpur Police Station',
      officer: 'Officer: Lalitpur',
      location: 'Lalitpur',
      status: 'Available Now',
      phone: '01-5521200',
      avatarBackground: Color(0xFFEAF7FF),
      avatarAccent: Color(0xFF0D74CC),
      initials: 'LP',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEAF5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 18, 14, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PoliceHeader(user: user),
              const SizedBox(height: 14),
              const _PoliceBanner(),
              const SizedBox(height: 14),
              ..._stations.map(
                (station) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _PoliceStationCard(
                    station: station,
                    onCall: () => _showCall(context, station),
                  ),
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

  void _showCall(BuildContext context, _PoliceStation station) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Calling ${station.name} at ${station.phone}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

class _PoliceHeader extends StatelessWidget {
  const _PoliceHeader({this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Transform.translate(
            offset: const Offset(-4, 0),
            child: const Padding(
              padding: EdgeInsets.only(top: 9, right: 10),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF7C828C),
                size: 19,
              ),
            ),
          ),
        ),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Police Help',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF251E7E),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Quick police assistance during emergencies',
                style: TextStyle(fontSize: 13, color: Color(0xFF555D69)),
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
            padding: EdgeInsets.only(top: 2),
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

class _PoliceBanner extends StatelessWidget {
  const _PoliceBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/police_help_banner.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PoliceStationCard extends StatelessWidget {
  const _PoliceStationCard({required this.station, required this.onCall});

  final _PoliceStation station;
  final VoidCallback onCall;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PoliceAvatar(station: station),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            station.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F8EB),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0DBB53),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                station.status,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0AA54C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      station.officer,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666C76),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Color(0xFF1C355E),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          station.location,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF5D6470),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 94,
              child: FilledButton.icon(
                onPressed: onCall,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1467D4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.call_rounded, size: 18),
                label: const Text(
                  'Call',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PoliceAvatar extends StatelessWidget {
  const _PoliceAvatar({required this.station});

  final _PoliceStation station;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: station.avatarBackground,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 14,
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: Color(0xFFFFD7BF),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 10,
            child: Container(
              width: 40,
              height: 16,
              decoration: BoxDecoration(
                color: station.avatarAccent,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
            top: 42,
            child: Container(
              width: 52,
              height: 24,
              decoration: BoxDecoration(
                color: station.avatarAccent,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            child: Text(
              station.initials,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: station.avatarAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PoliceStation {
  const _PoliceStation({
    required this.name,
    required this.officer,
    required this.location,
    required this.status,
    required this.phone,
    required this.avatarBackground,
    required this.avatarAccent,
    required this.initials,
  });

  final String name;
  final String officer;
  final String location;
  final String status;
  final String phone;
  final Color avatarBackground;
  final Color avatarAccent;
  final String initials;
}

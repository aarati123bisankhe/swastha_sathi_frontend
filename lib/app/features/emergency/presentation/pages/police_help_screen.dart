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
      imageAssetPath: 'assets/images/police_kathmandu.png',
    ),
    _PoliceStation(
      name: 'Lalitpur Police Station',
      officer: 'Officer: Lalitpur',
      location: 'Lalitpur',
      status: 'Available Now',
      phone: '01-5521200',
      imageAssetPath: 'assets/images/police_lalitpur.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
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
              const SizedBox(width: 8),
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
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
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
                              const SizedBox(width: 4),
                              Text(
                                station.status,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0AA54C),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      station.officer,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666C76),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Color(0xFF1C355E),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          station.location,
                          style: const TextStyle(
                            fontSize: 12,
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
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 84,
              child: FilledButton.icon(
                onPressed: onCall,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1467D4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.call_rounded, size: 16),
                label: const Text(
                  'Call',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
    return ClipOval(
      child: SizedBox(
        width: 58,
        height: 58,
        child: Image.asset(
          station.imageAssetPath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _PoliceAvatarFallback(station: station);
          },
        ),
      ),
    );
  }
}

class _PoliceAvatarFallback extends StatelessWidget {
  const _PoliceAvatarFallback({required this.station});

  final _PoliceStation station;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEAF2FF),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_police_rounded,
            color: Color(0xFF1B5FCB),
            size: 24,
          ),
          const SizedBox(height: 2),
          Text(
            station.location,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C355E),
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
    required this.imageAssetPath,
  });

  final String name;
  final String officer;
  final String location;
  final String status;
  final String phone;
  final String imageAssetPath;
}

import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class CallAmbulanceScreen extends StatelessWidget {
  const CallAmbulanceScreen({super.key, this.user});

  final AuthUser? user;

  static const List<_AmbulanceService> _services = [
    _AmbulanceService(
      name: 'Kathmandu Emergency Ambulance',
      phone: '01-6754368',
      location: 'Kathmandu, Bagmati Province',
      distance: '2.2 km away',
      accentColor: Color(0xFFE65100),
      imageUrl: 'assets/images/ambulance_avatar_1.png',
    ),
    _AmbulanceService(
      name: 'Lalitpur Health Service',
      phone: '01-8765436',
      location: 'Lalitpur, Bagmati Province',
      distance: '4.1 km away',
      accentColor: Color(0xFF1565C0),
      imageUrl: 'assets/images/ambulance_avatar_2.png',
    ),
    _AmbulanceService(
      name: 'Bhaktapur Rapid Ambulance',
      phone: '01-9876543',
      location: 'Bhaktapur, Bagmati Province',
      distance: '3.3 km away',
      accentColor: Color(0xFF2E7D32),
      imageUrl: 'assets/images/ambulance_avatar_3.png',
    ),
    _AmbulanceService(
      name: 'Rural Rescue Response',
      phone: '01-3456789',
      location: 'Kavrepalanchok, Bagmati Province',
      distance: '5.8 km away',
      accentColor: Color(0xFFAD1457),
      imageUrl: 'assets/images/ambulance_avatar_4.png',
    ),
  ];

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
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Transform.translate(
                      offset: const Offset(-8, 0),
                      child: const Padding(
                        padding: EdgeInsets.only(top: 8, right: 10),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Color(0xFF193767),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Call Ambulance',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF112A87),
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Quick emergency support anytime',
                          style: TextStyle(
                            fontSize: 15,
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
              const _AmbulanceHeroCard(),
              const SizedBox(height: 15),
              ..._services.map(
                (service) => Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: _AmbulanceServiceCard(service: service),
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(
                    child: _ActionFooterButton(
                      label: 'Share Location',
                      textColor: Color(0xFF135099),
                      borderColor: Color(0xFF5AA7FF),
                      backgroundColor: Colors.transparent,
                      icon: Icons.my_location_outlined,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: _ActionFooterButton(
                      label: 'Emergency SoS',
                      textColor: Colors.white,
                      borderColor: Color(0xFFF71818),
                      backgroundColor: Color(0xFFF71818),
                      icon: Icons.warning_rounded,
                    ),
                  ),
                ],
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

class _AmbulanceHeroCard extends StatelessWidget {
  const _AmbulanceHeroCard();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Transform.translate(
        offset: const Offset(0, -2), // Move the image up by 0.5 pixels
        child: Image.asset(
          'assets/images/call_ambulance_banner.png',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _AmbulanceServiceCard extends StatelessWidget {
  const _AmbulanceServiceCard({required this.service});

  final _AmbulanceService service;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ServiceAvatar(service: service),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                _InfoRow(
                  icon: Icons.phone,
                  child: Text(
                    service.phone,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  child: Text(
                    service.location,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                _DistancePill(label: service.distance),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Column(
            children: [
              _AvailabilityBadge(),
              SizedBox(height: 6),
              _CallNowButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceAvatar extends StatelessWidget {
  const _ServiceAvatar({required this.service});

  final _AmbulanceService service;

  bool get _isAssetImage => service.imageUrl.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF1F3F8),
          ),
          clipBehavior: Clip.antiAlias,
          child: _isAssetImage
              ? Image.asset(
                  service.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _AvatarFallback(service: service),
                )
              : Image.network(
                  service.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _AvatarFallback(service: service),
                ),
        ),
        const Positioned(
          right: 2,
          bottom: 2,
          child: CircleAvatar(
            radius: 6,
            backgroundColor: Colors.white,
            child: CircleAvatar(radius: 4, backgroundColor: Color(0xFF1BC442)),
          ),
        ),
      ],
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.service});

  final _AmbulanceService service;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            service.accentColor,
            service.accentColor.withValues(alpha: 0.65),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.person, color: Colors.white, size: 24),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 7, color: Color(0xFF11B441)),
        SizedBox(width: 3),
        Text(
          'Available Now',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0B9C33),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.child});

  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 12, color: const Color(0xFF2D2D2D)),
        const SizedBox(width: 3),
        Expanded(child: child),
      ],
    );
  }
}

class _DistancePill extends StatelessWidget {
  const _DistancePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F1FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, size: 10, color: Color(0xFF1B2A6B)),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1B2A6B),
            ),
          ),
        ],
      ),
    );
  }
}

class _CallNowButton extends StatelessWidget {
  const _CallNowButton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: Color(0xFF12C64B),
          child: Icon(Icons.call, color: Colors.white, size: 15),
        ),
        SizedBox(height: 2),
        Text(
          'Call Now',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xFF129E3D),
          ),
        ),
      ],
    );
  }
}

class _ActionFooterButton extends StatelessWidget {
  const _ActionFooterButton({
    required this.label,
    required this.textColor,
    required this.borderColor,
    required this.backgroundColor,
    required this.icon,
  });

  final String label;
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: label == 'Share Location'
          ? OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(icon, color: textColor, size: 18),
              label: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            )
          : ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(icon, color: textColor, size: 18),
              label: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
    );
  }
}

class _AmbulanceService {
  const _AmbulanceService({
    required this.name,
    required this.phone,
    required this.location,
    required this.distance,
    required this.accentColor,
    required this.imageUrl,
  });

  final String name;
  final String phone;
  final String location;
  final String distance;
  final Color accentColor;
  final String imageUrl;
}

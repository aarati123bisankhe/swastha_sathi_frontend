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
      avatarLabel: 'KA',
    ),
    _AmbulanceService(
      name: 'Lalitpur Health Service',
      phone: '01-8765436',
      location: 'Lalitpur, Bagmati Province',
      distance: '4.1 km away',
      accentColor: Color(0xFF1565C0),
      avatarLabel: 'LH',
    ),
    _AmbulanceService(
      name: 'Bhaktapur Rapid Ambulance',
      phone: '01-9876543',
      location: 'Bhaktapur, Bagmati Province',
      distance: '3.3 km away',
      accentColor: Color(0xFF2E7D32),
      avatarLabel: 'BR',
    ),
    _AmbulanceService(
      name: 'Rural Rescue Response',
      phone: '01-3456789',
      location: 'Kavrepalanchok, Bagmati Province',
      distance: '5.8 km away',
      accentColor: Color(0xFFAD1457),
      avatarLabel: 'RR',
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Call Ambulance',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF112A87),
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
              const _AmbulanceHeroCard(),
              const SizedBox(height: 20),
              ..._services.map(
                (service) => Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: _AmbulanceServiceCard(service: service),
                ),
              ),
              const SizedBox(height: 24),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF3A58), Color(0xFFFF6C7A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x25000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        children: [
          _HeroShield(),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fast Emergency Response',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'For rural and urban communities.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Icon(Icons.local_shipping_rounded, color: Colors.white, size: 78),
        ],
      ),
    );
  }
}

class _HeroShield extends StatelessWidget {
  const _HeroShield();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.health_and_safety_rounded,
        color: Colors.white,
        size: 38,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBFB),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ServiceAvatar(service: service),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const _AvailabilityBadge(),
                  ],
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.call_outlined,
                  child: Text(
                    service.phone,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  child: Text(
                    service.location,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5A5A5A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _DistancePill(label: service.distance),
                    const Spacer(),
                    const _CallNowButton(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceAvatar extends StatelessWidget {
  const _ServiceAvatar({required this.service});

  final _AmbulanceService service;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 76,
          height: 76,
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
          child: Text(
            service.avatarLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Positioned(
          right: -1,
          bottom: -1,
          child: CircleAvatar(
            radius: 7,
            backgroundColor: Colors.white,
            child: CircleAvatar(radius: 5, backgroundColor: Color(0xFF1BC442)),
          ),
        ),
      ],
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F8EC),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 10, color: Color(0xFF11B441)),
          SizedBox(width: 6),
          Text(
            'Available Now',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0B9C33),
            ),
          ),
        ],
      ),
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
        Icon(icon, size: 18, color: const Color(0xFF2D2D2D)),
        const SizedBox(width: 7),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDCEEFF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule_outlined,
            size: 15,
            color: Color(0xFF35577D),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF35577D),
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
          radius: 31,
          backgroundColor: Color(0xFF12C64B),
          child: Icon(Icons.call, color: Colors.white, size: 28),
        ),
        SizedBox(height: 8),
        Text(
          'Call Now',
          style: TextStyle(
            fontSize: 14,
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
    return Container(
      height: 78,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: borderColor, width: 1.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 24),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
        ],
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
    required this.avatarLabel,
  });

  final String name;
  final String phone;
  final String location;
  final String distance;
  final Color accentColor;
  final String avatarLabel;
}

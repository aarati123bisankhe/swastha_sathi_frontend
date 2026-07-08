import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class HospitalScreen extends StatelessWidget {
  const HospitalScreen({super.key, this.user});

  final AuthUser? user;

  static const List<_HospitalInfo> _hospitals = [
    _HospitalInfo(
      name: 'B&P Hospital',
      location: 'Tinkune, Kathmandu',
      distance: '1.2 km away',
      rating: '4.6',
      reviews: '256 reviews',
      phone: '01-4112200',
      mapLabel: 'Tinkune, Kathmandu',
      tags: ['Emergency', 'ICU', 'Cardiology', 'Pharmacy'],
      badge: '24x7',
      accent: Color(0xFF1EB980),
      imageAssetPath: 'assets/images/hospital_bp.png',
    ),
    _HospitalInfo(
      name: 'Grande International Hospital',
      location: 'Dhapasi, Kathmandu',
      distance: '2.8 km away',
      rating: '4.6',
      reviews: '256 reviews',
      phone: '01-5159266',
      mapLabel: 'Dhapasi, Kathmandu',
      tags: ['Emergency', 'Surgery', 'ICU', 'Maternity'],
      badge: '24x7',
      accent: Color(0xFF1EB980),
      imageAssetPath: 'assets/images/hospital_grande.png',
    ),
    _HospitalInfo(
      name: 'Civil Service Hospital',
      location: 'Minbhawan, Kathmandu',
      distance: '3.5 km away',
      rating: '4.6',
      reviews: '256 reviews',
      phone: '01-4107000',
      mapLabel: 'Minbhawan, Kathmandu',
      tags: ['General', 'Pediatrics', 'Lab', 'Pharmacy'],
      badge: 'Emergency',
      accent: Color(0xFFFF3B5C),
      imageAssetPath: 'assets/images/hospital_civil.png',
    ),
  ];

  static const List<_QuickAccessItem> _quickAccessItems = [
    _QuickAccessItem(
      label: 'Emergency\nServices',
      icon: Icons.emergency_rounded,
      iconColor: Color(0xFFFF3131),
      iconBackground: Color(0xFFFFEBEB),
    ),
    _QuickAccessItem(
      label: 'Find ICU\nBeds',
      icon: Icons.bed_rounded,
      iconColor: Color(0xFF4F92F0),
      iconBackground: Color(0xFFEAF3FF),
    ),
    _QuickAccessItem(
      label: 'Book\nAppointment',
      icon: Icons.calendar_month_rounded,
      iconColor: Color(0xFF3CC56B),
      iconBackground: Color(0xFFE9FAEF),
    ),
    _QuickAccessItem(
      label: 'Laboratory\nTest',
      icon: Icons.science_rounded,
      iconColor: Color(0xFFB56BE7),
      iconBackground: Color(0xFFF4EAFF),
    ),
    _QuickAccessItem(
      label: 'Pharmacy\nNearby',
      icon: Icons.medication_rounded,
      iconColor: Color(0xFFFFA424),
      iconBackground: Color(0xFFFFF2DF),
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
              _Header(user: user),
              const SizedBox(height: 3),
              const _BannerCard(),
              const SizedBox(height: 0),
              _LocationCard(
                onChangeLocation: () => _showInfo(
                  context,
                  'Change location is ready for hookup to your location selector.',
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Nearby Hospital',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF23248E),
                ),
              ),
              const SizedBox(height: 10),
              ..._hospitals.map(
                (hospital) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _HospitalCard(
                    hospital: hospital,
                    onCall: () => _showInfo(
                      context,
                      'Calling ${hospital.name} at ${hospital.phone}',
                    ),
                    onDirections: () => _showInfo(
                      context,
                      'Opening directions to ${hospital.mapLabel}',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Quick Access',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF23248E),
                ),
              ),
              const SizedBox(height: 13),
              _QuickAccessGrid(
                items: _quickAccessItems,
                onTap: (item) {
                  _showInfo(
                    context,
                    '${item.label.replaceAll('\n', ' ')} selected',
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        activeTab: DashboardNavTab.home,
        user: user,
      ),
    );
  }

  void _showInfo(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Transform.translate(
            offset: const Offset(-10, 0),
            child: const Padding(
              padding: EdgeInsets.only(top: 8, right: 4),
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
                'Hospital',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF251E7E),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Find nearby hospitals and healthcare center',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF555D69),
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
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        'assets/images/hospital_banner.png',
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.onChangeLocation});

  final VoidCallback onChangeLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF4FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Color(0xFF197BE8),
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Near You',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF21315E),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 1),
                Text(
                  'Kathmandu, Bagmati Province',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF5D6777),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onChangeLocation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FBFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFB6D4FF)),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.gps_fixed_rounded,
                    color: Color(0xFF197BE8),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Change Location',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF234F8C),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HospitalCard extends StatelessWidget {
  const _HospitalCard({
    required this.hospital,
    required this.onCall,
    required this.onDirections,
  });

  final _HospitalInfo hospital;
  final VoidCallback onCall;
  final VoidCallback onDirections;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HospitalThumbnail(hospital: hospital),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              hospital.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF1E2E58),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified_rounded,
                            color: Color(0xFF2196F3),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                ),
                const SizedBox(height: 4),
                _MetaLine(
                  icon: Icons.location_on_outlined,
                  text: hospital.location,
                ),
                const SizedBox(height: 1),
                _MetaLine(icon: Icons.place_outlined, text: hospital.distance),
                const SizedBox(height: 5),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: hospital.tags
                      .map((tag) => _TagChip(label: tag))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6FAED),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFF36BE63),
                      size: 14,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      hospital.rating,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF2BA957),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '(${hospital.reviews})',
                style: const TextStyle(
                  fontSize: 7,
                  color: Color(0xFF7B8393),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              _ActionButton(
                label: 'Call',
                icon: Icons.call_rounded,
                filled: true,
                onTap: onCall,
              ),
              const SizedBox(height: 5),
              _ActionButton(
                label: 'Directions',
                icon: Icons.near_me_outlined,
                filled: false,
                onTap: onDirections,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HospitalThumbnail extends StatelessWidget {
  const _HospitalThumbnail({required this.hospital});

  final _HospitalInfo hospital;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 74,
      height: 74,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(hospital.imageAssetPath, fit: BoxFit.cover),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: hospital.accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                hospital.badge,
                style: const TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: const Color(0xFF7D8693)),
        const SizedBox(width: 3),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10.5,
              color: Color(0xFF596273),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 8,
          color: Color(0xFF475772),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 26,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF116EEB) : Colors.white,
          borderRadius: BorderRadius.circular(9),
          border: filled ? null : Border.all(color: const Color(0xFFAACDFB)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 12,
              color: filled ? Colors.white : const Color(0xFF116EEB),
            ),
            const SizedBox(width: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: filled ? Colors.white : const Color(0xFF116EEB),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid({required this.items, required this.onTap});

  final List<_QuickAccessItem> items;
  final ValueChanged<_QuickAccessItem> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final tileWidth = (constraints.maxWidth - (spacing * 4)) / 5;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items.map((item) {
            return SizedBox(
              width: tileWidth,
              child: GestureDetector(
                onTap: () => onTap(item),
                child: Container(
                  height: 76,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.96),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFD5DDE8)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: item.iconBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item.icon, size: 18, color: item.iconColor),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 9,
                          height: 1.0,
                          color: Color(0xFF26364C),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _HospitalInfo {
  const _HospitalInfo({
    required this.name,
    required this.location,
    required this.distance,
    required this.rating,
    required this.reviews,
    required this.phone,
    required this.mapLabel,
    required this.tags,
    required this.badge,
    required this.accent,
    required this.imageAssetPath,
  });

  final String name;
  final String location;
  final String distance;
  final String rating;
  final String reviews;
  final String phone;
  final String mapLabel;
  final List<String> tags;
  final String badge;
  final Color accent;
  final String imageAssetPath;
}

class _QuickAccessItem {
  const _QuickAccessItem({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
}

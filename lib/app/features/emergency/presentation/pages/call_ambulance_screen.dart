import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swasthasathi/app/core/localization/app_text.dart';
import 'package:swasthasathi/app/core/services/emergency_location_service.dart';
import 'package:swasthasathi/app/core/services/emergency_notification_service.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:url_launcher/url_launcher.dart';

class CallAmbulanceScreen extends StatefulWidget {
  const CallAmbulanceScreen({super.key, this.user});

  final AuthUser? user;

  @override
  State<CallAmbulanceScreen> createState() => _CallAmbulanceScreenState();
}

class _CallAmbulanceScreenState extends State<CallAmbulanceScreen> {
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tx(
                            'Call Ambulance',
                            'एम्बुलेन्स बोलाउनुहोस्',
                          ),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF112A87),
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          context.tx(
                            'Quick emergency support anytime',
                            'जुनसुकै बेला छिटो आपतकालीन सहयोग',
                          ),
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
                          builder: (context) =>
                              NotificationScreen(user: widget.user),
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
                  child: _AmbulanceServiceCard(
                    service: service,
                    onCall: () => _handleCallNow(service),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _ActionFooterButton(
                      label: context.tx(
                        'Share Location',
                        'स्थान साझा गर्नुहोस्',
                      ),
                      textColor: const Color(0xFF135099),
                      borderColor: const Color(0xFF5AA7FF),
                      backgroundColor: Colors.transparent,
                      icon: Icons.my_location_outlined,
                      onPressed: _handleShareLocation,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _ActionFooterButton(
                      label: context.tx('Emergency SoS', 'आपतकालीन SOS'),
                      textColor: Colors.white,
                      borderColor: const Color(0xFFF71818),
                      backgroundColor: const Color(0xFFF71818),
                      icon: Icons.warning_rounded,
                      onPressed: _handleEmergencySos,
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
        user: widget.user,
      ),
    );
  }

  Future<void> _handleCallNow(_AmbulanceService service) async {
    final shouldCall = await _showConfirmationDialog(
      title: context.tx('Call Ambulance?', 'एम्बुलेन्स बोलाउने?'),
      message: context.tx(
        'Are you sure you want to call this ambulance service now?',
        'के तपाईं अहिले यो एम्बुलेन्स सेवामा कल गर्न चाहनुहुन्छ?',
      ),
      confirmLabel: context.tx('Call Now', 'अहिले कल गर्नुहोस्'),
    );

    if (shouldCall != true) return;

    final launched = await launchUrl(
      Uri(scheme: 'tel', path: service.phone),
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      _showFeedback('Unable to open the phone dialer right now.');
    }
  }

  Future<void> _handleShareLocation() async {
    final permissionMessage = context.tx(
      'Please allow location permission to share your location.',
      'कृपया आफ्नो स्थान साझा गर्न स्थान अनुमति दिनुहोस्।',
    );
    final location = await EmergencyLocationService.getCurrentLocation();

    if (location == null) {
      _showFeedback(permissionMessage);
      return;
    }

    final message =
        'Emergency! I need ambulance help. This is my current location: ${location.googleMapsLink}';

    await Share.share(message, subject: 'Emergency Location');
  }

  Future<void> _handleEmergencySos() async {
    final noContactMessage = context.tx(
      'No emergency contact found. Please add an emergency contact first.',
      'कुनै आपतकालीन सम्पर्क फेला परेन। कृपया पहिले आपतकालीन सम्पर्क थप्नुहोस्।',
    );
    final permissionMessage = context.tx(
      'Please allow location permission to share your location.',
      'कृपया आफ्नो स्थान साझा गर्न स्थान अनुमति दिनुहोस्।',
    );
    final shouldSend = await _showConfirmationDialog(
      title: context.tx('Send Emergency SOS?', 'आपतकालीन SOS पठाउने?'),
      message: context.tx(
        'This will alert your emergency contacts with your current location.',
        'यसले तपाईंका आपतकालीन सम्पर्कहरूलाई तपाईंको हालको स्थानसहित जानकारी पठाउनेछ।',
      ),
      confirmLabel: context.tx('Send SOS', 'SOS पठाउनुहोस्'),
    );

    if (shouldSend != true) return;

    final contacts = await _loadSavedEmergencyContacts();

    if (contacts.isEmpty) {
      _showFeedback(noContactMessage);
      return;
    }

    final location = await EmergencyLocationService.getCurrentLocation();

    if (location == null) {
      _showFeedback(permissionMessage);
      return;
    }

    final message =
        'Emergency SOS! I need urgent help. Please contact me immediately. My current location is: ${location.googleMapsLink}';

    final smsUri = Uri(
      scheme: 'sms',
      path: contacts.join(','),
      queryParameters: {'body': message},
    );

    final launched = await launchUrl(
      smsUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      if (!mounted) return;
      _showFeedback('Unable to open the messaging app right now.');
      return;
    }

    await EmergencyNotificationService.addSosSentNotification();

    if (!mounted) return;
    _showFeedback(
      context.tx(
        'Emergency SOS sent successfully.',
        'आपतकालीन SOS सफलतापूर्वक पठाइयो।',
      ),
    );
  }

  Future<bool?> _showConfirmationDialog({
    required String title,
    required String message,
    required String confirmLabel,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B2330),
            ),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Color(0xFF4E5968),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.tx('Cancel', 'रद्द गर्नुहोस्')),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );
  }

  Future<List<String>> _loadSavedEmergencyContacts() async {
    const storageKey = 'health_record_data';

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);

    if (raw == null || raw.isEmpty) {
      return <String>[];
    }

    final json = jsonDecode(raw) as Map<String, dynamic>;
    final value = (json['emergencyContactNumber'] as String?)?.trim() ?? '';

    if (value.isEmpty) {
      return <String>[];
    }

    return value
        .split(RegExp(r'[,;\n]+'))
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }
}

class _AmbulanceHeroCard extends StatelessWidget {
  const _AmbulanceHeroCard();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Transform.translate(
        offset: const Offset(0, -2),
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
  const _AmbulanceServiceCard({required this.service, required this.onCall});

  final _AmbulanceService service;
  final VoidCallback onCall;

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
          Column(
            children: [
              const _AvailabilityBadge(),
              const SizedBox(height: 6),
              _CallNowButton(onTap: onCall),
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
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFF1F3F8),
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
  const _CallNowButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: const Column(
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
      ),
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
    required this.onPressed,
  });

  final String label;
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: label == 'Share Location'
          ? OutlinedButton.icon(
              onPressed: onPressed,
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
              onPressed: onPressed,
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

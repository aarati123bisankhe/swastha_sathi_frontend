import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:swasthasathi/app/core/localization/app_text.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/blood_request_screen.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/call_ambulance_screen.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/emergency_message_screen.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/police_help_screen.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/share_location_screen.dart';
import 'package:swasthasathi/app/features/support/presentation/pages/doctor_screen.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key, this.user});

  final AuthUser? user;

  static const List<_EmergencyQuickContact> _quickContacts = [
    _EmergencyQuickContact(
      key: 'family',
      title: 'Family\nContact',
      dialogTitle: 'Call Family Contact?',
      dialogMessage: 'Are you sure you want to call your family contact now?',
    ),
    _EmergencyQuickContact(
      key: 'hospital',
      title: 'Nearby\nHospital',
      dialogTitle: 'Call Nearby Hospital?',
      dialogMessage:
          'This will connect you to the nearest hospital for emergency help.',
    ),
    _EmergencyQuickContact(
      key: 'worker',
      title: 'Local Health\nWorker',
      dialogTitle: 'Call Local Health Worker?',
      dialogMessage:
          'This will connect you to your local health worker for quick medical support.',
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tx(
                            'Emergency Dashboard',
                            'आपतकालीन ड्यासबोर्ड',
                          ),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFAE0E0E),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          context.tx(
                            'Quick emergency support anytime',
                            'जुनसुकै बेला छिटो आपतकालीन सहयोग',
                          ),
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
                      context.tx('Emergency Contacts', 'आपतकालीन सम्पर्कहरू'),
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
                            title: _localizedQuickContactTitle(
                              context,
                              _quickContacts[0],
                            ),
                            avatar: ClipOval(
                              child: Image.asset(
                                'assets/images/family_contact_avatar.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                            onCall: () =>
                                _confirmAndCall(context, _quickContacts[0]),
                          ),
                          SizedBox(width: 12),
                          _EmergencyContactCard(
                            title: _localizedQuickContactTitle(
                              context,
                              _quickContacts[1],
                            ),
                            avatar: Image.asset(
                              'assets/images/hospital_contact_icon.png',
                              width: 27,
                              height: 27,
                              fit: BoxFit.contain,
                            ),
                            onCall: () =>
                                _confirmAndCall(context, _quickContacts[1]),
                          ),
                          SizedBox(width: 12),
                          _EmergencyContactCard(
                            title: _localizedQuickContactTitle(
                              context,
                              _quickContacts[2],
                            ),
                            avatar: Text(
                              '🧑‍⚕️',
                              style: TextStyle(fontSize: 18),
                            ),
                            onCall: () =>
                                _confirmAndCall(context, _quickContacts[2]),
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

  Future<void> _confirmAndCall(
    BuildContext context,
    _EmergencyQuickContact contact,
  ) async {
    final number = _resolveContactNumber(contact.key);

    if (number == null || number.trim().isEmpty) {
      _showFeedback(
        context,
        context.tx(
          'No contact number added. Please add an emergency contact first.',
          'सम्पर्क नम्बर थपिएको छैन। कृपया पहिले आपतकालीन सम्पर्क थप्नुहोस्।',
        ),
      );
      return;
    }

    final shouldCall = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            _localizedDialogTitle(context, contact),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B2330),
            ),
          ),
          content: Text(
            _localizedDialogMessage(context, contact),
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
              child: Text(context.tx('Call Now', 'अहिले कल गर्नुहोस्')),
            ),
          ],
        );
      },
    );

    if (shouldCall != true) return;

    final uri = Uri(scheme: 'tel', path: number);
    final launched = await launchUrl(uri);

    if (!launched && context.mounted) {
      _showFeedback(
        context,
        context.tx(
          'Unable to open the phone dialer right now.',
          'अहिले फोन डायलर खोल्न सकिएन।',
        ),
      );
    }
  }

  String _localizedQuickContactTitle(
    BuildContext context,
    _EmergencyQuickContact contact,
  ) {
    switch (contact.key) {
      case 'family':
        return context.tx('Family\nContact', 'परिवार\nसम्पर्क');
      case 'hospital':
        return context.tx('Nearby\nHospital', 'नजिकको\nअस्पताल');
      case 'worker':
        return context.tx('Local Health\nWorker', 'स्थानीय स्वास्थ्य\nकर्मी');
      default:
        return contact.title;
    }
  }

  String _localizedDialogTitle(
    BuildContext context,
    _EmergencyQuickContact contact,
  ) {
    switch (contact.key) {
      case 'family':
        return context.tx(
          'Call Family Contact?',
          'परिवार सम्पर्कलाई कल गर्ने?',
        );
      case 'hospital':
        return context.tx(
          'Call Nearby Hospital?',
          'नजिकको अस्पताललाई कल गर्ने?',
        );
      case 'worker':
        return context.tx(
          'Call Local Health Worker?',
          'स्थानीय स्वास्थ्यकर्मीलाई कल गर्ने?',
        );
      default:
        return contact.dialogTitle;
    }
  }

  String _localizedDialogMessage(
    BuildContext context,
    _EmergencyQuickContact contact,
  ) {
    switch (contact.key) {
      case 'family':
        return context.tx(
          'Are you sure you want to call your family contact now?',
          'के तपाईं अहिले आफ्नो परिवार सम्पर्कलाई कल गर्न चाहनुहुन्छ?',
        );
      case 'hospital':
        return context.tx(
          'This will connect you to the nearest hospital for emergency help.',
          'यसले तपाईंलाई आपतकालीन सहयोगका लागि नजिकको अस्पतालसँग जोड्नेछ।',
        );
      case 'worker':
        return context.tx(
          'This will connect you to your local health worker for quick medical support.',
          'यसले तपाईंलाई छिटो स्वास्थ्य सहयोगका लागि स्थानीय स्वास्थ्यकर्मीसँग जोड्नेछ।',
        );
      default:
        return contact.dialogMessage;
    }
  }

  String? _resolveContactNumber(String key) {
    if (key == 'family') {
      final phone = user?.phoneNumber.trim();
      return phone?.isNotEmpty == true ? phone : null;
    }

    final district = user?.district.trim().toLowerCase();

    if (key == 'hospital') {
      if (district == 'kathmandu') return '01-4111111';
      if (district == 'lalitpur') return '01-5555555';
      if (district == 'bhaktapur') return '01-6610798';
      return '01-4111111';
    }

    if (key == 'worker') {
      if (district == 'kathmandu') return '9800000002';
      if (district == 'lalitpur') return '9800000003';
      if (district == 'bhaktapur') return '9800000004';
      return '9800000002';
    }

    return null;
  }

  void _showFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
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
              child: _EmergencyActionCard(
                title: 'Call\nDoctor',
                icon: Icons.person_search_rounded,
                colors: const [Color(0xFF159AF2), Color(0xFF0878D8)],
                height: 126,
                fontSize: 18,
                iconSize: 44,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => DoctorScreen(user: user),
                    ),
                  );
                },
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
              child: _EmergencyActionCard(
                title: 'Share\nLocation',
                icon: Icons.navigation,
                colors: const [Color(0xFF10B84D), Color(0xFF069B3E)],
                height: 132,
                fontSize: 18,
                iconSize: 46,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => ShareLocationScreen(user: user),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              flex: 3,
              child: _EmergencyActionCard(
                title: 'Police\nHelp',
                icon: Icons.local_police_outlined,
                colors: const [Color(0xFF104DB2), Color(0xFF073681)],
                height: 132,
                fontSize: 18,
                iconSize: 46,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => PoliceHelpScreen(user: user),
                    ),
                  );
                },
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
  const _EmergencyContactCard({
    required this.title,
    required this.avatar,
    required this.onCall,
  });

  final String title;
  final Widget avatar;
  final VoidCallback onCall;

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

              GestureDetector(
                onTap: onCall,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF166EF3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.call,
                    color: Colors.white,
                    size: 15.5,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmergencyQuickContact {
  const _EmergencyQuickContact({
    required this.key,
    required this.title,
    required this.dialogTitle,
    required this.dialogMessage,
  });

  final String key;
  final String title;
  final String dialogTitle;
  final String dialogMessage;
}

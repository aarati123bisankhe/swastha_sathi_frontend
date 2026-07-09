import 'package:flutter/material.dart';
import 'package:swasthasathi/app/core/localization/app_text.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/record_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/blood_request_screen.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/call_ambulance_screen.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/emergency_screen.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/emergency_message_screen.dart';
import 'package:swasthasathi/app/features/emergency/presentation/pages/share_location_screen.dart';
import 'package:swasthasathi/app/features/support/presentation/pages/doctor_screen.dart';
import 'package:swasthasathi/app/features/support/presentation/pages/first_aid_box_screen.dart';
import 'package:swasthasathi/app/features/support/presentation/pages/health_awareness_screen.dart';
import 'package:swasthasathi/app/features/support/presentation/pages/hospital_screen.dart';
import 'package:swasthasathi/app/features/support/presentation/pages/symptom_checker_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    final name = _firstName(user?.fullName) ?? 'Aarati';
    final bloodGroup = user?.bloodGroup?.trim().isNotEmpty == true
        ? user!.bloodGroup!.trim()
        : 'O+';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
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
                          context.greeting(name),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 0),
                        Text(
                          context.tx(
                            'Take care, stay healthy!',
                            'ध्यान राख्नुहोस्, स्वस्थ रहनुहोस्!',
                          ),
                          style: TextStyle(
                            fontSize: 14,
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
                    child: Container(
                      margin: const EdgeInsets.only(top: 0),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.notifications,
                        color: Color(0xFF15396B),
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 3),

              _StatusCard(bloodGroup: bloodGroup),

              const SizedBox(height: 0),

              Transform.translate(
                offset: Offset(0, -22),
                child: _OfflineBanner(),
              ),

              const SizedBox(height: 0),

              Transform.translate(
                offset: const Offset(0, -40),
                child: _SectionHeader(
                  title: context.tx(
                    'Quick Emergency Actions',
                    'छिटो आपतकालीन कार्यहरू',
                  ),
                  actionLabel: context.tx('View all', 'सबै हेर्नुहोस्'),
                  onActionTap: () => _openEmergencyScreen(context),
                ),
              ),

              const SizedBox(height: 0),

              Transform.translate(
                offset: const Offset(0, -31),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final tileWidth = (constraints.maxWidth - 39) / 4;

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children:
                          [
                            _ActionTile(
                              title: context.tx(
                                'Call\nAmbulance',
                                'एम्बुलेन्स\nबोलाउनुहोस्',
                              ),
                              emoji: '🚑',
                              colors: const [
                                Color(0xFFFF6B6B),
                                Color(0xFFF64545),
                              ],
                              onTap: () => _openAmbulanceScreen(context),
                            ),
                            _ActionTile(
                              title: context.tx(
                                'Blood\nRequest',
                                'रगत\nअनुरोध',
                              ),
                              icon: Icons.water_drop,
                              colors: const [
                                Color(0xFFFF3838),
                                Color(0xFFE1142D),
                              ],
                              onTap: () => _openBloodRequestScreen(context),
                            ),
                            _ActionTile(
                              title: context.tx(
                                'Emergency\nSMS',
                                'आपतकालीन\nSMS',
                              ),
                              icon: Icons.sms_outlined,
                              colors: const [
                                Color(0xFF58B4FF),
                                Color(0xFF1F6FD7),
                              ],
                              onTap: () => _openEmergencyMessageScreen(context),
                            ),
                            _ActionTile(
                              title: context.tx(
                                'Share\nLocation',
                                'स्थान\nसाझा गर्नुहोस्',
                              ),
                              icon: Icons.location_on,
                              colors: const [
                                Color(0xFF5BCC5C),
                                Color(0xFF1BA64A),
                              ],
                              onTap: () => _openShareLocationScreen(context),
                            ),
                          ].map((tile) {
                            return SizedBox(width: tileWidth, child: tile);
                          }).toList(),
                    );
                  },
                ),
              ),

              Transform.translate(
                offset: const Offset(0, -17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tx('Health Features', 'स्वास्थ्य सुविधाहरू'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 10),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        const firstRowSpacing = 10.67;
                        const secondRowSpacing = 16.0;

                        final firstRowWidth =
                            (constraints.maxWidth - (firstRowSpacing * 3)) / 4;

                        final secondRowWidth =
                            (constraints.maxWidth - secondRowSpacing) / 4;

                        return Column(
                          children: [
                            Row(
                              children:
                                  [
                                    _FeatureTile(
                                      title: context.tx(
                                        'Symptom\nChecker',
                                        'लक्षण\nजाँच',
                                      ),
                                      icon: Icons.health_and_safety,
                                      iconColor: Color(0xFF1E88E5),
                                      onTap: () =>
                                          _openSymptomCheckerScreen(context),
                                    ),
                                    _FeatureTile(
                                      title: context.tx(
                                        'First Aid\nGuide',
                                        'प्राथमिक उपचार\nगाइड',
                                      ),
                                      icon: Icons.medical_services,
                                      iconColor: Color(0xFFFF2D55),
                                      onTap: () =>
                                          _openFirstAidBoxScreen(context),
                                    ),
                                    _FeatureTile(
                                      title: context.tx('Hospital', 'अस्पताल'),
                                      icon: Icons.local_hospital,
                                      iconColor: Color(0xFF1E88E5),
                                      onTap: () => _openHospitalScreen(context),
                                    ),
                                    _FeatureTile(
                                      title: context.tx('Doctor', 'डाक्टर'),
                                      icon: Icons.person,
                                      iconColor: Color(0xFF12B886),
                                      onTap: () => _openDoctorScreen(context),
                                    ),
                                  ].asMap().entries.map((entry) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        right: entry.key == 3
                                            ? 0
                                            : firstRowSpacing,
                                      ),
                                      child: SizedBox(
                                        width: firstRowWidth,
                                        child: entry.value,
                                      ),
                                    );
                                  }).toList(),
                            ),

                            const SizedBox(height: 10),

                            Row(
                              children: [
                                SizedBox(
                                  width: secondRowWidth,
                                  child: _FeatureTile(
                                    title: context.tx(
                                      'Health\nRecord',
                                      'स्वास्थ्य\nरेकर्ड',
                                    ),
                                    icon: Icons.assignment,
                                    iconColor: Color(0xFF7C4DFF),
                                    onTap: () => _openRecordScreen(context),
                                  ),
                                ),
                                const SizedBox(width: secondRowSpacing),
                                SizedBox(
                                  width: secondRowWidth,
                                  child: _FeatureTile(
                                    title: context.tx(
                                      'Awareness\nVideo',
                                      'जनचेतना\nभिडियो',
                                    ),
                                    icon: Icons.videocam,
                                    iconColor: Color(0xFF7C4DFF),
                                    onTap: () =>
                                        _openHealthAwarenessScreen(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              Transform.translate(
                offset: const Offset(0, -23),
                child: const _HealthTipCard(),
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

  String? _firstName(String? fullName) {
    if (fullName == null) return null;

    final trimmed = fullName.trim();

    if (trimmed.isEmpty) return null;

    return trimmed.split(RegExp(r'\s+')).first;
  }

  void _openAmbulanceScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => CallAmbulanceScreen(user: user),
      ),
    );
  }

  void _openEmergencyScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => EmergencyScreen(user: user),
      ),
    );
  }

  void _openBloodRequestScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => BloodRequestScreen(user: user),
      ),
    );
  }

  void _openEmergencyMessageScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => EmergencyMessageScreen(user: user),
      ),
    );
  }

  void _openShareLocationScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ShareLocationScreen(user: user),
      ),
    );
  }

  void _openSymptomCheckerScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => SymptomCheckerScreen(user: user),
      ),
    );
  }

  void _openFirstAidBoxScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => FirstAidBoxScreen(user: user),
      ),
    );
  }

  void _openHospitalScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => HospitalScreen(user: user)),
    );
  }

  void _openDoctorScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => DoctorScreen(user: user)),
    );
  }

  void _openHealthAwarenessScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => HealthAwarenessScreen(user: user),
      ),
    );
  }

  void _openRecordScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => RecordScreen(user: user)),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.bloodGroup});

  final String bloodGroup;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: double.infinity,
        height: 155,
        child: Image.asset(
          'assets/images/status_card_banner.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(
        'assets/images/offline_banner.png',
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),

        GestureDetector(
          onTap: onActionTap,
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF2D5BFF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.colors,
    this.icon,
    this.emoji,
    this.onTap,
  });

  final String title;
  final IconData? icon;
  final String? emoji;
  final List<Color> colors;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 96,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (emoji != null)
              Text(emoji!, style: const TextStyle(fontSize: 28))
            else if (icon != null)
              Icon(icon, size: 28, color: Colors.white),

            const SizedBox(height: 6),

            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.1,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.title,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 89,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: iconColor),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10.5,
                height: 1.12,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthTipCard extends StatefulWidget {
  const _HealthTipCard();

  @override
  State<_HealthTipCard> createState() => _HealthTipCardState();
}

class _HealthTipCardState extends State<_HealthTipCard> {
  int currentIndex = 0;

  final List<String> tips = [
    'Drink at least 8 glasses of water daily\nto stay hydrated and maintain good health.',
    'Walk at least 20 minutes every day\nto keep your body active and healthy.',
    'Sleep 7-8 hours daily\nto improve energy and immunity.',
    'Eat fruits and vegetables daily\nto maintain good health.',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: PageView.builder(
            itemCount: tips.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Image.asset(
                  'assets/images/daily_health_tip_banner.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

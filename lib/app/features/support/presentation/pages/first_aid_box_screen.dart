import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class FirstAidBoxScreen extends StatelessWidget {
  const FirstAidBoxScreen({super.key, this.user});

  final AuthUser? user;

  static const List<_EmergencyOption> _emergencies = [
    _EmergencyOption(
      emoji: '🩹',
      title: 'Cuts & Wounds',
      steps: [
        'Wash your hands first if possible.',
        'Press gently on the wound to stop bleeding.',
        'Clean the area with safe water.',
        'Cover with a clean bandage.',
      ],
    ),
    _EmergencyOption(
      emoji: '🔥',
      title: 'Burns',
      steps: [
        'Cool the burn with running water for several minutes.',
        'Do not apply ice directly.',
        'Cover loosely with a clean cloth or gauze.',
        'Seek help if the burn is large or severe.',
      ],
    ),
    _EmergencyOption(
      emoji: '🫁',
      title: 'Choking',
      steps: [
        'Ask if the person can speak or cough.',
        'Encourage coughing if they can breathe.',
        'Give back blows if the airway seems blocked.',
        'Call emergency help right away if the person cannot breathe.',
      ],
    ),
    _EmergencyOption(
      emoji: '👃',
      title: 'Nose Bleed',
      steps: [
        'Sit upright and lean slightly forward.',
        'Pinch the soft part of the nose.',
        'Keep pressure for 10 minutes.',
        'Get medical help if bleeding does not stop.',
      ],
    ),
    _EmergencyOption(
      emoji: '🤕',
      title: 'Headache',
      steps: [
        'Rest in a quiet and calm place.',
        'Drink water and avoid bright light.',
        'Use a cold cloth on the forehead if needed.',
        'Seek care if pain is sudden or very severe.',
      ],
    ),
    _EmergencyOption(
      emoji: '🐝',
      title: 'Insect Bites',
      steps: [
        'Wash the area gently.',
        'Use a cool compress for swelling.',
        'Avoid scratching the bite.',
        'Get urgent help if breathing becomes difficult.',
      ],
    ),
    _EmergencyOption(
      emoji: '🦴',
      title: 'Fractures',
      steps: [
        'Keep the injured area still.',
        'Do not try to straighten the limb.',
        'Use a splint only if trained.',
        'Get medical help as soon as possible.',
      ],
    ),
    _EmergencyOption(
      emoji: '⚡',
      title: 'Electric Shock',
      steps: [
        'Turn off the power source first if safe.',
        'Do not touch the person with bare hands until safe.',
        'Call emergency services immediately.',
        'Check breathing and responsiveness.',
      ],
    ),
    _EmergencyOption(
      emoji: '•••',
      title: 'More',
      steps: [
        'Keep a stocked first aid box nearby.',
        'Learn CPR and basic emergency response.',
        'Use trusted medical guidance when unsure.',
        'Call emergency services for serious situations.',
      ],
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
              const SizedBox(height: 24),
              const _BannerCard(),
              const SizedBox(height: 22),
              const Text(
                'Choose an Emergency',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 16),
              _EmergencyGrid(
                emergencies: _emergencies,
                onTap: (emergency) => _showEmergencyGuide(context, emergency),
              ),
              const SizedBox(height: 22),
              const _QuickReminderCard(),
              const SizedBox(height: 22),
              const Text(
                'First Aid Essentials Checklist',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 16),
              const _ChecklistCard(),
              const SizedBox(height: 18),
              const _SafetyMessageCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        activeTab: DashboardNavTab.support,
        user: user,
      ),
    );
  }

  void _showEmergencyGuide(BuildContext context, _EmergencyOption emergency) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
          decoration: const BoxDecoration(
            color: Color(0xFFF7FBFF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4DCE8),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Text(emergency.emoji, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      emergency.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFB01414),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...emergency.steps.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFE8E8),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFD61E1E),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.4,
                            color: Color(0xFF40516A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
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
          child: const Padding(
            padding: EdgeInsets.only(top: 8, right: 12),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF7B828B),
              size: 19,
            ),
          ),
        ),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'First Aid Box',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFAB1010),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Quick guidance for common emergencies',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF30343A),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFFFDE6E9), Color(0xFFFBEDEF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 132,
            height: 132,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5858), Color(0xFFEF2222)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33E02C2C),
                  blurRadius: 18,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: 10,
                  left: 8,
                  child: Container(
                    width: 30,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  child: Container(
                    width: 52,
                    height: 18,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF8D9097),
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: Color(0xFFF12424),
                    size: 40,
                  ),
                ),
                Positioned(
                  right: 2,
                  bottom: 16,
                  child: Container(
                    width: 22,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 4,
                  child: Container(
                    width: 24,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFC9A7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Be Prepared. Save Lives.',
                  style: TextStyle(
                    fontSize: 18,
                    height: 1.25,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD81616),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Learn simple first aid for everyday emergencies.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: Color(0xFF4A586E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyGrid extends StatelessWidget {
  const _EmergencyGrid({required this.emergencies, required this.onTap});

  final List<_EmergencyOption> emergencies;
  final ValueChanged<_EmergencyOption> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final tileWidth = (constraints.maxWidth - (spacing * 3)) / 4;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: emergencies.map((emergency) {
            return SizedBox(
              width: tileWidth,
              child: _EmergencyTile(
                emergency: emergency,
                onTap: () => onTap(emergency),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _EmergencyTile extends StatelessWidget {
  const _EmergencyTile({required this.emergency, required this.onTap});

  final _EmergencyOption emergency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 92,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.88),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFB9C3D3)),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  emergency.emoji,
                  style: TextStyle(
                    fontSize: emergency.title == 'More' ? 24 : 30,
                    height: 1,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    emergency.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.15,
                      color: Color(0xFF26364C),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF6C7590),
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickReminderCard extends StatelessWidget {
  const _QuickReminderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFF2828), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE0E0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Color(0xFFE51A1A),
              size: 30,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Reminder',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFD81616),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'In a serious emergency, call emergency services immediately.',
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    color: Color(0xFF33445A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 178,
            height: 68,
            decoration: BoxDecoration(
              color: const Color(0xFFFF0E0E),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26D61F1F),
                  blurRadius: 14,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.call, color: Colors.white, size: 28),
                SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Call',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '101',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard();

  static const _items = [
    'Bandage',
    'Antiseptic\nWipes',
    'Gauze\nPads',
    'Adhesive\nTape',
    'Scissors',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: _items.map((item) {
          return Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF10B44B),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.2,
                      color: Color(0xFF344560),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SafetyMessageCard extends StatelessWidget {
  const _SafetyMessageCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFDDF9E9), Color(0xFFC9F5E0)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Color(0xFF2DD475),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stay calm and follow the steps carefully.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF39516A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Your quick action can make a big difference.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF39516A),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.favorite_outline_rounded,
            color: Color(0xFF84DFB6),
            size: 54,
          ),
        ],
      ),
    );
  }
}

class _EmergencyOption {
  const _EmergencyOption({
    required this.emoji,
    required this.title,
    required this.steps,
  });

  final String emoji;
  final String title;
  final List<String> steps;
}

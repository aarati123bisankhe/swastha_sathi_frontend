import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class EmergencyMessageScreen extends StatefulWidget {
  const EmergencyMessageScreen({super.key, this.user});

  final AuthUser? user;

  @override
  State<EmergencyMessageScreen> createState() => _EmergencyMessageScreenState();
}

class _EmergencyMessageScreenState extends State<EmergencyMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  _EmergencyType _selectedType = _EmergencyType.medical;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageLength = _messageController.text.length;

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
                          'Emergency Message',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFAE0E0E),
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Send an emergency message for help',
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
              const SizedBox(height: 20),
              const _EmergencyHelpBanner(),
              const SizedBox(height: 20),
              const _SectionLabel('To (Emergency Contacts)'),
              const SizedBox(height: 10),
              const _SelectorCard(
                leading: Icons.people_outline_rounded,
                leadingColor: Color(0xFFFF2F2F),
                title: '3 Contacts Selected',
                trailing: Icons.chevron_right_rounded,
              ),
              const SizedBox(height: 18),
              const _SectionLabel('Message'),
              const SizedBox(height: 10),
              _MessageComposer(
                controller: _messageController,
                messageLength: messageLength,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 18),
              const _SectionLabel('Your Location'),
              const SizedBox(height: 10),
              const _SelectorCard(
                leading: Icons.location_on,
                leadingColor: Color(0xFF193767),
                title: 'Select Location',
              ),
              const SizedBox(height: 22),
              const _SectionLabel('Emergency Type'),
              const SizedBox(height: 10),
              Row(
                children: _EmergencyType.values
                    .map(
                      (type) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: type == _EmergencyType.values.last ? 0 : 14,
                          ),
                          child: _EmergencyTypeCard(
                            type: type,
                            selected: _selectedType == type,
                            onTap: () {
                              setState(() {
                                _selectedType = type;
                              });
                            },
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 28),
              Center(
                child: SizedBox(
                  width: 290,
                  child: FilledButton.icon(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF1212),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    icon: const Icon(Icons.send_rounded, size: 20),
                    label: const Text(
                      'Send Emergency Message',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
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
}

class _EmergencyHelpBanner extends StatelessWidget {
  const _EmergencyHelpBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFF6F6), Color(0xFFFFF0F0)],
        ),
        border: Border.all(color: const Color(0xFFFFCACA)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFF1818),
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1FFF1818),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  bottom: 8,
                  child: Icon(Icons.chat_bubble, color: Colors.white, size: 19),
                ),
                Positioned(
                  top: 11,
                  child: Text(
                    'SOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need Help?',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFFF2323),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Send your emergency message to your contacts instantly.',
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5A6C84),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFFFE0E0), Color(0x00FFE0E0)],
              ),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Color(0xFFFF3A3A),
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        height: 1.0,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }
}

class _SelectorCard extends StatelessWidget {
  const _SelectorCard({
    required this.leading,
    required this.leadingColor,
    required this.title,
    this.trailing,
  });

  final IconData leading;
  final Color leadingColor;
  final String title;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F7FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFA4B1C0)),
      ),
      child: Row(
        children: [
          Icon(leading, color: leadingColor, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1B1F28),
              ),
            ),
          ),
          if (trailing != null)
            Icon(trailing, color: const Color(0xFF1B1F28), size: 24),
        ],
      ),
    );
  }
}

class _MessageComposer extends StatelessWidget {
  const _MessageComposer({
    required this.controller,
    required this.messageLength,
    required this.onChanged,
  });

  final TextEditingController controller;
  final int messageLength;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 118,
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F7FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFA4B1C0)),
      ),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLength: 160,
              maxLines: null,
              expands: true,
              onChanged: onChanged,
              decoration: const InputDecoration(
                counterText: '',
                hintText: 'Type your emergency message........',
                hintStyle: TextStyle(color: Color(0xFF6D7684), fontSize: 14),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 54),
                  child: Icon(Icons.chat, color: Color(0xFF223B63), size: 17),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '$messageLength/160',
              style: const TextStyle(fontSize: 12, color: Color(0xFF6D7684)),
            ),
          ),
        ],
      ),
    );
  }
}

enum _EmergencyType { medical, fire, accident, other }

extension on _EmergencyType {
  String get label {
    switch (this) {
      case _EmergencyType.medical:
        return 'Medical';
      case _EmergencyType.fire:
        return 'Fire';
      case _EmergencyType.accident:
        return 'Accident';
      case _EmergencyType.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case _EmergencyType.medical:
        return Icons.add_circle;
      case _EmergencyType.fire:
        return Icons.local_fire_department;
      case _EmergencyType.accident:
        return Icons.directions_car;
      case _EmergencyType.other:
        return Icons.more_horiz;
    }
  }
}

class _EmergencyTypeCard extends StatelessWidget {
  const _EmergencyTypeCard({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final _EmergencyType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 82,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFFFF2A2A) : const Color(0xFFD3DCE7),
          ),
          gradient: selected
              ? const LinearGradient(
                  colors: [Color(0xFFFFFCFC), Color(0xFFFFF0F0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          color: selected ? null : const Color(0xFFF2F7FC),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(type.icon, color: const Color(0xFFFF1111), size: 25),
            const SizedBox(height: 5),
            Text(
              type.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3B4352),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

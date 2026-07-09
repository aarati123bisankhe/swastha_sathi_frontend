import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyMessageScreen extends StatefulWidget {
  const EmergencyMessageScreen({super.key, this.user});

  final AuthUser? user;

  @override
  State<EmergencyMessageScreen> createState() => _EmergencyMessageScreenState();
}

class _EmergencyMessageScreenState extends State<EmergencyMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<_EmergencyContact> _contacts = const [];
  Set<String> _selectedContactIds = <String>{};
  _EmergencyType _selectedType = _EmergencyType.medical;
  String? _selectedLocation;

  static const List<String> _locationOptions = [
    'Kathmandu, Nepal',
    'Lalitpur, Nepal',
    'Bhaktapur, Nepal',
    'Kirtipur, Nepal',
  ];

  @override
  void initState() {
    super.initState();
    _contacts = _buildContacts();
    _selectedContactIds = _contacts
        .take(3)
        .map((contact) => contact.id)
        .toSet();
    _selectedLocation = widget.user?.district.trim().isNotEmpty == true
        ? '${widget.user!.district.trim()}, Nepal'
        : null;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageLength = _messageController.text.length;
    final selectedContacts = _contacts
        .where((contact) => _selectedContactIds.contains(contact.id))
        .toList();
    final contactsLabel = selectedContacts.isEmpty
        ? 'Select contacts'
        : selectedContacts.map((contact) => contact.phoneNumber).join(', ');

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
              _SelectorCard(
                leading: Icons.people_outline_rounded,
                leadingColor: Color(0xFFFF2F2F),
                title: contactsLabel,
                trailing: Icons.chevron_right_rounded,
                onTap: _selectContacts,
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
              _SelectorCard(
                leading: Icons.location_on,
                leadingColor: Color(0xFF193767),
                title: _selectedLocation ?? 'Select Location',
                onTap: _selectLocation,
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
                    onPressed: _sendEmergencyMessage,
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

  List<_EmergencyContact> _buildContacts() {
    final userPhone = widget.user?.phoneNumber.trim();

    return [
      _EmergencyContact(
        id: 'family',
        name: 'Family Contact',
        phoneNumber: userPhone?.isNotEmpty == true ? userPhone! : '98XXXXXXXX',
      ),
      const _EmergencyContact(
        id: 'doctor',
        name: 'Family Doctor',
        phoneNumber: '9800000001',
      ),
      const _EmergencyContact(
        id: 'neighbor',
        name: 'Nearby Neighbor',
        phoneNumber: '9800000002',
      ),
      const _EmergencyContact(
        id: 'friend',
        name: 'Trusted Friend',
        phoneNumber: '9800000003',
      ),
    ];
  }

  Future<void> _selectContacts() async {
    final tempSelected = Set<String>.from(_selectedContactIds);

    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select emergency contacts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1B1F28),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ..._contacts.map((contact) {
                      final selected = tempSelected.contains(contact.id);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFFFFCACA)
                                : const Color(0xFFD9E2EC),
                          ),
                          color: selected
                              ? const Color(0xFFFFF6F6)
                              : Colors.white,
                        ),
                        child: CheckboxListTile(
                          value: selected,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          activeColor: const Color(0xFFFF1212),
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                            contact.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(contact.phoneNumber),
                          onChanged: (value) {
                            setModalState(() {
                              if (value ?? false) {
                                tempSelected.add(contact.id);
                              } else {
                                tempSelected.remove(contact.id);
                              }
                            });
                          },
                        ),
                      );
                    }),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop(tempSelected);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFF1212),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text('Save Selection'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedContactIds
          ..clear()
          ..addAll(result);
      });
      _showFeedback(
        result.isEmpty
            ? 'No emergency contacts selected.'
            : '${result.length} emergency contact(s) selected.',
      );
    }
  }

  Future<void> _selectLocation() async {
    final location = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B1F28),
                  ),
                ),
                const SizedBox(height: 14),
                ..._locationOptions.map(
                  (location) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      _selectedLocation == location
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: const Color(0xFF193767),
                    ),
                    title: Text(location),
                    onTap: () => Navigator.of(context).pop(location),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (location != null) {
      setState(() {
        _selectedLocation = location;
      });
    }
  }

  Future<void> _sendEmergencyMessage() async {
    if (_selectedContactIds.isEmpty) {
      _showFeedback('Please select at least one emergency contact.');
      return;
    }

    if (_messageController.text.trim().isEmpty) {
      _showFeedback('Please type your emergency message.');
      return;
    }

    if (_selectedLocation == null) {
      _showFeedback('Please select your location.');
      return;
    }

    final recipients = _contacts
        .where((contact) => _selectedContactIds.contains(contact.id))
        .map((contact) => contact.phoneNumber)
        .join(',');
    final emergencyType = _selectedType.label;
    final message =
        'Emergency ($emergencyType): ${_messageController.text.trim()}\n'
        'Location: $_selectedLocation';

    final smsUri = Uri(
      scheme: 'sms',
      path: recipients,
      queryParameters: {'body': message},
    );

    final launched = await launchUrl(
      smsUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      _showFeedback('Unable to open the messaging app right now.');
      return;
    }

    setState(() {
      _messageController.clear();
      _selectedContactIds.clear();
      _selectedLocation = null;
      _selectedType = _EmergencyType.medical;
    });

    _showFeedback('Emergency message sent successfully.', isSuccess: true);
  }

  void _showFeedback(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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
    this.onTap,
  });

  final IconData leading;
  final Color leadingColor;
  final String title;
  final IconData? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
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

class _EmergencyContact {
  const _EmergencyContact({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  final String id;
  final String name;
  final String phoneNumber;
}

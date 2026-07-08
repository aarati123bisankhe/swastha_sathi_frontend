import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';

class SymptomCheckerScreen extends StatefulWidget {
  const SymptomCheckerScreen({super.key, this.user});

  final AuthUser? user;

  @override
  State<SymptomCheckerScreen> createState() => _SymptomCheckerScreenState();
}

class _SymptomCheckerScreenState extends State<SymptomCheckerScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatEntry> _entries = [];

  _ConversationStep _step = _ConversationStep.symptom;
  String? _selectedSymptom;
  String? _selectedDuration;
  String? _selectedFollowUp;
  String? _severity;

  static const List<_QuickOption> _symptomOptions = [
    _QuickOption('Fever', Icons.thermostat_rounded, Color(0xFF1E88F7)),
    _QuickOption('Headache', Icons.psychology_alt_rounded, Color(0xFFA0ADD6)),
    _QuickOption('Cough', Icons.masks_rounded, Color(0xFF25C678)),
    _QuickOption('Stomach Pain', Icons.healing_rounded, Color(0xFFFF6A8B)),
    _QuickOption(
      'Vomiting',
      Icons.accessibility_new_rounded,
      Color(0xFF9B5CFF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entries.add(
      const _ChatEntry.bot(
        'Hello 👋\nWhat symptom are you experiencing today?',
        timeLabel: '09:41 AM',
        actionStep: _ConversationStep.symptom,
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEAF5),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
              child: _Header(user: widget.user),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(12, 20, 12, 18),
                  children: [
                    ..._buildConversation(),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
              child: _InputBar(
                controller: _messageController,
                onSend: _handleTypedMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildConversation() {
    final widgets = <Widget>[];

    for (final entry in _entries) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: switch (entry.type) {
            _ChatEntryType.bot => _BotMessageBubble(
              message: entry.message,
              timeLabel: entry.timeLabel,
            ),
            _ChatEntryType.user => _UserMessageBubble(
              message: entry.message,
              timeLabel: entry.timeLabel,
            ),
            _ChatEntryType.guidance => _GuidanceCard(
              severity: _severity ?? 'Low',
            ),
          },
        ),
      );

      if (entry.type == _ChatEntryType.bot && entry.actionStep == _step) {
        widgets.add(_buildOptionBar());
      }
    }

    return widgets;
  }

  Widget _buildOptionBar() {
    if (_step == _ConversationStep.completed) {
      return const SizedBox.shrink();
    }

    if (_step == _ConversationStep.symptom) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Wrap(
          spacing: 8,
          runSpacing: 10,
          children: _symptomOptions.map((option) {
            final isSelected = _selectedSymptom == option.label;
            return _OptionPill(
              label: option.label,
              icon: option.icon,
              iconColor: isSelected ? Colors.white : option.color,
              selected: isSelected,
              minWidth: option.label == 'Stomach Pain' ? 142 : null,
              onTap: () => _selectSymptom(option.label),
            );
          }).toList(),
        ),
      );
    }

    if (_step == _ConversationStep.duration) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _OptionPill(
              label: '1 Day',
              selected: _selectedDuration == '1 Day',
              onTap: () => _selectDuration('1 Day'),
            ),
            _OptionPill(
              label: '2-3 Days',
              selected: _selectedDuration == '2-3 Days',
              onTap: () => _selectDuration('2-3 Days'),
            ),
            _OptionPill(
              label: 'More than 3 Days',
              selected: _selectedDuration == 'More than 3 Days',
              onTap: () => _selectDuration('More than 3 Days'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Wrap(
        spacing: 10,
        children: [
          _OptionPill(
            label: 'Yes',
            selected: _selectedFollowUp == 'Yes',
            onTap: () => _selectFollowUp('Yes'),
          ),
          _OptionPill(
            label: 'No',
            selected: _selectedFollowUp == 'No',
            onTap: () => _selectFollowUp('No'),
          ),
        ],
      ),
    );
  }

  void _selectSymptom(String symptom) {
    _appendUserMessage(symptom, timeLabel: '09:41 AM');

    if (symptom == 'Fever') {
      setState(() {
        _selectedSymptom = symptom;
        _step = _ConversationStep.duration;
        _entries.add(
          const _ChatEntry.bot(
            'How long have you had fever?',
            timeLabel: '09:41 AM',
            actionStep: _ConversationStep.duration,
          ),
        );
      });
    } else {
      setState(() {
        _selectedSymptom = symptom;
        _step = _ConversationStep.symptom;
        _entries.add(
          const _ChatEntry.bot(
            'Please try the Fever option to continue this guided demo chat.',
            timeLabel: '09:41 AM',
            actionStep: _ConversationStep.symptom,
          ),
        );
      });
    }

    _scrollToBottom();
  }

  void _selectDuration(String duration) {
    _appendUserMessage(duration, timeLabel: '09:42 AM');

    setState(() {
      _selectedDuration = duration;
      _step = _ConversationStep.followUp;
      _entries.add(
        const _ChatEntry.bot(
          'Do you also have cough or body pain?',
          timeLabel: '09:41 AM',
          actionStep: _ConversationStep.followUp,
        ),
      );
    });

    _scrollToBottom();
  }

  void _selectFollowUp(String answer) {
    _appendUserMessage(answer, timeLabel: '09:42 AM');

    setState(() {
      _selectedFollowUp = answer;
      _severity = answer == 'Yes' ? 'Medium' : 'Low';
      _step = _ConversationStep.completed;
      _entries.add(const _ChatEntry.guidance());
    });

    _scrollToBottom();
  }

  void _handleTypedMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    _appendUserMessage(text, timeLabel: '09:42 AM');

    if (_step == _ConversationStep.symptom && text.toLowerCase() == 'fever') {
      setState(() {
        _selectedSymptom = 'Fever';
        _step = _ConversationStep.duration;
        _entries.add(
          const _ChatEntry.bot(
            'How long have you had fever?',
            timeLabel: '09:41 AM',
            actionStep: _ConversationStep.duration,
          ),
        );
      });
    } else {
      setState(() {
        _entries.add(
          const _ChatEntry.bot(
            'Please use the quick options so I can guide you step by step.',
            timeLabel: '09:42 AM',
          ),
        );
      });
    }

    _scrollToBottom();
  }

  void _appendUserMessage(String message, {required String timeLabel}) {
    setState(() {
      _entries.add(_ChatEntry.user(message, timeLabel: timeLabel));
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 140,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
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
            padding: EdgeInsets.only(top: 9, right: 12),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF7D8189),
              size: 18,
            ),
          ),
        ),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Symptom Checker',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF251E7E),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Answer a few questions to get health guidance',
                style: TextStyle(
                  fontSize: 13,
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

class _BotMessageBubble extends StatelessWidget {
  const _BotMessageBubble({required this.message, required this.timeLabel});

  final String message;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _BotAvatar(),
        const SizedBox(width: 10),
        Flexible(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 250),
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.96),
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x190A3B72),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.35,
                    color: Color(0xFF2D4664),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  timeLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFA3AFBF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _UserMessageBubble extends StatelessWidget {
  const _UserMessageBubble({required this.message, required this.timeLabel});

  final String message;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 210),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          decoration: BoxDecoration(
            color: const Color(0xFFD5F7E5),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color(0x141C8F5C),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF265E49),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    timeLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF89AFA0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(
                    Icons.done_all_rounded,
                    size: 16,
                    color: Color(0xFF02A84F),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OptionPill extends StatelessWidget {
  const _OptionPill({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.iconColor,
    this.minWidth,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? iconColor;
  final double? minWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minWidth: minWidth ?? 0),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1E88F7) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? const Color(0xFF1E88F7) : const Color(0xFFD7E0F2),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x140D447D),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: iconColor ?? const Color(0xFF1E88F7)),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: selected ? Colors.white : const Color(0xFF53647D),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  const _GuidanceCard({required this.severity});

  final String severity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFCFEFDD)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140D447D),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE3FFF0), Color(0xFFC7F7DE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.assignment_turned_in_rounded,
                  size: 42,
                  color: Color(0xFF00B45E),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Here is your health guidance',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF05A159),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 10),
                    _GuidanceLine(
                      text: 'You may have a common viral infection.',
                    ),
                    SizedBox(height: 8),
                    _GuidanceLine(text: 'Drink enough water and take rest.'),
                    SizedBox(height: 8),
                    _GuidanceLine(
                      text: 'Visit nearby health center if symptoms continue.',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFFE1E8F0), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Severity',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF35445B),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: Color(0xFFA0A7B4),
              ),
              const Spacer(),
              _SeverityBadge(label: 'Low', active: severity == 'Low'),
              const SizedBox(width: 10),
              _SeverityBadge(label: 'Medium', active: severity == 'Medium'),
              const SizedBox(width: 10),
              _SeverityBadge(label: 'High', active: severity == 'High'),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuidanceLine extends StatelessWidget {
  const _GuidanceLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(
            Icons.check_circle_rounded,
            size: 16,
            color: Color(0xFF03AF57),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13.5,
              height: 1.35,
              color: Color(0xFF4F647C),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _SeverityBadge extends StatelessWidget {
  const _SeverityBadge({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    late final Color color;
    switch (label) {
      case 'Low':
        color = const Color(0xFF06C46A);
      case 'Medium':
        color = const Color(0xFFF0A128);
      case 'High':
        color = const Color(0xFFFF4C4C);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? color.withValues(alpha: 0.12) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: active ? color : const Color(0xFFE2E7EE)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const _BotAvatar(size: 38, iconSize: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'Describe your symptoms...',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF7B8BA4).withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: Color(0xFFD8E0EC)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: Color(0xFFD8E0EC)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: const BorderSide(color: Color(0xFF1E88F7)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF1E88F7),
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BotAvatar extends StatelessWidget {
  const _BotAvatar({this.size = 44, this.iconSize = 24});

  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFF7FFFF), Color(0xFFDDF8F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x141C8F5C),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size - 8,
          height: size - 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE0F1F8)),
          ),
          child: Icon(
            Icons.smart_toy_rounded,
            color: const Color(0xFF0FB0D0),
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

class _QuickOption {
  const _QuickOption(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
}

class _ChatEntry {
  const _ChatEntry.bot(this.message, {required this.timeLabel, this.actionStep})
    : type = _ChatEntryType.bot;

  const _ChatEntry.user(this.message, {required this.timeLabel})
    : type = _ChatEntryType.user,
      actionStep = null;

  const _ChatEntry.guidance()
    : type = _ChatEntryType.guidance,
      message = '',
      timeLabel = '',
      actionStep = null;

  final _ChatEntryType type;
  final String message;
  final String timeLabel;
  final _ConversationStep? actionStep;
}

enum _ChatEntryType { bot, user, guidance }

enum _ConversationStep { symptom, duration, followUp, completed }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';

class ChatSupportScreen extends StatefulWidget {
  const ChatSupportScreen({super.key, this.user});

  final AuthUser? user;

  @override
  State<ChatSupportScreen> createState() => _ChatSupportScreenState();
}

class _ChatSupportScreenState extends State<ChatSupportScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _selectedCategory;
  bool _supportTyping = false;

  final List<_SupportMessage> _messages = [
    const _SupportMessage(
      text:
          'Hello! 👋\nWelcome to Swastha Sathi+ Support.\nHow can we help you today?',
      fromSupport: true,
      timeLabel: '10:30 AM',
    ),
  ];

  static const List<_SupportCategory> _categories = [
    _SupportCategory(
      label: 'General\nHealth',
      icon: Icons.medical_services_outlined,
      iconColor: Color(0xFF1E88F5),
      background: Color(0xFFE8F4FF),
      topic: 'General Health',
    ),
    _SupportCategory(
      label: 'Pregnancy\nCare',
      icon: Icons.pregnant_woman_rounded,
      iconColor: Color(0xFF20BFA8),
      background: Color(0xFFE8FBF7),
      topic: 'Pregnancy Care',
    ),
    _SupportCategory(
      label: 'Menstrual\nHealth',
      icon: Icons.water_drop_rounded,
      iconColor: Color(0xFFFF5D73),
      background: Color(0xFFFFEEF1),
      topic: 'Menstrual Health',
    ),
    _SupportCategory(
      label: 'Child\nHealth',
      icon: Icons.child_care_rounded,
      iconColor: Color(0xFFAE77FF),
      background: Color(0xFFF4EDFF),
      topic: 'Child Health',
    ),
    _SupportCategory(
      label: 'Mental\nHealth',
      icon: Icons.psychology_alt_rounded,
      iconColor: Color(0xFFFFA54B),
      background: Color(0xFFFFF3E6),
      topic: 'Mental Health',
    ),
  ];

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
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ChatSupportHeader(user: widget.user),
                    const SizedBox(height: 7),
                    const _SupportBanner(),
                    const SizedBox(height: 13),
                    const _SupportCategoriesTitle(),
                    const SizedBox(height: 9),
                    _SupportCategoriesRow(
                      categories: _categories,
                      selectedTopic: _selectedCategory,
                      onSelected: _selectCategory,
                    ),
                    const SizedBox(height: 18),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF251E7E),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    ..._messages.map(
                      (message) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _SupportMessageBubble(message: message),
                      ),
                    ),
                    if (_supportTyping)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 14),
                        child: _SupportTypingBubble(),
                      ),
                  ],
                ),
              ),
            ),
            _SupportComposer(
              controller: _messageController,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  void _selectCategory(String topic) {
    setState(() {
      _selectedCategory = topic;
      _messages.add(
        _SupportMessage(
          text: 'I need help with $topic.',
          fromSupport: false,
          timeLabel: _formatTime(TimeOfDay.now()),
        ),
      );
      _supportTyping = true;
    });

    _scrollToBottom();

    Future<void>.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _supportTyping = false;
        _messages.add(
          _SupportMessage(
            text: _categoryReply(topic),
            fromSupport: true,
            timeLabel: _formatTime(TimeOfDay.now()),
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _SupportMessage(
          text: text,
          fromSupport: false,
          timeLabel: _formatTime(TimeOfDay.now()),
        ),
      );
      _messageController.clear();
      _supportTyping = true;
    });

    _scrollToBottom();

    Future<void>.delayed(const Duration(milliseconds: 850), () {
      if (!mounted) return;
      setState(() {
        _supportTyping = false;
        _messages.add(
          _SupportMessage(
            text:
                'For headache and fever, please take rest, drink enough water, and monitor your temperature. If symptoms become severe or continue, please visit a nearby hospital or consult a doctor.',
            fromSupport: true,
            timeLabel: _formatTime(TimeOfDay.now()),
          ),
        );
      });
      _scrollToBottom();
    });
  }

  String _categoryReply(String topic) {
    if (topic == 'Pregnancy Care') {
      return 'Our pregnancy care team can help with checkups, nutrition, warning signs, and when to visit a doctor. Please share your concern.';
    }
    if (topic == 'Menstrual Health') {
      return 'We can guide you with menstrual hygiene, pain relief, irregular cycles, and when symptoms should be checked by a doctor.';
    }
    if (topic == 'Child Health') {
      return 'For child health support, please tell us the child’s symptoms, age, and how long the problem has been happening.';
    }
    if (topic == 'Mental Health') {
      return 'You are not alone. We can help with stress, anxiety, mood concerns, and where to seek urgent emotional support if needed.';
    }
    return 'We are here to support your general health questions. Please tell us more so we can guide you properly.';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 160,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    });
  }
}

class _ChatSupportHeader extends StatelessWidget {
  const _ChatSupportHeader({this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Transform.translate(
            offset: const Offset(-8, 0),
            child: const Padding(
              padding: EdgeInsets.only(top: 8, right: 8),
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
                'Chat Support',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF251E7E),
                ),
              ),
              SizedBox(height: 1),
              Text(
                'We are here to help you',
                style: TextStyle(fontSize: 13, color: Color(0xFF555D69)),
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
            padding: EdgeInsets.only(top: 2),
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

class _SupportBanner extends StatelessWidget {
  const _SupportBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Image.asset(
          'assets/images/chat_support_banner.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _SupportCategoriesTitle extends StatelessWidget {
  const _SupportCategoriesTitle();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Support Categories',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: Color(0xFF251E7E),
      ),
    );
  }
}

class _SupportCategoriesRow extends StatelessWidget {
  const _SupportCategoriesRow({
    required this.categories,
    required this.selectedTopic,
    required this.onSelected,
  });

  final List<_SupportCategory> categories;
  final String? selectedTopic;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories
            .map(
              (category) => _CategoryButton(
                category: category,
                selected: selectedTopic == category.topic,
                onTap: () => onSelected(category.topic),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final _SupportCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 54,
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected
                    ? category.iconColor.withValues(alpha: 0.16)
                    : category.background,
                borderRadius: BorderRadius.circular(18),
                border: selected
                    ? Border.all(
                        color: category.iconColor.withValues(alpha: 0.55),
                      )
                    : null,
              ),
              child: Icon(category.icon, color: category.iconColor, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              category.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                height: 1.15,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportMessageBubble extends StatelessWidget {
  const _SupportMessageBubble({required this.message});

  final _SupportMessage message;

  @override
  Widget build(BuildContext context) {
    if (message.fromSupport) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: SizedBox(
              width: 42,
              height: 42,
              child: Image.asset(
                'assets/images/doctor_aanaya_new.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x18000000),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: Color(0xFF1F2630),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  message.timeLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8A919B),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.fromLTRB(18, 14, 16, 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEAF4FF), Color(0xFFD7ECFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                color: Color(0xFF1F2630),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.timeLabel,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8A919B),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.done_all_rounded,
                  size: 18,
                  color: Color(0xFF1E88F5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportTypingBubble extends StatelessWidget {
  const _SupportTypingBubble();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: SizedBox(
            width: 42,
            height: 42,
            child: Image.asset(
              'assets/images/doctor_aanaya_new.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x18000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TypingDot(),
              SizedBox(width: 4),
              _TypingDot(),
              SizedBox(width: 4),
              _TypingDot(),
            ],
          ),
        ),
      ],
    );
  }
}

class _TypingDot extends StatelessWidget {
  const _TypingDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
        color: Color(0xFF7A8DAA),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _SupportComposer extends StatelessWidget {
  const _SupportComposer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 26),
      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipOval(
            child: SizedBox(
              width: 38,
              height: 38,
              child: Image.asset(
                'assets/images/doctor_aanaya_new.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Type your message...',
                hintStyle: TextStyle(fontSize: 15, color: Color(0xFF8A919B)),
              ),
              style: const TextStyle(fontSize: 15, color: Color(0xFF243241)),
            ),
          ),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF1E7EF2),
                shape: BoxShape.circle,
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

class _SupportCategory {
  const _SupportCategory({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.topic,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final Color background;
  final String topic;
}

class _SupportMessage {
  const _SupportMessage({
    required this.text,
    required this.fromSupport,
    required this.timeLabel,
  });

  final String text;
  final bool fromSupport;
  final String timeLabel;
}

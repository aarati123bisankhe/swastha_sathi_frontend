import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';

class DoctorChatScreen extends StatefulWidget {
  const DoctorChatScreen({
    super.key,
    required this.doctorName,
    required this.specialization,
    required this.hospitalName,
    required this.avatarBuilder,
    this.user,
  });

  final String doctorName;
  final String specialization;
  final String hospitalName;
  final WidgetBuilder avatarBuilder;
  final AuthUser? user;

  @override
  State<DoctorChatScreen> createState() => _DoctorChatScreenState();
}

class _DoctorChatScreenState extends State<DoctorChatScreen> {
  final TextEditingController _messageController = TextEditingController(
    text: 'I have fever and headache since yesterday.',
  );
  final ScrollController _scrollController = ScrollController();

  late final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: 'Hello 👋\nHow can I help you today?',
      sentByDoctor: true,
      timeLabel: '12:00 PM',
    ),
  ];

  bool _doctorTyping = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String get _headerTitle =>
      widget.doctorName.trim().isEmpty ? 'Dr. Aarav Sharma' : widget.doctorName;

  String get _headerSubtitle {
    final specialization = widget.specialization.trim().isEmpty
        ? 'Specialist'
        : widget.specialization.trim();
    final hospital = widget.hospitalName.trim().isEmpty
        ? 'Bc Hospital, Kathmandu'
        : widget.hospitalName.trim();
    return '$specialization | 7 yrs • $hospital';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDEAF8),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _ChatHeader(
              title: _headerTitle,
              subtitle: _headerSubtitle,
              avatarBuilder: widget.avatarBuilder,
              onBack: () => Navigator.of(context).pop(),
              onCall: () =>
                  _showActionMessage('Starting voice call with $_headerTitle'),
              onVideoCall: () =>
                  _showActionMessage('Starting video call with $_headerTitle'),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFDDEAF8),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(24, 26, 24, 16),
                        itemCount: _messages.length + (_doctorTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (_doctorTyping && index == _messages.length) {
                            return const Padding(
                              padding: EdgeInsets.only(bottom: 12),
                              child: _TypingIndicator(),
                            );
                          }

                          final message = _messages[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _MessageGroup(message: message),
                          );
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 14),
                      child: Text(
                        'Medical advice is for guidance only.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF314D69),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    _ComposerBar(
                      controller: _messageController,
                      onSend: _sendMessage,
                      onAttachment: () =>
                          _showActionMessage('Attachment options coming soon'),
                      onMic: () =>
                          _showActionMessage('Voice input coming soon'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(
        _ChatMessage(
          text: message,
          sentByDoctor: false,
          timeLabel: _formatTime(TimeOfDay.now()),
        ),
      );
      _messageController.clear();
      _doctorTyping = true;
    });

    _scrollToBottom();

    Future<void>.delayed(const Duration(milliseconds: 850), () {
      if (!mounted) return;

      setState(() {
        _doctorTyping = false;
        _messages.add(
          _ChatMessage(
            text:
                'I understand. Since you have fever and headache, please drink enough water, take rest, and monitor your temperature. If the fever continues or becomes high, please visit a nearby hospital.',
            sentByDoctor: true,
            timeLabel: _formatTime(TimeOfDay.now()),
          ),
        );
      });

      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 120,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _showActionMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({
    required this.title,
    required this.subtitle,
    required this.avatarBuilder,
    required this.onBack,
    required this.onCall,
    required this.onVideoCall,
  });

  final String title;
  final String subtitle;
  final WidgetBuilder avatarBuilder;
  final VoidCallback onBack;
  final VoidCallback onCall;
  final VoidCallback onVideoCall;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1276DF), Color(0xFF14C0AE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onBack,
            child: const Padding(
              padding: EdgeInsets.only(right: 6),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black87,
                size: 22,
              ),
            ),
          ),
          _HeaderAvatar(avatarBuilder: avatarBuilder),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onCall,
            child: const Icon(
              Icons.call_rounded,
              color: Colors.white,
              size: 33,
            ),
          ),
          const SizedBox(width: 18),
          GestureDetector(
            onTap: onVideoCall,
            child: const Icon(
              Icons.videocam_rounded,
              color: Colors.white,
              size: 33,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  const _HeaderAvatar({required this.avatarBuilder});

  final WidgetBuilder avatarBuilder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipOval(
          child: SizedBox(width: 62, height: 62, child: avatarBuilder(context)),
        ),
        Positioned(
          right: -1,
          bottom: -1,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF2DCC65),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF51D675), width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageGroup extends StatelessWidget {
  const _MessageGroup({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.sentByDoctor
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Column(
        crossAxisAlignment: message.sentByDoctor
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          if (message.sentByDoctor)
            _DoctorBubble(text: message.text)
          else
            _UserBubble(text: message.text),
          const SizedBox(height: 6),
          Text(
            message.timeLabel,
            style: const TextStyle(fontSize: 12, color: Color(0xFF7B8795)),
          ),
        ],
      ),
    );
  }
}

class _DoctorBubble extends StatelessWidget {
  const _DoctorBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 215),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F2FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF4E8FF5), width: 1.2),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          height: 1.35,
          color: Color(0xFF1D1F24),
        ),
      ),
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 330),
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E7CE8), Color(0xFF11C0A6)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          height: 1.28,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE9F2FF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF4E8FF5), width: 1.1),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(),
            SizedBox(width: 4),
            _Dot(),
            SizedBox(width: 4),
            _Dot(),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: const BoxDecoration(
        color: Color(0xFF6B91C8),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _ComposerBar extends StatelessWidget {
  const _ComposerBar({
    required this.controller,
    required this.onSend,
    required this.onAttachment,
    required this.onMic,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttachment;
  final VoidCallback onMic;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 22),
      padding: const EdgeInsets.fromLTRB(16, 10, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF227BF1), width: 1.4),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onAttachment,
            child: const Icon(
              Icons.attach_file_rounded,
              color: Color(0xFF7B7F86),
              size: 34,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              minLines: 1,
              maxLines: 3,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: const InputDecoration(
                isCollapsed: true,
                hintText: 'Type your message...',
                hintStyle: TextStyle(fontSize: 15, color: Color(0xFF8B8F96)),
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 15, color: Color(0xFF233446)),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onMic,
            child: const Icon(
              Icons.mic_none_rounded,
              color: Color(0xFF7B7F86),
              size: 30,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E7CE8), Color(0xFF11C0A6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({
    required this.text,
    required this.sentByDoctor,
    required this.timeLabel,
  });

  final String text;
  final bool sentByDoctor;
  final String timeLabel;
}

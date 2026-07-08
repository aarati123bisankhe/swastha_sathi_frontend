import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/notification_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:swasthasathi/app/features/support/presentation/pages/doctor_chat_screen.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({super.key, this.user});

  final AuthUser? user;

  static const List<_DoctorInfo> _doctors = [
    _DoctorInfo(
      name: 'Dr. Aryan Sharma',
      specialization: 'General Physician',
      rating: '4.8',
      experience: '15+ Yrs Exp',
      hospitalName: 'Norvic International Hospital, Kathmandu',
      status: 'Available Now',
      doctorPhone: '+977 9811111101',
      hospitalPhone: '01-5970032',
      imageAssetPath: 'assets/images/doctor_aryan_new.png',
    ),
    _DoctorInfo(
      name: 'Dr. Min Bahadur Thapa',
      specialization: 'General Physician',
      rating: '4.5',
      experience: '20+ Yrs Exp',
      hospitalName: 'Kanti Children’s Hospital, Kathmandu',
      status: 'Available Now',
      doctorPhone: '+977 9811111102',
      hospitalPhone: '01-4533395',
      imageAssetPath: 'assets/images/doctor_aarav.png',
    ),
    _DoctorInfo(
      name: 'Dr. Aanaya Sharma',
      specialization: 'General Physician',
      rating: '4.7',
      experience: '15+ Yrs Exp',
      hospitalName: 'Norvic International Hospital, Kathmandu',
      status: 'Available Now',
      doctorPhone: '+977 9811111103',
      hospitalPhone: '01-5970032',
      imageAssetPath: 'assets/images/doctor_aanaya_new.png',
    ),
    _DoctorInfo(
      name: 'Dr. Pradip Rana',
      specialization: 'General Physician',
      rating: '4.8',
      experience: '15+ Yrs Exp',
      hospitalName: 'Norvic International Hospital, Kathmandu',
      status: 'Available Now',
      doctorPhone: '+977 9811111104',
      hospitalPhone: '01-5970032',
      imageAssetPath: 'assets/images/doctor_pradip_new.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEAF5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DoctorHeader(user: user),
              const SizedBox(height: 18),
              ..._doctors.map(
                (doctor) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _DoctorCard(
                    doctor: doctor,
                    avatarBuilder: (context) => _DoctorAssetAvatar(
                      imageAssetPath: doctor.imageAssetPath,
                    ),
                    onCall: () => _showCallSheet(context, doctor),
                    onMessage: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => DoctorChatScreen(
                            user: user,
                            doctorName: doctor.name,
                            specialization: doctor.specialization,
                            hospitalName: doctor.hospitalName,
                            avatarBuilder: (_) => _DoctorAssetAvatar(
                              imageAssetPath: doctor.imageAssetPath,
                              size: 48,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
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

  void _showCallSheet(BuildContext context, _DoctorInfo doctor) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Call ${doctor.name}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D1A66),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Choose whether you want to contact the doctor directly or call the hospital desk.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: Color(0xFF5F6773),
                ),
              ),
              const SizedBox(height: 18),
              _CallOptionTile(
                icon: Icons.phone_in_talk_rounded,
                title: 'Call Doctor',
                subtitle: doctor.doctorPhone,
                accent: const Color(0xFF0B73E8),
                onTap: () {
                  Navigator.of(context).pop();
                  _showInfo(
                    context,
                    'Calling ${doctor.name} at ${doctor.doctorPhone}',
                  );
                },
              ),
              const SizedBox(height: 12),
              _CallOptionTile(
                icon: Icons.local_hospital_rounded,
                title: 'Call Hospital',
                subtitle: doctor.hospitalPhone,
                accent: const Color(0xFF12B886),
                onTap: () {
                  Navigator.of(context).pop();
                  _showInfo(
                    context,
                    'Calling ${doctor.hospitalName} at ${doctor.hospitalPhone}',
                  );
                },
              ),
            ],
          ),
        );
      },
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

class _DoctorHeader extends StatelessWidget {
  const _DoctorHeader({this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Transform.translate(
            offset: const Offset(-6, 0),
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
                'Doctor',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF251E7E),
                ),
              ),
              SizedBox(height: 1),
              Text(
                'Connect with nearby healthcare professionals',
                style: TextStyle(
                  fontSize: 13,
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
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.notifications,
              color: Color(0xFF193767),
              size: 31,
            ),
          ),
        ),
      ],
    );
  }
}

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({
    required this.doctor,
    required this.avatarBuilder,
    required this.onCall,
    required this.onMessage,
  });

  final _DoctorInfo doctor;
  final WidgetBuilder avatarBuilder;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              avatarBuilder(context),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            doctor.name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          doctor.experience,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF6B707A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      doctor.specialization,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666C76),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF535B66),
                            ),
                            children: [
                              const TextSpan(text: 'Rating: '),
                              TextSpan(
                                text: doctor.rating,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF444B55),
                                ),
                              ),
                              const TextSpan(
                                text: ' ★',
                                style: TextStyle(color: Color(0xFFFFC107)),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F8EB),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0DBB53),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                doctor.status,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF0AA54C),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.location_on,
                  size: 18,
                  color: Color(0xFF1C355E),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Hospital: ${doctor.hospitalName}',
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.25,
                    color: Color(0xFF5D6470),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCall,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0B73E8),
                    side: const BorderSide(
                      color: Color(0xFF0B73E8),
                      width: 1.4,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  icon: const Icon(Icons.call_rounded, size: 18),
                  label: const Text(
                    'Call',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onMessage,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF12B886),
                    side: const BorderSide(
                      color: Color(0xFF12B886),
                      width: 1.4,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  icon: const Icon(Icons.message_rounded, size: 18),
                  label: const Text(
                    'Message',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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

class _DoctorAssetAvatar extends StatelessWidget {
  const _DoctorAssetAvatar({required this.imageAssetPath, this.size = 76});

  final String imageAssetPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(imageAssetPath, fit: BoxFit.cover),
      ),
    );
  }
}

class _CallOptionTile extends StatelessWidget {
  const _CallOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accent.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accent, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF28313B),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5F6773),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: accent, size: 24),
          ],
        ),
      ),
    );
  }
}

class _DoctorInfo {
  const _DoctorInfo({
    required this.name,
    required this.specialization,
    required this.rating,
    required this.experience,
    required this.hospitalName,
    required this.status,
    required this.doctorPhone,
    required this.hospitalPhone,
    required this.imageAssetPath,
  });

  final String name;
  final String specialization;
  final String rating;
  final String experience;
  final String hospitalName;
  final String status;
  final String doctorPhone;
  final String hospitalPhone;
  final String imageAssetPath;
}

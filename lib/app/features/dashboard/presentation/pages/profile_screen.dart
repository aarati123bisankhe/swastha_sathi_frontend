import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/personal_information_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.user});

  final AuthUser? user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const String _storageKey = 'personal_information_data';

  late PersonalInformationData _personalInfo;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _personalInfo = PersonalInformationData(
      fullName: widget.user?.fullName.trim().isNotEmpty == true
          ? widget.user!.fullName.trim()
          : 'Anisha Sharma',
      birthDate: '12 May 2002',
      gender: 'Female',
      bloodGroup: widget.user?.bloodGroup?.trim().isNotEmpty == true
          ? widget.user!.bloodGroup!.trim()
          : 'O+ Positive',
      phoneNumber: widget.user?.phoneNumber.trim().isNotEmpty == true
          ? widget.user!.phoneNumber.trim()
          : '9862573376',
      email: widget.user?.email.trim().isNotEmpty == true
          ? widget.user!.email.trim()
          : 'anisha@gmail.com',
      address: widget.user?.district.trim().isNotEmpty == true
          ? widget.user!.district.trim()
          : 'Kathmandu, Nepal',
      profileImageUrl: widget.user?.profileUrl,
    );
    _loadPersonalInformation();
  }

  Future<void> _openPersonalInformation() async {
    final updatedInfo = await Navigator.of(context)
        .push<PersonalInformationData>(
          MaterialPageRoute<PersonalInformationData>(
            builder: (context) => PersonalInformationScreen(
              initialData: _personalInfo,
              user: widget.user,
            ),
          ),
        );

    if (updatedInfo == null || !mounted) return;

    setState(() {
      _personalInfo = updatedInfo;
    });

    await _persistPersonalInformation(updatedInfo);

    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Personal information updated successfully.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _loadPersonalInformation() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    if (!mounted) return;

    setState(() {
      if (raw != null && raw.isNotEmpty) {
        _personalInfo = PersonalInformationData.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      }
      _loading = false;
    });
  }

  Future<void> _persistPersonalInformation(PersonalInformationData data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(data.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEAF5),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 120),
                child: Column(
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF24229A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ProfilePhotoView(
                      profileImagePath: _personalInfo.profileImagePath,
                      profileImageUrl: _personalInfo.profileImageUrl,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _personalInfo.fullName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2E3338),
                      ),
                    ),
                    const SizedBox(height: 1),
                    const Text(
                      'HealthCare Companion users',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Color(0xFF434A51)),
                    ),
                    const SizedBox(height: 9),
                    _ProfileStatsCard(
                      bloodGroup: _personalInfo.bloodGroup,
                      district: _personalInfo.address,
                      phoneNumber: _personalInfo.phoneNumber,
                    ),
                    const SizedBox(height: 20),
                    _ProfileMenuCard(
                      icon: Icons.person_rounded,
                      iconBackground: const Color(0xFF1E88F7),
                      title: 'Personal Information',
                      onTap: _openPersonalInformation,
                    ),
                    const SizedBox(height: 14),
                    const _ProfileMenuCard(
                      icon: Icons.medical_services_rounded,
                      iconBackground: Color(0xFF16BF70),
                      title: 'Health Record',
                    ),
                    const SizedBox(height: 14),
                    const _ProfileMenuCard(
                      icon: Icons.language_rounded,
                      iconBackground: Color(0xFFFF8A00),
                      title: 'Language Setting',
                    ),
                    const SizedBox(height: 14),
                    const _ProfileToggleCard(),
                    const SizedBox(height: 16),
                    const _LogoutButton(),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: DashboardBottomNav(
        activeTab: DashboardNavTab.profile,
        user: widget.user,
      ),
    );
  }
}

class _ProfilePhotoView extends StatelessWidget {
  const _ProfilePhotoView({this.profileImagePath, this.profileImageUrl});

  final String? profileImagePath;
  final String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object>? imageProvider;
    if (profileImagePath != null && profileImagePath!.isNotEmpty) {
      imageProvider = FileImage(File(profileImagePath!));
    } else if (profileImageUrl != null && profileImageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(profileImageUrl!);
    }

    return Container(
      width: 134,
      height: 134,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF9EC0F2), Color(0xFF87A6D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipOval(
        child: imageProvider != null
            ? Image(image: imageProvider, fit: BoxFit.cover)
            : const Image(
                image: AssetImage('assets/images/family_contact_avatar.png'),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class _ProfileStatsCard extends StatelessWidget {
  const _ProfileStatsCard({
    required this.bloodGroup,
    required this.district,
    required this.phoneNumber,
  });

  final String bloodGroup;
  final String district;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFB3DCF0), Color(0xFFD7DFE4)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
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
        children: [
          Row(
            children: [
              Expanded(
                child: _ProfileInfoItem(
                  icon: Icons.bloodtype,
                  iconBackground: const Color(0xFFE8B2B2),
                  iconColor: const Color(0xFFE11B1B),
                  title: 'Blood Group',
                  subtitle: bloodGroup,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: _ProfileInfoItem(
                  icon: Icons.check_box_rounded,
                  iconBackground: Color(0xFFAEE28E),
                  iconColor: Color(0xFF10B91D),
                  title: 'Health Status',
                  subtitle: 'Excellent',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _ProfileInfoItem(
                  icon: Icons.location_on_rounded,
                  iconBackground: const Color(0xFFC9B8E9),
                  iconColor: const Color(0xFF1F3F6B),
                  title: 'Location',
                  subtitle: district,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ProfileInfoItem(
                  icon: Icons.call_rounded,
                  iconBackground: const Color(0xFFC9DDB7),
                  iconColor: const Color(0xFF4C5650),
                  title: 'Emergency Contact',
                  subtitle: phoneNumber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoItem extends StatelessWidget {
  const _ProfileInfoItem({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF4A5056),
                  ),
                ),
                const SizedBox(height: 0.5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
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

class _ProfileMenuCard extends StatelessWidget {
  const _ProfileMenuCard({
    required this.icon,
    required this.iconBackground,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
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
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 19),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF7C7F86),
                size: 34,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileToggleCard extends StatelessWidget {
  const _ProfileToggleCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
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
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            child: const Text('🌙', style: TextStyle(fontSize: 19)),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Dark Mode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            width: 68,
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF6D4FB3),
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.centerRight,
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xFF2287EE),
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Logout',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

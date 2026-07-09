import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swasthasathi/app/core/localization/app_text.dart';
import 'package:swasthasathi/app/core/services/profile_sync_service.dart';
import 'package:swasthasathi/app/core/state/app_theme_controller.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/language_setting_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/personal_information_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/pages/record_screen.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:swasthasathi/app/theme/app.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, this.user});

  final AuthUser? user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileSyncService _profileSyncService = ProfileSyncService.instance;

  PersonalInformationData? _personalInfo;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _personalInfo = _buildFallbackPersonalInfo();
    _loadPersonalInformation();
  }

  Future<void> _openPersonalInformation() async {
    final updatedInfo = await Navigator.of(context)
        .push<PersonalInformationData>(
          MaterialPageRoute<PersonalInformationData>(
            builder: (context) => PersonalInformationScreen(
              initialData: _personalInfo ?? _buildFallbackPersonalInfo(),
              user: widget.user,
            ),
          ),
        );

    if (updatedInfo == null || !mounted) return;

    setState(() {
      _saving = true;
    });

    try {
      final savedInfo = await _profileSyncService.savePersonalInformation(
        data: updatedInfo,
        user: widget.user,
      );

      if (!mounted) return;

      setState(() {
        _personalInfo = savedInfo;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              context.tx(
                'Personal information updated successfully.',
                'व्यक्तिगत जानकारी सफलतापूर्वक अद्यावधिक भयो।',
              ),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _openLanguageSetting() async {
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (context) => LanguageSettingScreen(user: widget.user),
      ),
    );

    if (updated != true || !mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(context.languageUpdatedSuccess),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _openHealthRecord() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => RecordScreen(user: widget.user),
      ),
    );
  }

  Future<void> _loadPersonalInformation() async {
    final personalInfo = await _profileSyncService.loadPersonalInformation(
      widget.user,
    );

    if (!mounted) return;

    setState(() {
      _personalInfo = personalInfo;
      _loading = false;
    });
  }

  PersonalInformationData _buildFallbackPersonalInfo() {
    return PersonalInformationData(
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
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appThemeColors;
    final personalInfo = _personalInfo ?? _buildFallbackPersonalInfo();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: _loading || _saving
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 120),
                child: Column(
                  children: [
                    Text(
                      context.tx('Profile', 'प्रोफाइल'),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF24229A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _ProfilePhotoView(
                      profileImagePath: personalInfo.profileImagePath,
                      profileImageUrl: personalInfo.profileImageUrl,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      personalInfo.fullName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: colors.primaryText,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      context.tx(
                        'HealthCare Companion users',
                        'स्वास्थ्य साथी प्रयोगकर्ता',
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 9),
                    _ProfileStatsCard(
                      bloodGroup: personalInfo.bloodGroup,
                      district: personalInfo.address,
                      phoneNumber: personalInfo.phoneNumber,
                    ),
                    const SizedBox(height: 20),
                    _ProfileMenuCard(
                      icon: Icons.person_rounded,
                      iconBackground: const Color(0xFF1E88F7),
                      title: context.tx(
                        'Personal Information',
                        'व्यक्तिगत जानकारी',
                      ),
                      onTap: _openPersonalInformation,
                    ),
                    const SizedBox(height: 14),
                    _ProfileMenuCard(
                      icon: Icons.medical_services_rounded,
                      iconBackground: const Color(0xFF16BF70),
                      title: context.tx('Health Record', 'स्वास्थ्य रेकर्ड'),
                      onTap: _openHealthRecord,
                    ),
                    const SizedBox(height: 14),
                    _ProfileMenuCard(
                      icon: Icons.language_rounded,
                      iconBackground: const Color(0xFFFF8A00),
                      title: context.tx('Language Setting', 'भाषा सेटिङ'),
                      onTap: _openLanguageSetting,
                    ),
                    const SizedBox(height: 14),
                    Consumer(
                      builder: (context, ref, child) {
                        final isDarkMode =
                            ref.watch(appThemeProvider) == ThemeMode.dark;
                        return _ProfileToggleCard(
                          isDarkMode: isDarkMode,
                          onChanged: (value) => ref
                              .read(appThemeProvider.notifier)
                              .setDarkMode(value),
                        );
                      },
                    ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: isDark
              ? const [Color(0xFF213449), Color(0xFF172534)]
              : const [Color(0xFFB3DCF0), Color(0xFFD7DFE4)],
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
                  title: context.tx('Blood Group', 'रक्त समूह'),
                  subtitle: bloodGroup,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ProfileInfoItem(
                  icon: Icons.check_box_rounded,
                  iconBackground: const Color(0xFFAEE28E),
                  iconColor: const Color(0xFF10B91D),
                  title: context.tx('Health Status', 'स्वास्थ्य स्थिति'),
                  subtitle: context.tx('Excellent', 'उत्कृष्ट'),
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
                  title: context.tx('Location', 'स्थान'),
                  subtitle: district,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ProfileInfoItem(
                  icon: Icons.call_rounded,
                  iconBackground: const Color(0xFFC9DDB7),
                  iconColor: const Color(0xFF4C5650),
                  title: context.tx('Emergency Contact', 'आपतकालीन सम्पर्क'),
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
    final colors = context.appThemeColors;

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
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: colors.secondaryText,
                  ),
                ),
                const SizedBox(height: 0.5),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: colors.primaryText,
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
    final colors = context.appThemeColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
          decoration: BoxDecoration(
            color: colors.elevatedSurface.withValues(alpha: 0.95),
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colors.primaryText,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.secondaryText,
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
  const _ProfileToggleCard({required this.isDarkMode, required this.onChanged});

  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.appThemeColors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
      decoration: BoxDecoration(
        color: colors.elevatedSurface.withValues(alpha: 0.95),
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
          Expanded(
            child: Text(
              context.tx('Dark Mode', 'डार्क मोड'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.primaryText,
              ),
            ),
          ),
          Switch(value: isDarkMode, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    final colors = context.appThemeColors;

    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.center,
      child: Text(
        context.tx('Logout', 'लगआउट'),
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: colors.elevatedSurface,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swasthasathi/app/core/state/app_language_controller.dart';
import 'package:swasthasathi/app/features/auth/domain/entities/auth_user.dart';
import 'package:swasthasathi/app/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';

class LanguageSettingScreen extends ConsumerStatefulWidget {
  const LanguageSettingScreen({super.key, this.user});

  final AuthUser? user;

  @override
  ConsumerState<LanguageSettingScreen> createState() =>
      _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends ConsumerState<LanguageSettingScreen> {
  late AppLanguage _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = ref.read(appLanguageProvider);
  }

  Future<void> _saveChanges() async {
    await ref
        .read(appLanguageProvider.notifier)
        .saveLanguage(_selectedLanguage);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: const Offset(-24, -4),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF7D8491),
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(-24, -2),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Language Setting',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF20196E),
                            ),
                          ),
                          SizedBox(height: 0),
                          Text(
                            'Choose your preferred language',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF414B55),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _LanguageBannerCard(),
              const SizedBox(height: 18),
              _LanguageOptionCard(
                flag: '🇬🇧',
                title: 'English',
                selected: _selectedLanguage == AppLanguage.english,
                onTap: () {
                  setState(() {
                    _selectedLanguage = AppLanguage.english;
                  });
                },
              ),
              const SizedBox(height: 16),
              _LanguageOptionCard(
                flag: '🇳🇵',
                title: 'Nepali',
                subtitle: '(नेपाली)',
                selected: _selectedLanguage == AppLanguage.nepali,
                onTap: () {
                  setState(() {
                    _selectedLanguage = AppLanguage.nepali;
                  });
                },
              ),
              const SizedBox(height: 124),
              const _LanguageInfoCard(),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _saveChanges,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0B73E8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.save_outlined, size: 22),
                  label: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
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

class _LanguageBannerCard extends StatelessWidget {
  const _LanguageBannerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D6EC4), Color(0xFF19A66C)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Select your preferred language\nfor a better healthcare\nexperience.',
              style: TextStyle(
                fontSize: 16,
                height: 1.28,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(10, -2),
            child: const Text('🌍', style: TextStyle(fontSize: 96)),
          ),
        ],
      ),
    );
  }
}

class _LanguageOptionCard extends StatelessWidget {
  const _LanguageOptionCard({
    required this.flag,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
  });

  final String flag;
  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEAF7EB) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? const Color(0xFF5AAF68)
                  : const Color(0xFFC2C2C2),
              width: selected ? 2 : 1.8,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6F9),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD4DCE6)),
                ),
                child: Text(flag, style: const TextStyle(fontSize: 40)),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: subtitle == null
                    ? Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF343434),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF343434),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Color(0xFF343434),
                            ),
                          ),
                        ],
                      ),
              ),
              Icon(
                selected
                    ? Icons.check_circle_outline_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected
                    ? const Color(0xFF31B257)
                    : const Color(0xFF919191),
                size: 36,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageInfoCard extends StatelessWidget {
  const _LanguageInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFFB9DDF8), Color(0xFFA8D0F2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF0F6DC1),
            child: Icon(Icons.info, color: Colors.white, size: 22),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'You can switch between Nepali and English at any time.',
              style: TextStyle(
                fontSize: 16,
                height: 1.35,
                color: Color(0xFF1D2731),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

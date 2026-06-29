import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/auth/presentation/pages/login_screen.dart';
import 'package:swasthasathi/app/features/onboarding/data/datasources/local_onboarding_data_source.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.pageIndex = 0});

  final int pageIndex;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _dataSource = LocalOnboardingDataSource();

  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final content = _dataSource.getPageContent(widget.pageIndex);

    return Scaffold(
      body: AnimatedOpacity(
        opacity: _showContent ? 1 : 0,
        duration: const Duration(milliseconds: 900),
        curve: Curves.easeOut,
        child: AnimatedScale(
          scale: _showContent ? 1 : 0.98,
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutBack,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(content.imageAssetPath, fit: BoxFit.cover),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    children: [
                      const Spacer(),
                      _OnboardingProgressIndicator(
                        currentIndex: content.pageIndex,
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(height: 10),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 530),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF0E5DA8,
                                  ).withValues(alpha: 0.1),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: FilledButton(
                              onPressed: () {
                                if (content.pageIndex == 0) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (context) =>
                                          const OnboardingScreen(pageIndex: 1),
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                }
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF1674CB),
                                minimumSize: const Size.fromHeight(64),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                content.buttonLabel,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingProgressIndicator extends StatelessWidget {
  const _OnboardingProgressIndicator({required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _IndicatorPill(isActive: currentIndex == 0),
        const SizedBox(width: 6.5),
        _IndicatorPill(isActive: currentIndex == 1),
      ],
    );
  }
}

class _IndicatorPill extends StatelessWidget {
  const _IndicatorPill({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 14.5,
      height: 6.5,
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white
            : const Color(0xFFB0DEE6).withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

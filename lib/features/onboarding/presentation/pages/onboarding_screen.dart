import 'dart:async';

import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _showLogo = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        setState(() {
          _showLogo = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AnimatedOpacity(
            opacity: _showLogo ? 1 : 0,
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOut,
            child: AnimatedScale(
              scale: _showLogo ? 1 : 0.88,
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutBack,
              child: const _BrandMark(),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E63B6).withValues(alpha: 0.12),
              blurRadius: 28,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Image.asset(
          'assets/images/swasthasathi.png',
          width: 430,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

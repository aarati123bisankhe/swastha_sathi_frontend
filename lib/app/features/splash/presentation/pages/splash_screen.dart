import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swasthasathi/app/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:swasthasathi/app/features/splash/data/datasources/local_splash_data_source.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _dataSource = LocalSplashDataSource();

  bool _showLogo = false;
  Timer? _showTimer;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    final config = _dataSource.getConfig();

    _showTimer = Timer(Duration(milliseconds: config.showDelayMs), () {
      if (!mounted) return;
      setState(() {
        _showLogo = true;
      });
    });

    _navigationTimer = Timer(
      Duration(milliseconds: config.showDelayMs + config.holdDurationMs),
      () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          PageRouteBuilder<void>(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const OnboardingScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _showTimer?.cancel();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final config = _dataSource.getConfig();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: AnimatedOpacity(
            opacity: _showLogo ? 1 : 0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOut,
            child: AnimatedScale(
              scale: _showLogo ? 1 : 0.88,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutBack,
              child: Image.asset(
                config.logoAssetPath,
                width: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

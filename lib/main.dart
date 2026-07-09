import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swasthasathi/app/core/state/app_language_controller.dart';
import 'package:swasthasathi/app/core/state/app_theme_controller.dart';
import 'package:swasthasathi/app/theme/app.dart';
import 'package:swasthasathi/app/features/splash/presentation/pages/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLanguage = ref.watch(appLanguageProvider);
    final themeMode = ref.watch(appThemeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swastha Sathi',
      theme: buildAppTheme(brightness: Brightness.light),
      darkTheme: buildAppTheme(brightness: Brightness.dark),
      themeMode: themeMode,
      locale: appLanguage.locale,
      supportedLocales: const [Locale('en'), Locale('ne')],
      home: const SplashScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeController extends StateNotifier<ThemeMode> {
  AppThemeController() : super(ThemeMode.light) {
    _load();
  }

  static const _storageKey = 'app_theme_mode';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_storageKey);
    state = savedMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setDarkMode(bool enabled) async {
    state = enabled ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, enabled ? 'dark' : 'light');
  }
}

final appThemeProvider = StateNotifierProvider<AppThemeController, ThemeMode>(
  (ref) => AppThemeController(),
);

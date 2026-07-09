import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { english, nepali }

extension AppLanguageX on AppLanguage {
  String get code => this == AppLanguage.nepali ? 'ne' : 'en';

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String? code) {
    return code == 'ne' ? AppLanguage.nepali : AppLanguage.english;
  }
}

class AppLanguageController extends StateNotifier<AppLanguage> {
  AppLanguageController() : super(AppLanguage.english) {
    _load();
  }

  static const _storageKey = 'app_language_code';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = AppLanguageX.fromCode(prefs.getString(_storageKey));
  }

  Future<void> saveLanguage(AppLanguage language) async {
    state = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, language.code);
  }
}

final appLanguageProvider =
    StateNotifierProvider<AppLanguageController, AppLanguage>(
      (ref) => AppLanguageController(),
    );

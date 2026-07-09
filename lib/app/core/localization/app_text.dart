import 'package:flutter/material.dart';

extension AppTextX on BuildContext {
  bool get isNepali => Localizations.localeOf(this).languageCode == 'ne';

  String tx(String english, String nepali) => isNepali ? nepali : english;

  String greeting(String name) =>
      isNepali ? 'नमस्ते, $name 👋' : 'Namaste, $name 👋';

  String get languageUpdatedSuccess =>
      tx('Language updated successfully.', 'भाषा सफलतापूर्वक परिवर्तन भयो।');
}

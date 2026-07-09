import 'package:flutter/material.dart';

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.screenBackground,
    required this.surface,
    required this.elevatedSurface,
    required this.primaryText,
    required this.secondaryText,
    required this.bottomNavBackground,
    required this.bottomNavInactive,
  });

  final Color screenBackground;
  final Color surface;
  final Color elevatedSurface;
  final Color primaryText;
  final Color secondaryText;
  final Color bottomNavBackground;
  final Color bottomNavInactive;

  @override
  AppThemeColors copyWith({
    Color? screenBackground,
    Color? surface,
    Color? elevatedSurface,
    Color? primaryText,
    Color? secondaryText,
    Color? bottomNavBackground,
    Color? bottomNavInactive,
  }) {
    return AppThemeColors(
      screenBackground: screenBackground ?? this.screenBackground,
      surface: surface ?? this.surface,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
      bottomNavBackground: bottomNavBackground ?? this.bottomNavBackground,
      bottomNavInactive: bottomNavInactive ?? this.bottomNavInactive,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }

    return AppThemeColors(
      screenBackground: Color.lerp(screenBackground, other.screenBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      elevatedSurface: Color.lerp(elevatedSurface, other.elevatedSurface, t)!,
      primaryText: Color.lerp(primaryText, other.primaryText, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      bottomNavBackground:
          Color.lerp(bottomNavBackground, other.bottomNavBackground, t)!,
      bottomNavInactive:
          Color.lerp(bottomNavInactive, other.bottomNavInactive, t)!,
    );
  }
}

extension AppThemeX on BuildContext {
  AppThemeColors get appThemeColors =>
      Theme.of(this).extension<AppThemeColors>()!;
}

ThemeData buildAppTheme({required Brightness brightness}) {
  final isDark = brightness == Brightness.dark;
  final backgroundColor = isDark
      ? const Color(0xFF0F1723)
      : const Color(0xFFD9EAF6);
  final surfaceColor = isDark
      ? const Color(0xFF172332)
      : const Color(0xFFF8FBFF);
  final elevatedSurfaceColor = isDark
      ? const Color(0xFF223246)
      : Colors.white;
  final primaryTextColor = isDark
      ? const Color(0xFFF2F7FF)
      : const Color(0xFF15396B);
  final secondaryTextColor = isDark
      ? const Color(0xFFB0C0D4)
      : const Color(0xFF4E657A);
  final colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF1E63B6),
    brightness: brightness,
    surface: surfaceColor,
  );

  return ThemeData(
    brightness: brightness,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: colorScheme,
    useMaterial3: true,
    extensions: <ThemeExtension<dynamic>>[
      AppThemeColors(
        screenBackground: backgroundColor,
        surface: surfaceColor,
        elevatedSurface: elevatedSurfaceColor,
        primaryText: primaryTextColor,
        secondaryText: secondaryTextColor,
        bottomNavBackground: elevatedSurfaceColor,
        bottomNavInactive: isDark
            ? const Color(0xFF9DB0C6)
            : const Color(0xFF183B66),
      ),
    ],
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: primaryTextColor,
      elevation: 0,
      centerTitle: true,
    ),
    cardColor: elevatedSurfaceColor,
    canvasColor: elevatedSurfaceColor,
    dividerColor: isDark ? const Color(0xFF2F4158) : const Color(0xFFD8E4F0),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: isDark
          ? const Color(0xFF223246)
          : const Color(0xFF1E63B6),
      contentTextStyle: const TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return isDark ? const Color(0xFFCDD9E8) : Colors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF0B73E8);
        }
        return isDark ? const Color(0xFF42566D) : const Color(0xFFD0DAE5);
      }),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: elevatedSurfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF40556E) : const Color(0xFFC8D7E6),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF40556E) : const Color(0xFFC8D7E6),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color(0xFF0B73E8), width: 1.5),
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: isDark ? const Color(0xFF8AC5FF) : const Color(0xFF1E63B6),
        letterSpacing: 0.2,
      ),
      bodyMedium: TextStyle(fontSize: 16, color: secondaryTextColor),
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: primaryTextColor,
      ),
    ),
  );
}

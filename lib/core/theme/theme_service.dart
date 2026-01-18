import 'package:flutter/material.dart';

class ThemeService extends ValueNotifier<ThemeMode> {
  // Singleton pattern
  static final ThemeService _instance = ThemeService._internal();

  factory ThemeService() {
    return _instance;
  }

  ThemeService._internal() : super(ThemeMode.system);

  /// Change the theme mode
  void setThemeMode(ThemeMode mode) {
    value = mode;
  }

  /// Toggle between light and dark (ignoring system for simplicity if needed)
  void toggleTheme() {
    if (value == ThemeMode.dark) {
      value = ThemeMode.light;
    } else {
      value = ThemeMode.dark;
    }
  }
}

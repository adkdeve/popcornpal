import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier with WidgetsBindingObserver {
  ThemeMode _themeMode;

  ThemeNotifier() : _themeMode = ThemeMode.system {
    WidgetsBinding.instance.addObserver(this);
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkTheme =>
      _themeMode == ThemeMode.dark ||
          (_themeMode == ThemeMode.system && WidgetsBinding.instance.window.platformBrightness == Brightness.dark);

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  @override
  void didChangePlatformBrightness() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

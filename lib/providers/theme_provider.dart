import 'package:flutter/material.dart';

/// ThemeProvider — manages dark/light mode toggle.
/// Used as an InheritedNotifier at the root of the widget tree.
class ThemeProvider extends ChangeNotifier {
  bool _isDark = true;

  bool get isDark => _isDark;

  ThemeData get themeData => _isDark ? _darkTheme : _lightTheme;

  void toggle() {
    _isDark = !_isDark;
    notifyListeners();
  }

  // ── Dark Theme ─────────────────────────────────────────────────
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF080C10),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF027DFD),
      secondary: Color(0xFF54C5F8),
      surface: Color(0xFF0E1318),
    ),
    fontFamily: 'Syne',
  );

  // ── Light Theme ────────────────────────────────────────────────
  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF4F7FB),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF027DFD),
      secondary: Color(0xFF54C5F8),
      surface: Color(0xFFFFFFFF),
    ),
    fontFamily: 'Syne',
  );
}

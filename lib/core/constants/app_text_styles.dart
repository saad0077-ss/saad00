import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String syneFont = 'Syne';
  static const String monoFont = 'JetBrainsMono';

  static TextStyle heroTitle({bool isDark = true}) => TextStyle(
        fontFamily: syneFont,
        fontSize: 64,
        fontWeight: FontWeight.w800,
        height: 0.95,
        letterSpacing: -3,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );

  static TextStyle heroSubtitle({bool isDark = true}) => TextStyle(
        fontFamily: syneFont,
        fontSize: 22,
        fontWeight: FontWeight.w400,
        color: isDark ? AppColors.darkText2 : AppColors.lightText2,
        letterSpacing: -1,
      );

  static TextStyle sectionLabel({bool isDark = true}) => const TextStyle(
        fontFamily: monoFont,
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.flCyan,
        letterSpacing: 2,
      );

  static TextStyle sectionH2({bool isDark = true}) => TextStyle(
        fontFamily: syneFont,
        fontSize: 48,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -2,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );

  static TextStyle bodyText({bool isDark = true}) => TextStyle(
        fontFamily: syneFont,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.85,
        color: isDark ? AppColors.darkText2 : AppColors.lightText2,
      );

  static TextStyle monoSmall({bool isDark = true}) => TextStyle(
        fontFamily: monoFont,
        fontSize: 10,
        letterSpacing: 1,
        color: isDark ? AppColors.darkText2 : AppColors.lightText2,
      );

  static TextStyle statNumber({bool isDark = true}) => TextStyle(
        fontFamily: syneFont,
        fontSize: 48,
        fontWeight: FontWeight.w800,
        letterSpacing: -2,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      );
}

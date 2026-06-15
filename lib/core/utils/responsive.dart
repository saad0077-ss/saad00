import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 768;
  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width < 1024;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1024;

  /// Linearly scales a value between [minSize] and [maxSize] based on viewport width.
  /// Mimics CSS clamp(minSize, vw, maxSize) where it smoothly interpolates 
  /// from mobile width (375) to desktop width (1440).
  static double scale(BuildContext context, double minSize, double maxSize) {
    final vw = MediaQuery.of(context).size.width;
    if (vw <= 375) return minSize;
    if (vw >= 1440) return maxSize;
    
    final factor = (vw - 375) / (1440 - 375);
    return minSize + (maxSize - minSize) * factor;
  }
}

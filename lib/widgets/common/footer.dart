import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/data/portfolio_data.dart';


/// Footer with live clock, name, and location.
class PortfolioFooter extends StatefulWidget {
  final bool isDark;
  const PortfolioFooter({super.key, required this.isDark});

  @override
  State<PortfolioFooter> createState() => _PortfolioFooterState();
}

class _PortfolioFooterState extends State<PortfolioFooter> {
  late Timer _timer;
  String _time24 = '';
  String _time12 = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _time24 =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
      // 12-hour format with AM/PM
      final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
      final ampm = now.hour >= 12 ? 'PM' : 'AM';
      _time12 =
          '${h.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')} $ampm';
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subColor = widget.isDark ? AppColors.darkText2 : AppColors.lightText2;
    final border = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    final copyrightText = Text(
      '© 2026 ${PortfolioData.name} · Flutter Developer',
      style: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: isMobile ? 12 : 11,
        fontWeight: FontWeight.w400,
        color: subColor,
        letterSpacing: 0.5,
      ),
      textAlign: TextAlign.center,
    );

    final timeText = Text(
      isMobile ? _time12 : _time24,
      style: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: isMobile ? 12 : 11,
        fontWeight: FontWeight.w400,
        color: AppColors.flCyan,
        letterSpacing: 1,
      ),
      textAlign: TextAlign.center,
    );

    final locationText = Text(
      PortfolioData.location,
      style: TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: isMobile ? 12 : 11,
        fontWeight: FontWeight.w400,
        color: subColor,
        letterSpacing: 0.5,
      ),
      textAlign: TextAlign.center,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 56,
        vertical: isMobile ? 20 : 28,
      ),
      margin: EdgeInsets.only(top: isMobile ? 40 : 80),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: border)),
      ),
      child: isMobile
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                copyrightText,
                const SizedBox(height: 8),
                timeText,
                const SizedBox(height: 8),
                locationText,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                copyrightText,
                timeText,
                locationText,
              ],
            ),
    );
  }
}

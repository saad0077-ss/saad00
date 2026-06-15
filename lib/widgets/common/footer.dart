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
  String _time = '';

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());
  }

  void _updateTime() {
    final now = DateTime.now();
    setState(() {
      _time =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 28),
      margin: const EdgeInsets.only(top: 80),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '© 2026 ${PortfolioData.name} · Flutter Developer',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: subColor,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            _time,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppColors.flCyan,
              letterSpacing: 1,
            ),
          ),
          Text(
            PortfolioData.location,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: subColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

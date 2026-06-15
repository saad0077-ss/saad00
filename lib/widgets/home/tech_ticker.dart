import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/data/portfolio_data.dart';


/// Infinite horizontal ticker / marquee showing tech stack items.
class TechTicker extends StatefulWidget {
  final bool isDark;
  const TechTicker({super.key, required this.isDark});

  @override
  State<TechTicker> createState() => _TechTickerState();
}

class _TechTickerState extends State<TechTicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  // Double the list for seamless loop
  late final List<String> _items;

  @override
  void initState() {
    super.initState();
    _items = [...PortfolioData.tickerItems, ...PortfolioData.tickerItems];
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _anim = _ctrl;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: border),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) {
          return FractionalTranslation(
            translation: Offset(-_anim.value * 0.5, 0),
            child: OverflowBox(
              maxWidth: double.infinity,
              alignment: Alignment.centerLeft,
              child: child,
            ),
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _items.map((item) => _TickerItem(label: item, isDark: widget.isDark)).toList(),
        ),
      ),
    );
  }
}

class _TickerItem extends StatelessWidget {
  final String label;
  final bool isDark;

  const _TickerItem({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: AppColors.flCyan,
            shape: BoxShape.circle,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 11,
            fontWeight: FontWeight.w400,
            letterSpacing: 1,
            color: isDark ? AppColors.darkText2 : AppColors.lightText2,
          ),
        ),
      ],
    );
  }
}

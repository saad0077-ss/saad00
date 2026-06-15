import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/data/portfolio_data.dart';


/// Animated stats row shown beneath the hero.
class StatsRow extends StatelessWidget {
  final bool isDark;
  const StatsRow({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkBg2 : AppColors.lightBg2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor = isDark ? AppColors.darkText2 : AppColors.lightText2;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          top: BorderSide(color: border),
          bottom: BorderSide(color: border),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          if (isWide) {
            return Row(
              children: List.generate(PortfolioData.stats.length, (index) {
                final stat = PortfolioData.stats[index];
                return Expanded(
                  child: _StatCell(
                    value: stat['value']!,
                    unit: stat['unit'] ?? '',
                    label: stat['label']!,
                    textColor: textColor,
                    subColor: subColor,
                    border: border,
                    isDark: isDark,
                    isLast: index == PortfolioData.stats.length - 1,
                  ),
                );
              }),
            );
          } else {
            return Column(
              children: List.generate(PortfolioData.stats.length, (index) {
                final stat = PortfolioData.stats[index];
                return _StatCell(
                  value: stat['value']!,
                  unit: stat['unit'] ?? '',
                  label: stat['label']!,
                  textColor: textColor,
                  subColor: subColor,
                  border: border,
                  isDark: isDark,
                  isLast: index == PortfolioData.stats.length - 1,
                  isMobile: true,
                );
              }),
            );
          }
        },
      ),
    );
  }
}

class _StatCell extends StatefulWidget {
  final String value;
  final String unit;
  final String label;
  final Color textColor;
  final Color subColor;
  final Color border;
  final bool isDark;
  final bool isLast;
  final bool isMobile;

  const _StatCell({
    required this.value,
    this.unit = '',
    required this.label,
    required this.textColor,
    required this.subColor,
    required this.border,
    required this.isDark,
    this.isLast = false,
    this.isMobile = false,
  });

  @override
  State<_StatCell> createState() => _StatCellState();
}

class _StatCellState extends State<_StatCell> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: _hovered
              ? (widget.isDark ? Colors.white.withOpacity(0.02) : AppColors.flBlue.withOpacity(0.04))
              : Colors.transparent,
          border: widget.isMobile
              ? (!widget.isLast ? Border(bottom: BorderSide(color: widget.border)) : null)
              : (!widget.isLast ? Border(right: BorderSide(color: widget.border)) : null),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [AppColors.flBlue, AppColors.flCyan],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          widget.value,
                          style: const TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 56,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -3,
                            height: 1,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (widget.unit.isNotEmpty)
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [AppColors.flBlue, AppColors.flCyan],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            widget.unit,
                            style: const TextStyle(
                              fontFamily: 'Syne',
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: widget.subColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            // Animated bottom line
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        width: _hovered ? constraints.maxWidth : 0,
                        height: 2,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.flBlue, AppColors.flCyan],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/data/portfolio_data.dart';
import 'package:my_portfolio/core/utils/responsive.dart';
import 'package:my_portfolio/model/portfolio_models.dart';


/// Experience section with vertical timeline layout.
class ExperienceSection extends StatelessWidget {
  final bool isDark;
  const ExperienceSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final isWide = MediaQuery.of(context).size.width > 800;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isWide) ...[
            _SectionHeader(isDark: isDark),
            const SizedBox(height: 48),
          ],
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 280, child: _SectionHeader(isDark: isDark)),
                    const SizedBox(width: 80),
                    Expanded(child: _Timeline(isDark: isDark)),
                  ],
                )
              : _Timeline(isDark: isDark),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final bool isDark;
  const _SectionHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor = isDark ? AppColors.darkText2 : AppColors.lightText2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('JOURNEY',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              letterSpacing: 2,
              color: AppColors.flCyan,
            )),
        const SizedBox(height: 12),
        Text(
          "Where I've\nGrown.",
          style: TextStyle(
            fontFamily: 'Syne',
            fontSize: Responsive.scale(context, 40, 64),
            fontWeight: FontWeight.w800,
            letterSpacing: -2,
            height: 1.05,
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'From +2 Science graduate to\ncross-platform Flutter developer.',
          style: TextStyle(
            fontFamily: 'Syne',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: subColor,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  final bool isDark;
  const _Timeline({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: PortfolioData.experiences
          .map((exp) => _TimelineItem(exp: exp, isDark: isDark))
          .toList(),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final ExperienceModel exp;
  final bool isDark;

  const _TimelineItem({required this.exp, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor = isDark ? AppColors.darkText2 : AppColors.lightText2;

    return Padding(
      padding: const EdgeInsets.only(bottom: 48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.flCyan,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x9954C5F8),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 120,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.flBlue, Color(0x1A027DFD)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exp.period,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: AppColors.flCyan,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  exp.role,
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  exp.company,
                  style: const TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.flBlue,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  exp.description,
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: subColor,
                    height: 1.8,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: exp.chips.map((chip) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.flBlue.withOpacity(0.1),
                        border: Border.all(
                            color: AppColors.flBlue.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        chip,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                          color: AppColors.flCyan,
                          letterSpacing: 0.5,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/data/portfolio_data.dart';
import 'package:my_portfolio/core/utils/responsive.dart';
import 'package:my_portfolio/model/portfolio_models.dart';

/// Projects section — list of project cards.
class ProjectsSection extends StatelessWidget {
  final bool isDark;
  const ProjectsSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor = isDark ? AppColors.darkText2 : AppColors.lightText2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 250), 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('SELECTED WORK',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 2,
                    color: AppColors.flCyan,
                  )),
              const SizedBox(height: 12),
              Text(
                'Projects That\nShipped.',
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: Responsive.scale(context, 40, 64),
                  fontWeight: FontWeight.w800,
                  letterSpacing: -2,
                  height: 1.05,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Real apps. Real users. Built with Flutter across every platform.',
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: subColor,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),

        // Project list
        ...PortfolioData.projects
            .map((p) => _ProjectRow(project: p, isDark: isDark)),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _ProjectRow extends StatefulWidget {
  final ProjectModel project;
  final bool isDark;

  const _ProjectRow({required this.project, required this.isDark});

  @override
  State<_ProjectRow> createState() => _ProjectRowState();
}

class _ProjectRowState extends State<_ProjectRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bg2 = widget.isDark ? AppColors.darkBg2 : AppColors.lightBg2;
    final border = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
    final numColor = widget.isDark ? AppColors.darkText3 : AppColors.lightText3;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {/* open github */},
        child: ClipRect(
          child: Stack(
            children: [
              // ── Main row ──────────────────────────────────────────
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: _hovered
                      ? (widget.isDark
                          ? Colors.white.withOpacity(0.02)
                          : AppColors.flBlue.withOpacity(0.04))
                      : bg2,
                  border: Border(top: BorderSide(color: border)),
                ),
                // ① padding-left slides 40 → 52 on hover
                padding: EdgeInsets.only(
                  left: _hovered ? 52 : 40,
                  right: 40,
                  top: 28,
                  bottom: 28,
                ),
                child: Row(
                  children: [
                    // Number
                    SizedBox(
                      width: 60,
                      child: Text(
                        widget.project.number,
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: numColor,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Meta
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.project.title,
                            style: TextStyle(
                              fontFamily: 'Syne',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: widget.project.tags.map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: widget.isDark
                                        ? AppColors.darkBorder2
                                        : AppColors.lightBorder2,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w400,
                                    color: widget.isDark
                                        ? AppColors.darkText3
                                        : AppColors.lightText3,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              );
                            }).toList(),       
                          ),
                        ],
                      ),
                    ),

                    // Right: platforms + arrow
                    Row(
                      children: [
                        ...widget.project.platformEmojis.map((emoji) {
                          return Container(
                            margin: const EdgeInsets.only(right: 6),
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: widget.isDark
                                  ? Colors.white.withOpacity(0.04)
                                  : Colors.black.withOpacity(0.04),
                              border: Border.all(
                                color: widget.isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              // ② platform icons scale up on hover
                              child: AnimatedScale(
                                scale: _hovered ? 1.1 : 1.0,
                                duration: const Duration(milliseconds: 200),
                                child: Text(emoji,
                                    style: const TextStyle(fontSize: 13)),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(width: 14),

                        // ③ Arrow: rotates -45° and fills blue on hover
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _hovered
                                ? AppColors.flBlue
                                : Colors.transparent,
                            border: Border.all(
                              color: _hovered
                                  ? AppColors.flBlue
                                  : (widget.isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                            ),
                          ),
                          child: Center(
                            child: AnimatedRotation(
                              turns: _hovered ? -0.125 : 0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                              child: Text(
                                '→',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _hovered
                                      ? Colors.white
                                      : (widget.isDark
                                          ? AppColors.darkText2
                                          : AppColors.lightText2),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ① Left vertical gradient bar — grows top→bottom on hover
              // Uses ClipRect + Align(heightFactor) to avoid zero-size
              // render objects that break mouse_tracker assertions
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: 3,
                child: ClipRect(
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    alignment: Alignment.topCenter,
                    heightFactor: _hovered ? 1.0 : 0.0,
                    child: Container(
                      width: 3,
                      decoration: const BoxDecoration(   
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.flBlue, AppColors.flCyan],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
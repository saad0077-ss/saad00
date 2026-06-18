import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/data/portfolio_data.dart';
import 'package:my_portfolio/core/utils/responsive.dart';
import 'package:my_portfolio/model/portfolio_models.dart';

/// Experience section with vertical timeline layout.
///
/// On wide screens this reproduces the `position: sticky` behaviour from
/// the reference HTML: the header pins at [stickyTopOffset] from the top
/// of the viewport while the timeline scrolls past it, then releases once
/// the timeline runs out so the header scrolls away with the rest of the
/// page — exactly like `.exp-sticky{position:sticky;top:120px}`.
///
/// IMPORTANT: this section must live inside a scrollable ancestor (the
/// page's SingleChildScrollView / ListView / CustomScrollView) for the
/// pinning math to work, since it listens to that ancestor's scroll
/// position.
class ExperienceSection extends StatefulWidget {
  const ExperienceSection({
    super.key,
    required this.isDark,
    this.stickyTopOffset = 120,
  });

  final bool isDark;

  /// Distance from the top of the viewport where the header should pin.
  /// Tune this to clear any fixed/floating nav bar you have, same as the
  /// `top: 120px` in the CSS.
  final double stickyTopOffset;

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> {
  final GlobalKey _gridKey = GlobalKey();
  final GlobalKey _headerKey = GlobalKey();
  final ValueNotifier<double> _headerOffset = ValueNotifier<double>(0);

  ScrollPosition? _scrollPosition;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-attach to the nearest ancestor Scrollable whenever it changes
    // (e.g. first build, or hot-reload). This also re-fires on any
    // MediaQuery change (window resize), since build() reads MediaQuery.
    final newPosition = Scrollable.maybeOf(context)?.position;
    if (newPosition != _scrollPosition) {
      _scrollPosition?.removeListener(_recalculate);
      _scrollPosition = newPosition;
      _scrollPosition?.addListener(_recalculate);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _recalculate());
  }

  @override
  void dispose() {
    _scrollPosition?.removeListener(_recalculate);
    _headerOffset.dispose();
    super.dispose();
  }

  void _recalculate() {
    final gridBox = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    final headerBox =
        _headerKey.currentContext?.findRenderObject() as RenderBox?;
    if (gridBox == null ||
        !gridBox.attached ||
        headerBox == null ||
        !headerBox.attached) {
      return;
    }

    final gridTop = gridBox.localToGlobal(Offset.zero).dy;
    final gridHeight = gridBox.size.height;
    final headerHeight = headerBox.size.height;

    // How far the header is allowed to travel before it hits the bottom
    final maxOffset = (gridHeight - headerHeight).clamp(0.0, double.infinity);

    // How far down (within the grid's own coordinates) the header needs
    // to be pushed so its on-screen position lands at stickyTopOffset.
    final offset =
        (widget.stickyTopOffset - gridTop).clamp(0.0, maxOffset);

    if ((offset - _headerOffset.value).abs() > 0.5) {
      _headerOffset.value = offset;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 1024; // matches the HTML's @media(max-width:1024px) switch

    final horizontalPadding = width > 1200
        ? 250.0
        : width > 1024
            ? 120.0
            : width > 800
                ? 56.0
                : width > 600
                    ? 32.0
                    : 20.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isWide) ...[
            _SectionHeader(isDark: widget.isDark),
            const SizedBox(height: 48),
            _Timeline(isDark: widget.isDark),
          ] else
            _StickyGrid(
              gridKey: _gridKey,
              headerKey: _headerKey,
              headerOffset: _headerOffset,
              isDark: widget.isDark,
            ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

/// Lays out the header column + timeline column, and keeps the header
/// visually pinned via a [Transform.translate] driven by [headerOffset].
/// Only the header repaints on scroll — the timeline is never rebuilt.
class _StickyGrid extends StatelessWidget {
  const _StickyGrid({
    required this.gridKey,
    required this.headerKey,
    required this.headerOffset,
    required this.isDark,
  });

  final GlobalKey gridKey;
  final GlobalKey headerKey;
  final ValueNotifier<double> headerOffset;
  final bool isDark;

  static const double _headerColumnWidth = 300;
  static const double _gap = 50;

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: gridKey,
      children: [
        // Normal-flow layout: this is what actually sizes the section
        // (height = the timeline's height, same as the CSS grid). The
        // SizedBox here is just a spacer reserving the header's column
        // width — the real, visible header is painted on top of it below,
        // so it can be offset independently without affecting layout.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: _headerColumnWidth),
            const SizedBox(width: _gap),
            Expanded(child: _Timeline(isDark: isDark)),
          ],
        ),
        Positioned(
          top: 0,
          left: 0,
          width: _headerColumnWidth,
          child: ValueListenableBuilder<double>(
            valueListenable: headerOffset,
            builder: (context, offset, child) {
              return Transform.translate(
                offset: Offset(0, offset),
                child: child,
              );
            },
            child: KeyedSubtree(
              key: headerKey,
              child: _SectionHeader(isDark: isDark),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width <= 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'JOURNEY',
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 10,
            fontWeight: FontWeight.w400,
            letterSpacing: 2,
            color: AppColors.flCyan,
          ),
        ),
        SizedBox(height: isMobile ? 10 : 12),
        Text(
          // Drop the hard line-break on narrow phones so the headline
          // wraps naturally instead of forcing an odd-looking split.
          isMobile ? "Where I've Grown." : "Where I've\nGrown.",
          style: TextStyle(
            fontFamily: 'Syne',
            fontSize: Responsive.scale(context, 32, 50),
            fontWeight: FontWeight.w800,
            letterSpacing: -1.5,
            height: 1.08,
            color: textColor,
          ),
        ),
        SizedBox(height: isMobile ? 12 : 16),
        Text(
          isMobile
              ? 'From +2 Science graduate to cross-platform Flutter developer.'
              : 'From +2 Science graduate to\ncross-platform Flutter developer.',
          style: TextStyle(
            fontFamily: 'Syne',
            fontSize: Responsive.scale(context, 14, 16),
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
  const _Timeline({required this.isDark});
  final bool isDark;

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
  const _TimelineItem({required this.exp, required this.isDark});

  final ExperienceModel exp;
  final bool isDark;

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
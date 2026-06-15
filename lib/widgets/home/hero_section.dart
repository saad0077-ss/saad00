import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/data/portfolio_data.dart';
import 'package:my_portfolio/core/utils/responsive.dart';
import 'package:my_portfolio/widgets/common/custom_cursor.dart';


/// Hero section — full viewport height with gradient title and platform pills.
class HeroSection extends StatefulWidget {
  final bool isDark;
  final VoidCallback onViewWork;
  final VoidCallback onContact;

  const HeroSection({
    super.key,
    required this.isDark,
    required this.onViewWork,
    required this.onContact,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDark ? AppColors.darkText : AppColors.lightText;
    final subColor = widget.isDark ? AppColors.darkText2 : AppColors.lightText2;
    final isWide = MediaQuery.of(context).size.width > 900;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: isWide
          ? Row(children: [
              Expanded(child: _buildLeft(textColor, subColor)),
              Expanded(child: _buildRight()),
            ])
          : SingleChildScrollView(
              child: Column(children: [
                _buildLeft(textColor, subColor),
                const SizedBox(height: 40),
                _buildRight(),
                const SizedBox(height: 80),
              ]),
            ),
    );
  }

  Widget _buildLeft(Color textColor, Color subColor) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(56, 110, 40, 80),
    child: SingleChildScrollView(                              // ← add this
      physics: const NeverScrollableScrollPhysics(),          // ← no user scroll
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          FadeTransition(        
            opacity: _fadeAnim,
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.flBlue.withOpacity(0.5), width: 2),
                image: const DecorationImage(
                  image: AssetImage('assets/images/IMG_20250119_163512_418.jpg'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.flBlue.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // Eyebrow
          FadeTransition(
            opacity: _fadeAnim,
            child: Row(
              children: [
                Container(width: 24, height: 1, color: AppColors.flCyan),
                const SizedBox(width: 8),
                const Text(
                  'FLUTTER DEVELOPER',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 3, 
                    color: AppColors.flCyan,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          // Main title
          FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.flBlue, AppColors.flCyan, Color(0xFFA78BFA)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds),
                  child: Text(
                    'Flutter',
                    style: TextStyle(
                      fontFamily: 'Syne',
                      fontSize: Responsive.scale(context, 52, 82),
                      fontWeight: FontWeight.w800,
                      height: 0.95,
                      letterSpacing: -3,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  'Artisan.',
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: Responsive.scale(context, 52, 82),
                    fontWeight: FontWeight.w800,
                    height: 0.95,
                    letterSpacing: -3,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Mobile · Web · Desktop', 
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: Responsive.scale(context, 18, 28),
                    fontWeight: FontWeight.w400,
                    color: subColor,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22 ),

          // Platform pills
          FadeTransition(
            opacity: _fadeAnim, 
            child: const Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                _PlatformPill(label: 'Android', dotColor: AppColors.androidGreen),
                _PlatformPill(label: 'iOS', dotColor: AppColors.iosGray),
                _PlatformPill(label: 'Web', dotColor: AppColors.webBlue),
                _PlatformPill(label: 'Desktop', dotColor: AppColors.deskPurple),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // Bio
          FadeTransition(
            opacity: _fadeAnim,
            child: Text(
              PortfolioData.heroBio,
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 15,
                height: 1.85,
                color: subColor,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // CTAs
          FadeTransition(
            opacity: _fadeAnim,
            child: Row(
              children: [
                _HeroCTA(
                  label: 'View My Work →',
                  isPrimary: true,
                  onTap: widget.onViewWork,                   
                  isDark: widget.isDark,
                ),
                const SizedBox(width: 14),
                _HeroCTA(
                  label: "Let's Talk",
                  isPrimary: false,
                  onTap: widget.onContact,
                  isDark: widget.isDark,
                ),                      
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildRight() {
    return Center(
      child: _DeviceShowcase(isDark: widget.isDark),
    );
  }
}

class _PlatformPill extends StatefulWidget {
  final String label;
  final Color dotColor;

  const _PlatformPill({required this.label, required this.dotColor});

  @override
  State<_PlatformPill> createState() => _PlatformPillState();
}

class _PlatformPillState extends State<_PlatformPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        CursorState.isHovering.value = true;
      },
      onExit: (_) {
        setState(() => _hovered = false);
        CursorState.isHovering.value = false;
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          border: Border.all(
            color: _hovered ? AppColors.flCyan : Colors.white.withOpacity(0.12),
          ),
          borderRadius: BorderRadius.circular(40),
          color: Colors.white.withOpacity(0.04),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: widget.dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              widget.label,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                letterSpacing: 0.5,
                color: _hovered ? AppColors.flCyan : const Color(0xFF7A8899),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCTA extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;
  final bool isDark;

  const _HeroCTA({
    required this.label,
    required this.isPrimary,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_HeroCTA> createState() => _HeroCTAState();
}

class _HeroCTAState extends State<_HeroCTA> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        CursorState.isHovering.value = true;
      },
      onExit: (_) {
        setState(() => _hovered = false);
        CursorState.isHovering.value = false;
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 15),
          decoration: BoxDecoration(
            gradient: widget.isPrimary
                ? const LinearGradient(
                    colors: [AppColors.flBlue, AppColors.flNavy],
                  )
                : null,
            border: widget.isPrimary
                ? null
                : Border.all(
                    color: widget.isDark
                        ? Colors.white.withOpacity(0.19)
                        : Colors.black.withOpacity(0.14),
                  ),
            borderRadius: BorderRadius.circular(50),
            boxShadow: widget.isPrimary
                ? [
                    BoxShadow(
                      color: AppColors.flBlue
                          .withOpacity(_hovered ? 0.45 : 0.3),
                      blurRadius: _hovered ? 50 : 40,
                    )
                  ]
                : null,
            color: widget.isPrimary
                ? null
                : (_hovered
                    ? AppColors.flCyan.withOpacity(0.06)
                    : Colors.transparent),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: widget.isPrimary
                  ? Colors.white
                  : (widget.isDark ? AppColors.darkText : AppColors.lightText),
            ),
          ),
        ),
      ),
    );
  }
}
/// Mock device showcase for the hero right panel with rotating orbs and floating multi-device layouts.
class _DeviceShowcase extends StatefulWidget {
  final bool isDark;
  const _DeviceShowcase({required this.isDark});

  @override
  State<_DeviceShowcase> createState() => _DeviceShowcaseState();
}

class _DeviceShowcaseState extends State<_DeviceShowcase>
    with SingleTickerProviderStateMixin {
  late AnimationController _orbCtrl;

  @override
  void initState() {
    super.initState();
    // Continuous rotation/floating ticks
    _orbCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _orbCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenBg = widget.isDark ? const Color(0xFF1A2030) : const Color(0xFFD8E4F4);

    return SizedBox(
      width: 520,
      height: 520,
      child: AnimatedBuilder(
        animation: _orbCtrl,
        builder: (context, child) {
          final t = _orbCtrl.value * 2 * pi;

          // Physics-based independent float offsets
          final offsetDesktop = Offset(0, sin(t * 2.8) * 12.0);
          final offsetTablet = Offset(0, sin(t * 2.5 + pi / 4) * 9.0);
          final offsetPhone = Offset(0, sin(t * 3.3 - pi / 3) * 14.0);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Background orbiting circles and glowing dots
              Positioned.fill(
                child: CustomPaint(
                  painter: _OrbPainter(_orbCtrl.value, widget.isDark),
                ),
              ),

              // 1. Desktop monitor mockup (Floating A)
              Positioned(
                left: 30,
                top: 60,
                child: Transform.translate(
                  offset: offsetDesktop,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _DesktopMockup(isDark: widget.isDark, screenBg: screenBg),
                      Positioned(
                        left: 4,
                        top: -24,
                        child: _DeviceLabel(label: 'Desktop', isDark: widget.isDark),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Tablet mockup (Floating B)
              Positioned(
                left: 10,
                bottom: 60,
                child: Transform.translate(
                  offset: offsetTablet,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _TabletMockup(isDark: widget.isDark, screenBg: screenBg),
                      Positioned(
                        left: 34,
                        bottom: -24,
                        child: _DeviceLabel(label: 'Tablet', isDark: widget.isDark),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Mobile phone mockup (Floating C)
              Positioned(
                right: 30,
                bottom: 30,
                child: Transform.translate(
                  offset: offsetPhone,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _PhoneMockup(isDark: widget.isDark, screenBg: screenBg),
                      Positioned(
                        right: 4,
                        bottom: -24,
                        child: _DeviceLabel(label: 'Mobile', isDark: widget.isDark),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Custom painter for background concentric orbits and glowing tracker dots.
class _OrbPainter extends CustomPainter {
  final double progress;
  final bool isDark;
  _OrbPainter(this.progress, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final borderPaint = Paint()
      ..color = isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final glowPaint = Paint()
      ..color = AppColors.flCyan
      ..style = PaintingStyle.fill;

    // Rings dimensions matching HTML
    final radii = [250.0, 180.0, 110.0];
    final speeds = [1.0, -1.5, 2.0];
    final phases = [0.0, pi, pi / 3];

    for (int i = 0; i < 3; i++) {
      final radius = radii[i];
      canvas.drawCircle(center, radius, borderPaint);

      // Orbital glowing tracker position
      final angle = progress * 2 * pi * speeds[i] + phases[i];
      final dotOffset = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      // Tracker halo glow
      canvas.drawCircle(
        dotOffset,
        8,
        Paint()
          ..color = AppColors.flCyan.withOpacity(0.25)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
      );

      // Core tracker dot
      canvas.drawCircle(dotOffset, 3, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.isDark != isDark;
}

/// A custom label badge floating with each device.
class _DeviceLabel extends StatelessWidget {
  final String label;
  final bool isDark;
  const _DeviceLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 1,
          color: AppColors.flCyan.withOpacity(0.6),
        ),
        const SizedBox(width: 6),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 8,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
            color: AppColors.flCyan.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

/// Desktop / Laptop Mockup
class _DesktopMockup extends StatefulWidget {
  final bool isDark;
  final Color screenBg;
  const _DesktopMockup({required this.isDark, required this.screenBg});

  @override
  State<_DesktopMockup> createState() => _DesktopMockupState();
}

class _DesktopMockupState extends State<_DesktopMockup>
    with SingleTickerProviderStateMixin {
  late AnimationController _barCtrl;

  @override
  void initState() {
    super.initState();
    _barCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _barCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shadowColor = Colors.black.withOpacity(0.55);
    final cardBg = widget.isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03);
    final cardBorder = widget.isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.06);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Laptop screen
        Container(
          width: 320,
          height: 200,
          decoration: BoxDecoration(
            color: widget.screenBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            border: Border.all(color: Colors.white.withOpacity(0.13), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 80,
                offset: const Offset(0, 30),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // Title bar
              Row(
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFFF5F57), shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFFFBD2E), shape: BoxShape.circle)),
                  const SizedBox(width: 6),
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF28C840), shape: BoxShape.circle)),
                ],
              ),
              const SizedBox(height: 10),

              // Layout Body
              Expanded(
                child: Row(
                  children: [
                    // Sidebar
                    Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: AppColors.flBlue.withOpacity(0.08),
                        border: Border.all(color: AppColors.flBlue.withOpacity(0.15)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        children: List.generate(
                          4,
                          (i) => Container(
                            height: 16,
                            margin: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              color: i == 0
                                  ? AppColors.flBlue.withOpacity(0.25)
                                  : Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(5),
                              border: i == 0 ? Border.all(color: AppColors.flBlue.withOpacity(0.4)) : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Main dashboard area
                    Expanded(
                      child: Column(
                        children: [
                          // Grid metrics row
                          Row(
                            children: [
                              _buildMetricCard('REVENUE', '\$84k', true, cardBg, cardBorder),
                              const SizedBox(width: 6),
                              _buildMetricCard('USERS', '1.2M', false, cardBg, cardBorder),
                              const SizedBox(width: 6),
                              _buildMetricCard('GROWTH', '+24%', false, cardBg, cardBorder, isGreen: true),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Chart card
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: cardBg,
                                border: Border.all(color: cardBorder),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'MONTHLY OVERVIEW',
                                        style: TextStyle(
                                          fontFamily: 'JetBrainsMono',
                                          fontSize: 6,
                                          color: widget.isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                        decoration: BoxDecoration(
                                          color: AppColors.green.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(3),
                                        ),
                                        child: const Text(
                                          '+18.4%',
                                          style: TextStyle(color: AppColors.green, fontSize: 5, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),

                                  // Bar charts
                                  AnimatedBuilder(
                                    animation: _barCtrl,
                                    builder: (context, _) {
                                      final baseHeights = [0.40, 0.75, 0.55, 0.85, 0.45, 0.95, 0.60, 0.35];
                                      return SizedBox(
                                        height: 52,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: List.generate(8, (i) {
                                            final wave = sin(_barCtrl.value * 2 * pi + i);
                                            final hFactor = (baseHeights[i] + wave * 0.12).clamp(0.1, 0.95);

                                            return Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                                child: FractionallySizedBox(
                                                  heightFactor: hFactor,
                                                  alignment: Alignment.bottomCenter,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: (i % 2 == 1)
                                                          ? const LinearGradient(
                                                              colors: [AppColors.flBlue, AppColors.flCyan],
                                                              begin: Alignment.bottomCenter,
                                                              end: Alignment.topCenter,
                                                            )
                                                          : null,
                                                      color: (i % 2 == 0)
                                                          ? AppColors.flCyan.withOpacity(0.18)
                                                          : null,
                                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 4),

                                  // Base line
                                  Container(
                                    height: 1,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.flBlue.withOpacity(0.5),
                                          AppColors.flCyan.withOpacity(0.5),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Stand
        Container(
          width: 50,
          height: 12,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(widget.isDark ? 0.06 : 0.08),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            border: Border(
              left: BorderSide(color: Colors.white.withOpacity(0.08)),
              right: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
          ),
        ),

        // Base
        Container(
          width: 90,
          height: 6,
          decoration: BoxDecoration(
            color: widget.isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, bool isBlue, Color bg, Color border, {bool isGreen = false}) {
    return Expanded(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 5,
                color: widget.isDark ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.3),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            if (isBlue)
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.flBlue, AppColors.flCyan],
                ).createShader(bounds),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
            else
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isGreen
                      ? AppColors.green
                      : (widget.isDark ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Tablet Mockup
class _TabletMockup extends StatefulWidget {
  final bool isDark;
  final Color screenBg;
  const _TabletMockup({required this.isDark, required this.screenBg});

  @override
  State<_TabletMockup> createState() => _TabletMockupState();
}

class _TabletMockupState extends State<_TabletMockup>
    with SingleTickerProviderStateMixin {
  late AnimationController _barCtrl;

  @override
  void initState() {
    super.initState();
    _barCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _barCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 140,
      decoration: BoxDecoration(
        color: widget.screenBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 50,
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Titlebar
          Row(
            children: [
              Container(width: 5, height: 5, decoration: const BoxDecoration(color: Color(0xFFFF5F57), shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Container(width: 5, height: 5, decoration: const BoxDecoration(color: Color(0xFFFFBD2E), shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Container(width: 5, height: 5, decoration: const BoxDecoration(color: Color(0xFF28C840), shape: BoxShape.circle)),
            ],
          ),
          const SizedBox(height: 8),

          // Body layout
          Expanded(
            child: Row(
              children: [
                // Sidebar
                Column(
                  children: List.generate(
                    4,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        width: 32,
                        height: 16,
                        decoration: BoxDecoration(
                          color: i == 0
                              ? AppColors.flBlue.withOpacity(0.2)
                              : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(4),
                          border: i == 0 ? Border.all(color: AppColors.flBlue.withOpacity(0.3)) : null,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Content
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white.withOpacity(0.03),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppColors.flBlue, AppColors.flCyan]),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          width: 65,
                        ),
                        const SizedBox(height: 4),
                        Container(height: 3, width: 90, decoration: BoxDecoration(color: Colors.white.withOpacity(0.07), borderRadius: BorderRadius.circular(2))),
                        const SizedBox(height: 4),
                        Container(height: 3, width: 55, decoration: BoxDecoration(color: Colors.white.withOpacity(0.07), borderRadius: BorderRadius.circular(2))),
                        const Spacer(),

                        // Chart bars
                        AnimatedBuilder(
                          animation: _barCtrl,
                          builder: (context, _) {
                            final baseHeights = [0.35, 0.72, 0.50, 0.88, 0.42, 0.65];
                            return SizedBox(
                              height: 38,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(6, (i) {
                                  final wave = sin(_barCtrl.value * 2 * pi + i);
                                  final hFactor = (baseHeights[i] + wave * 0.10).clamp(0.1, 0.95);

                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 1.5),
                                      child: FractionallySizedBox(
                                        heightFactor: hFactor,
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: (i % 2 == 1)
                                                ? const LinearGradient(
                                                    colors: [AppColors.flBlue, AppColors.flCyan],
                                                    begin: Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                  )
                                                : null,
                                            color: (i % 2 == 0)
                                                ? AppColors.flCyan.withOpacity(0.20)
                                                : null,
                                            borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Mobile mockup widget styled matching the financial app
class _PhoneMockup extends StatelessWidget {
  final bool isDark;
  final Color screenBg;

  const _PhoneMockup({required this.isDark, required this.screenBg});

  @override
  Widget build(BuildContext context) {
    final cardBg = Colors.white.withOpacity(0.05);
    final cardBorder = Colors.white.withOpacity(0.06);

    return Container(
      width: 120,
      height: 240,
      decoration: BoxDecoration(
        color: screenBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.13), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.55),
            blurRadius: 60,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          children: [
            // Notch
            Container(
              width: 46,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [AppColors.flBlue, AppColors.flCyan]),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  'DartFlow',
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 7,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const Text('🔔', style: TextStyle(fontSize: 8)),
              ],
            ),
            const SizedBox(height: 8),

            // Credit card
            Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.flBlue, AppColors.flCyan],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'TOTAL BALANCE',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 4,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const Text(
                    '\$12,840',
                    style: TextStyle(
                      fontFamily: 'Syne',
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Mini grid card row
            Row(
              children: [
                _buildPhoneMiniCard('INCOME', '+\$4.2k', cardBg, cardBorder),
                const SizedBox(width: 5),
                _buildPhoneMiniCard('SPEND', '-\$1.8k', cardBg, cardBorder),
              ],
            ),
            const SizedBox(height: 6),

            // List items representing transaction log
            Expanded(
              child: Column(
                children: [
                  _buildPhoneListItem('Netflix', 'Yesterday · 18:30', const Color(0xFF027DFD), const Color(0xFF54C5F8)),
                  const SizedBox(height: 4),
                  _buildPhoneListItem('Spotify', 'Today · 09:14', const Color(0xFF7C4DFF), const Color(0xFFCE93D8)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneMiniCard(String label, String value, Color bg, Color border) {
    return Expanded(
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 4,
                color: Colors.white.withOpacity(0.35),
                letterSpacing: 0.5,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneListItem(String title, String sub, Color startGrad, Color endGrad) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.04))),
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [startGrad, endGrad]),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 6,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  sub,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 5,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

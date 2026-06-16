import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/data/portfolio_data.dart';
import 'package:my_portfolio/core/utils/responsive.dart';

/// About section using the "ORBIT & STACK" v5 design.
/// Features a 3D Mouse-Tilt Card with Orbiting Skill nodes on the left,
/// and typewriter/scroll-reveal narrative highlights on the right.
class AboutSection extends StatelessWidget {
  final bool isDark;
  const AboutSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor = isDark ? AppColors.darkText2 : AppColors.lightText2;

    final screenWidth = MediaQuery.of(context).size.width;
    final paddingX = screenWidth > 1200
        ? 250.0
        : screenWidth > 800
            ? 120.0
            : screenWidth > 600
                ? 48.0
                : 24.0;

    final isWide = screenWidth > 980;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingX, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Label (matching Saad's HTML/CSS eyebrow)
          Row(
            children: [
              const Text(
                'ABOUT ME',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2.0,
                  color: AppColors.flCyan,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        isDark ? AppColors.darkBorder2 : AppColors.lightBorder2,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Section Heading
          Text(
            'Building a foundation,\none Flutter widget at a time.',
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: Responsive.scale(context, 28, 42),
              fontWeight: FontWeight.w800,
              letterSpacing: -1.0,
              height: 1.15,
              color: textColor,
            ),
          ),
          const SizedBox(height: 48),

          // Main Layout: Split screen or stacked
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 10,
                      child: _TiltCard(isDark: isDark),
                    ),
                    const SizedBox(width: 60),
                    Expanded(
                      flex: 12,
                      child: _RevealDetails(isDark: isDark, subColor: subColor),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _TiltCard(isDark: isDark),
                    const SizedBox(height: 64),
                    _RevealDetails(isDark: isDark, subColor: subColor),
                  ],
                ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3D Tilt Card Component
// ---------------------------------------------------------------------------
class _TiltCard extends StatefulWidget {
  final bool isDark;
  const _TiltCard({required this.isDark});

  @override
  State<_TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<_TiltCard> {
  bool _hovered = false;
  double _rx = 0.0;
  double _ry = 0.0;
  Offset _mousePos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final cardBorder = widget.isDark ? AppColors.darkBorder2 : AppColors.lightBorder2;
    final cardBg = widget.isDark ? Colors.white.withOpacity(0.04) : Colors.white.withOpacity(0.8);
    final cardBgEnd = widget.isDark ? AppColors.darkBg2 : AppColors.lightBg2;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) {
        setState(() {
          _hovered = false;
          _rx = 0.0;
          _ry = 0.0;
        });
      },
      onHover: (e) {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          final size = box.size;
          final localPos = e.localPosition;
          _mousePos = localPos;

          // Normalize values between -0.5 and 0.5
          final px = localPos.dx / size.width;
          final py = localPos.dy / size.height;

          // Rotation: X rotates on Y, Y rotates on X (limited to 14 deg)
          _ry = (px - 0.5) * 14.0;
          _rx = (py - 0.5) * -14.0;
          setState(() {});
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // perspective
          ..rotateX(_rx * pi / 180)
          ..rotateY(_ry * pi / 180),
        transformAlignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: cardBorder),
          gradient: LinearGradient(
            colors: [cardBg, cardBgEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hovered ? 0.5 : 0.3),
              blurRadius: _hovered ? 60 : 40,
              offset: const Offset(0, 20),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // Mouse Glow
            if (_hovered)
              Positioned.fill(
                child: CustomPaint(
                  painter: _GlowPainter(mousePos: _mousePos, hovered: _hovered),
                ),
              ),

            // Card Inner Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 40),
              child: Column(
                children: [


                  // Concentric Orbit Stage
                  const _OrbitStage(),
                  const SizedBox(height: 28),

                  // Profile Copy
                  Text(
                    PortfolioData.name == 'Saad' ? 'Muhammed Saad C' : PortfolioData.name,
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.white : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'FLUTTER LEARNER · FRESHER',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.flCyan,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Divider
                  Container(
                    height: 1,
                    color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  const SizedBox(height: 20),

                  // stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCardStat('3', 'Projects'),
                      _buildCardStat('2024–', 'Flutter'),
                      _buildCardStat('Sci.', '+2 Stream'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardStat(String value, String label) {
    final int? intValue = int.tryParse(value);
    return Column(
      children: [
        if (intValue != null)
          CounterText(
            target: intValue,
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.isDark ? Colors.white : AppColors.lightText,
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: widget.isDark ? Colors.white : AppColors.lightText,
            ),
          ),
        const SizedBox(height: 3),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 9.5,
            color: AppColors.flCyan,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Concentric Orbit Stage Widget
// ---------------------------------------------------------------------------
class _OrbitStage extends StatefulWidget {
  const _OrbitStage();

  @override
  State<_OrbitStage> createState() => _OrbitStageState();
}

class _OrbitStageState extends State<_OrbitStage> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 26),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 180,
      height: 180,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          final progress = _ctrl.value;
          final angle1 = progress * 2 * pi;
          final angle2 = angle1 + (2 * pi / 3);
          final angle3 = angle1 + (4 * pi / 3);

          // Position coordinates for orbiting nodes (radius = 65)
          const double r = 65.0;
          final p1 = Offset(cos(angle1) * r, sin(angle1) * r);
          final p2 = Offset(cos(angle2) * r, sin(angle2) * r);
          final p3 = Offset(cos(angle3) * r, sin(angle3) * r);

          return Stack(
            alignment: Alignment.center,
            children: [
              // 1. concentric rings dashed painter
              Positioned.fill(
                child: CustomPaint(
                  painter: _ConcentricRingsPainter(isDark: isDark),
                ),
              ),

              // 2. Central image hub
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.flCyan.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.flBlue.withOpacity(0.4),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/IMG_20250119_163512_418.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: isDark ? AppColors.darkBg3 : AppColors.lightBg3,
                        alignment: Alignment.center,
                        child: const Text('👤', style: TextStyle(fontSize: 24)),
                      );
                    },
                  ),
                ),
              ),

              // 3. Orbiting Nodes (📱, ⚡, 🎨)
              _buildOrbitingNode(p1, '📱'),
              _buildOrbitingNode(p2, '⚡'),
              _buildOrbitingNode(p3, '🎨'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrbitingNode(Offset offset, String emoji) {
    return Transform.translate(
      offset: offset,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.85),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.flCyan.withOpacity(0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}

// Concentric Rings Painter
class _ConcentricRingsPainter extends CustomPainter {
  final bool isDark;
  const _ConcentricRingsPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Outer Orbit Ring (radius = 65)
    _drawDashedCircle(canvas, center, 65.0, paint);
    // Inner Orbit Ring (radius = 42)
    _drawDashedCircle(canvas, center, 42.0, paint);
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius, Paint paint) {
    const double dashLength = 4.0;
    const double spaceLength = 4.0;
    final double circumference = 2 * pi * radius;
    final int dashCount = (circumference / (dashLength + spaceLength)).floor();
    final double sweepAngle = dashLength / radius;

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = (i * (dashLength + spaceLength)) / radius;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Typewriter & Reveal Details Component (Right side)
// ---------------------------------------------------------------------------
class _RevealDetails extends StatelessWidget {
  final bool isDark;
  final Color subColor;

  const _RevealDetails({
    required this.isDark,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tagline Typewriter
        const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            _TypewriterText(),
            SizedBox(width: 4),
            _Caret(),
          ],
        ),
        const SizedBox(height: 24),

        // Narrative Reveal list
        Column(
          children: List.generate(
            PortfolioData.aboutRevealItems.length,
            (index) => _RevealItem(
              index: index,
              item: PortfolioData.aboutRevealItems[index],
              isDark: isDark,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Typewriter Tagline Text
// ---------------------------------------------------------------------------
class _TypewriterText extends StatefulWidget {
  const _TypewriterText();

  @override
  State<_TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<_TypewriterText> {
  int _phraseIndex = 0;
  int _charIndex = 0;
  bool _deleting = false;
  String _currentText = '';
  Timer? _timer;

  static const Duration typingSpeed = Duration(milliseconds: 120);
  static const Duration deletingSpeed = Duration(milliseconds: 60);
  static const Duration pauseDuration = Duration(milliseconds: 2000);

  @override
  void initState() {
    super.initState();
    _tick();
  }

  void _schedule(Duration duration) {
    _timer?.cancel();
    _timer = Timer(duration, _tick);
  }

  void _tick() {
    if (!mounted) return;

    final phrase = PortfolioData.aboutTypewriterPhrases[_phraseIndex];

    setState(() {
      if (!_deleting) {
        if (_charIndex < phrase.length) {
          _charIndex++;
          _currentText = phrase.substring(0, _charIndex);
        }
      } else {
        if (_charIndex > 0) {
          _charIndex--;
          _currentText = phrase.substring(0, _charIndex);
        }
      }
    });

    if (!_deleting && _charIndex == phrase.length) {
      _deleting = true;
      _schedule(pauseDuration);
      return;
    }

    if (_deleting && _charIndex == 0) {
      _deleting = false;
      _phraseIndex =
          (_phraseIndex + 1) % PortfolioData.aboutTypewriterPhrases.length;
      _schedule(const Duration(milliseconds: 500));
      return;
    }

    _schedule(_deleting ? deletingSpeed : typingSpeed);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentText,
      style: const TextStyle( 
        fontFamily: 'JetBrainsMono',
        fontSize: 14.5,
        fontWeight: FontWeight.w500,
        color: AppColors.flCyan,
      ),
    );
  }
}

// Blinking Caret for typewriter
class _Caret extends StatefulWidget {
  const _Caret();

  @override
  State<_Caret> createState() => _CaretState();
}

class _CaretState extends State<_Caret> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: Container(
        width: 2,
        height: 16,
        color: AppColors.flCyan,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Staggered Slide & Fade Reveal Item Widget
// ---------------------------------------------------------------------------
class _RevealItem extends StatefulWidget {
  final int index;
  final Map<String, String> item;
  final bool isDark;

  const _RevealItem({
    required this.index,
    required this.item,
    required this.isDark,
  });

  @override
  State<_RevealItem> createState() => _RevealItemState();
}

class _RevealItemState extends State<_RevealItem> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );

    _slide = Tween<double>(begin: -24.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Cubic(0.16, 1.0, 0.3, 1.0)),
    );

    // Stagger start based on index
    Future.delayed(Duration(milliseconds: widget.index * 120 + 300), () {
      if (mounted) {
        _ctrl.forward();
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text2 = widget.isDark ? AppColors.darkText2 : AppColors.lightText2;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slide.value, 0),
          child: Opacity(
            opacity: _opacity.value,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Staggered Number badge
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: border),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.item['num']!,
                style: const TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.flCyan,
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Staggered text details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item['title']!,
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: widget.isDark ? Colors.white : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.item['desc']!,
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 13,
                      height: 1.7,
                      color: text2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Custom Dashed Circle Painter
// ---------------------------------------------------------------------------
class DashedCirclePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double spaceLength;

  DashedCirclePainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashLength = 5.0,
    this.spaceLength = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final double circumference = 2 * pi * radius;
    final int dashCount = (circumference / (dashLength + spaceLength)).floor();
    final double sweepAngle = dashLength / radius;

    for (int i = 0; i < dashCount; i++) {
      final double startAngle = (i * (dashLength + spaceLength)) / radius;
      canvas.drawArc(
        Rect.fromLTWH(0, 0, size.width, size.height),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Tween Counter Text Widget
// ---------------------------------------------------------------------------
class CounterText extends StatelessWidget {
  final int target;
  final String suffix;
  final TextStyle style;

  const CounterText({
    super.key,
    required this.target,
    this.suffix = '',
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: target.toDouble()),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Text(
          '${value.round()}$suffix',
          style: style,
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Hover Radial Glow Painter (3D card)
// ---------------------------------------------------------------------------
class _GlowPainter extends CustomPainter {
  final Offset mousePos;
  final bool hovered;

  const _GlowPainter({
    required this.mousePos,
    required this.hovered,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!hovered) return;

    final paint = Paint()
      ..shader = RadialGradient(
        center: FractionalOffset(
          size.width > 0 ? mousePos.dx / size.width : 0.5,
          size.height > 0 ? mousePos.dy / size.height : 0.5,
        ),
        radius: 0.65,
        colors: [
          AppColors.flCyan.withOpacity(0.12),
          Colors.transparent,
        ],
        stops: const [0.0, 1.0],
      ).createShader(Offset.zero & size);

    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(28)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _GlowPainter oldDelegate) {
    return oldDelegate.mousePos != mousePos || oldDelegate.hovered != hovered;
  }
}
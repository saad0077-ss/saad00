import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/data/portfolio_data.dart';
import 'package:my_portfolio/core/utils/responsive.dart';

/// About section with bento-grid layout cards.
class AboutSection extends StatelessWidget {
  final bool isDark;
  const AboutSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 250, vertical: 100), 
      child: Column(  
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          const Text(
            'ABOUT ME',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              letterSpacing: 2,
              color: AppColors.flCyan,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Code. Craft.\nCross-Platform.',
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: Responsive.scale(context, 40, 64),
              fontWeight: FontWeight.w800,
              letterSpacing: -2,
              height: 1.05,
              color: textColor,
            ),
          ),
          const SizedBox(height: 48),

          // Bento grid
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            if (isWide) {
              return Column(
                children: [
                  // Row 1: Bio (flex 7) + Availability (flex 5) — equal height via IntrinsicHeight
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 7, child: _BioBentoCell(isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(flex: 7, child: _AvailabilityCell(isDark: isDark)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Row 2: CodeSnippet (flex 5) + Stack (flex 7) — equal height via IntrinsicHeight
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(flex: 5, child: _CodeSnippetCell(isDark: isDark)),
                        const SizedBox(width: 12),
                        Expanded(flex: 7, child: _StackCell(isDark: isDark)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Row 3: Clients — full width
                  SizedBox(
                    width: double.infinity,
                    child: _ClientsCell(isDark: isDark),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  _BioBentoCell(isDark: isDark),
                  const SizedBox(height: 12),
                  _AvailabilityCell(isDark: isDark),
                  const SizedBox(height: 12),
                  _CodeSnippetCell(isDark: isDark),
                  const SizedBox(height: 12),
                  _StackCell(isDark: isDark),
                  const SizedBox(height: 12),
                  _ClientsCell(isDark: isDark),
                ],
              );
            }
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Bento card shell — hover glow + border animation
// ---------------------------------------------------------------------------
class _BentoCard extends StatefulWidget {
  final Widget child;
  final bool isDark;

  const _BentoCard({required this.child, required this.isDark});

  @override
  State<_BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<_BentoCard> {
  bool _hovered = false;
  Offset _mousePos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      onHover: (e) => setState(() => _mousePos = e.localPosition),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget.isDark
              ? (_hovered
                  ? Colors.white.withOpacity(0.02)
                  : Colors.white.withOpacity(0.03))
              : (_hovered
                  ? AppColors.flBlue.withOpacity(0.02)
                  : Colors.white.withOpacity(0.6)),
          border: Border.all(
            color: _hovered
                ? AppColors.flCyan.withOpacity(0.2)
                : (widget.isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            if (_hovered)
              Positioned.fill(
                child: CustomPaint(
                  painter: _HoverGlowPainter(
                    mousePos: _mousePos,
                    hovered: _hovered,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(28),
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}

class _HoverGlowPainter extends CustomPainter {
  final Offset mousePos;
  final bool hovered;

  const _HoverGlowPainter({
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
        radius: 0.6,
        colors: [
          AppColors.flCyan.withOpacity(0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 1.0],
      ).createShader(Offset.zero & size);

    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(20)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _HoverGlowPainter oldDelegate) {
    return oldDelegate.mousePos != mousePos || oldDelegate.hovered != hovered;
  }
}

// ---------------------------------------------------------------------------
// Cell 1 — Bio (left, flex 7)
// ---------------------------------------------------------------------------
class _BioBentoCell extends StatelessWidget {
  final bool isDark;
  const _BioBentoCell({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor = isDark ? AppColors.darkText2 : AppColors.lightText2;

    return _BentoCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // "👋 Hello, World" label
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('👋 ', style: TextStyle(fontSize: 12)),
              Text(
                'Hello, World',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',                         
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.flCyan,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            PortfolioData.aboutHeading,
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              height: 1.1,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            PortfolioData.aboutBody,
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: 14,
              height: 1.85,
              color: subColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cell 2 — Availability (right, flex 5)
// Has a decorative blurred circle on the left-center edge (as seen in design)
// ---------------------------------------------------------------------------
class _AvailabilityCell extends StatelessWidget {
  final bool isDark;
  const _AvailabilityCell({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor = isDark ? AppColors.darkText2 : AppColors.lightText2;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Card sits on bottom
        _BentoCard(
          isDark: isDark,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Availability badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.1),
                  border: Border.all(color: AppColors.green.withOpacity(0.35)),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _BlinkingDot(),
                    const SizedBox(width: 10),
                    const Text(
                      'Available for projects',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                PortfolioData.availabilityText,
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.5,
                  height: 1.15,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 24), 
              Text(
                PortfolioData.locationText,
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 13,
                  height: 1.7,
                  color: subColor,
                ),
              ),
              const SizedBox(height: 24), 
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Blinking dot
// ---------------------------------------------------------------------------
class _BlinkingDot extends StatefulWidget {
  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 1, end: 0.3).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
          color: AppColors.green,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cell 3 — Code snippet / philosophy (left, flex 5)
// Has a "dart" label in top-right corner of the code block (matches design)
// ---------------------------------------------------------------------------
class _CodeSnippetCell extends StatelessWidget {
  final bool isDark;
  const _CodeSnippetCell({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final codeBg = isDark ? const Color(0xFF0A1018) : const Color(0xFFEEF3FA);
    final labelColor = isDark ? AppColors.darkText3 : AppColors.lightText3;

    return _BentoCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'MY PHILOSOPHY',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              color: labelColor,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: codeBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // "dart" language label — top right, matches design screenshot
                Positioned(
                  top: 0,
                  right: 0,
                  child: Text(
                    'dart',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      color: labelColor,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CodeLine(parts: [
                      _CodePart(
                        '// Great apps = great UX + clean code',
                        color: Color(0xFF546E7A),
                        italic: true,
                      ),
                    ]),
                    SizedBox(height: 2),
                    _CodeLine(parts: [
                      _CodePart('class ', color: Color(0xFFCE93D8)),
                      _CodePart('MyApproach ', color: Color(0xFF54C5F8)),
                      _CodePart('{', color: Color(0xFFEEF2F7)),
                    ]),
                    _CodeLine(parts: [
                      _CodePart('  final ', color: Color(0xFFCE93D8)),
                      _CodePart('design = ', color: Color(0xFFEEF2F7)),
                      _CodePart("'pixel-perfect'", color: Color(0xFFFFF176)),
                      _CodePart(';', color: Color(0xFFEEF2F7)),
                    ]),
                    _CodeLine(parts: [
                      _CodePart('  final ', color: Color(0xFFCE93D8)),
                      _CodePart('arch = ', color: Color(0xFFEEF2F7)),
                      _CodePart("'clean + scalable'", color: Color(0xFFFFF176)),
                      _CodePart(';', color: Color(0xFFEEF2F7)),
                    ]),
                    _CodeLine(parts: [
                      _CodePart('  final ', color: Color(0xFFCE93D8)),
                      _CodePart('perf = ', color: Color(0xFFEEF2F7)),
                      _CodePart('60', color: Color(0xFFA5D6A7)),
                      _CodePart(';  ', color: Color(0xFFEEF2F7)),
                      _CodePart('// fps, always', color: Color(0xFF546E7A), italic: true),
                    ]),
                    SizedBox(height: 2),
                    _CodeLine(parts: [
                      _CodePart('  final ', color: Color(0xFFCE93D8)),
                      _CodePart('platforms = ', color: Color(0xFFEEF2F7)),
                      _CodePart("[", color: Color(0xFFEEF2F7)),
                      _CodePart("'iOS'", color: Color(0xFFFFF176)),
                      _CodePart(', ', color: Color(0xFFEEF2F7)),
                      _CodePart("'Android'", color: Color(0xFFFFF176)),
                      _CodePart(', ', color: Color(0xFFEEF2F7)),
                      _CodePart("'Web'", color: Color(0xFFFFF176)),
                      _CodePart(', ', color: Color(0xFFEEF2F7)),
                      _CodePart("'Desktop'", color: Color(0xFFFFF176)),
                      _CodePart('];', color: Color(0xFFEEF2F7)),
                    ]),
                    _CodeLine(parts: [
                      _CodePart('  Widget ', color: Color(0xFF54C5F8)),
                      _CodePart('build', color: Color(0xFFA5D6A7)),
                      _CodePart('() => ', color: Color(0xFFEEF2F7)),
                      _CodePart('PerfectApp', color: Color(0xFF54C5F8)),
                      _CodePart('();', color: Color(0xFFEEF2F7)),
                    ]),
                    _CodeLine(parts: [_CodePart('}', color: Color(0xFFEEF2F7))]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CodePart {
  final String text;
  final Color color;
  final bool italic;
  const _CodePart(this.text, {required this.color, this.italic = false});
}

class _CodeLine extends StatelessWidget {
  final List<_CodePart> parts;
  const _CodeLine({required this.parts});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: parts
            .map((p) => TextSpan(
                  text: p.text,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: p.color,
                    fontStyle: p.italic ? FontStyle.italic : FontStyle.normal,
                    height: 1.8,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cell 4 — Tech stack (right, flex 7)
// ---------------------------------------------------------------------------
class _StackCell extends StatelessWidget {
  final bool isDark;
  const _StackCell({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark ? AppColors.darkText3 : AppColors.lightText3;

    return _BentoCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'TECH STACK',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              color: labelColor,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PortfolioData.techStack.map((tag) {
              return _StackTag(label: tag, isDark: isDark);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _StackTag extends StatefulWidget {
  final String label;
  final bool isDark;
  const _StackTag({required this.label, required this.isDark});

  @override
  State<_StackTag> createState() => _StackTagState();
}

class _StackTagState extends State<_StackTag> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: _hovered
                  ? AppColors.flCyan
                  : (widget.isDark
                      ? AppColors.darkBorder2
                      : AppColors.lightBorder2),
            ),
            borderRadius: BorderRadius.circular(40),
            color: widget.isDark
                ? Colors.white.withOpacity(0.04)
                : Colors.white.withOpacity(0.7),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
              color: _hovered
                  ? AppColors.flCyan
                  : (widget.isDark ? AppColors.darkText2 : AppColors.lightText2),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cell 5 — Clients (full width, row 3)
// ---------------------------------------------------------------------------
class _ClientsCell extends StatelessWidget {
  final bool isDark;
  const _ClientsCell({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark ? AppColors.darkText3 : AppColors.lightText3;

    return _BentoCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'TRUSTED BY',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              color: labelColor,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: PortfolioData.clients.map((client) {
              return _ClientLogo(label: client, isDark: isDark);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ClientLogo extends StatefulWidget {
  final String label;
  final bool isDark;
  const _ClientLogo({required this.label, required this.isDark});

  @override
  State<_ClientLogo> createState() => _ClientLogoState();
}

class _ClientLogoState extends State<_ClientLogo> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hovered
                ? (widget.isDark ? AppColors.darkBorder2 : AppColors.lightBorder2)
                : (widget.isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          color: widget.isDark
              ? Colors.white.withOpacity(0.04)
              : Colors.white.withOpacity(0.8),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'Syne',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: _hovered
                ? (widget.isDark ? AppColors.darkText : AppColors.lightText)
                : (widget.isDark ? AppColors.darkText3 : AppColors.lightText3),
          ),
        ),
      ),
    );
  }
}
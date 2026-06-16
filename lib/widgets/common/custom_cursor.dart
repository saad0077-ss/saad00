import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';

// ─── Cursor State ────────────────────────────────────────────────────────────

enum CursorMode { normal, hover, click, text }

class CursorState {
  static final ValueNotifier<CursorMode> mode =
      ValueNotifier<CursorMode>(CursorMode.normal);

  /// Call this on pointer-down / pointer-up within interactive widgets
  static void setClick(bool pressing) {
    if (pressing) {
      mode.value = CursorMode.click;
    } else {
      mode.value = CursorMode.normal;
    }
  }

  /// Wrap any hoverable widget with this helper
  static Widget hoverable({required Widget child}) {
    return MouseRegion(
      onEnter: (_) => mode.value = CursorMode.hover,
      onExit: (_) => mode.value = CursorMode.normal,
      child: child,
    );
  }

  /// Wrap text fields / selectable text with this helper
  static Widget textField({required Widget child}) {
    return MouseRegion(
      onEnter: (_) => mode.value = CursorMode.text,
      onExit: (_) => mode.value = CursorMode.normal,
      child: child,
    );
  }
}

// ─── Trail Particle ──────────────────────────────────────────────────────────

class _Particle {
  Offset position;
  double opacity;
  double radius;

  _Particle({
    required this.position,
    this.opacity = 1.0,
    this.radius = 3.0,
  });
}

// ─── Custom Cursor Widget ────────────────────────────────────────────────────

class CustomCursor extends StatefulWidget {
  final Widget child;

  const CustomCursor({
    super.key,
    required this.child,
  });

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor>
    with SingleTickerProviderStateMixin {
  // Positions
  Offset _mousePos = const Offset(-200, -200);
  Offset _ringPos = const Offset(-200, -200);
  bool _inside = false;

  // Particles
  final List<_Particle> _particles = [];
  int _frameCount = 0;
  static const int _particleSpawnInterval = 2; // every N frames
  static const int _maxParticles = 18;

  // Click ripple
  bool _rippleActive = false;
  double _rippleRadius = 0;
  Offset _ripplePos = Offset.zero;

  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();

    CursorState.mode.addListener(_onModeChange);

    _ticker = createTicker((_) {
      if (!_inside) return;
      _frameCount++;

      // ── Lag ring toward mouse ──
      final dx = _mousePos.dx - _ringPos.dx;
      final dy = _mousePos.dy - _ringPos.dy;
      const lerpSpeed = 0.18;

      // ── Spawn trail particle ──
      if (_frameCount % _particleSpawnInterval == 0) {
        _particles.add(_Particle(
          position: _ringPos,
          opacity: 0.7,
          radius: 3.0 + math.Random().nextDouble() * 2,
        ));
        if (_particles.length > _maxParticles) _particles.removeAt(0);
      }

      // ── Fade particles ──
      for (final p in _particles) {
        p.opacity -= 0.06;
        p.radius *= 0.94;
      }
      _particles.removeWhere((p) => p.opacity <= 0 || p.radius < 0.3);

      // ── Ripple expand ──
      if (_rippleActive) {
        _rippleRadius += 3.5;
        if (_rippleRadius > 60) {
          _rippleActive = false;
          _rippleRadius = 0;
        }
      }

      setState(() {
        if (dx.abs() > 0.3 || dy.abs() > 0.3) {
          _ringPos = Offset(
            _ringPos.dx + dx * lerpSpeed,
            _ringPos.dy + dy * lerpSpeed,
          );
        }
      });
    });

    _ticker.start();
  }

  void _onModeChange() {
    if (CursorState.mode.value == CursorMode.click) {
      _ripplePos = _mousePos;
      _rippleRadius = 0;
      _rippleActive = true;
    }
  }

  @override
  void dispose() {
    CursorState.mode.removeListener(_onModeChange);
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (e) => setState(() {
        _inside = true;
        _mousePos = e.position;
        _ringPos = e.position;
      }),
      onExit: (_) => setState(() => _inside = false),
      onHover: (e) => _mousePos = e.position,
      child: Listener(
        onPointerDown: (_) => CursorState.setClick(true),
        onPointerUp: (_) => CursorState.setClick(false),
        child: Stack(
          children: [
            widget.child,
            if (_inside)
              ValueListenableBuilder<CursorMode>(
                valueListenable: CursorState.mode,
                builder: (context, mode, _) {
                  return IgnorePointer(
                    child: CustomPaint(
                      painter: _CursorPainter(
                        mousePos: _mousePos,
                        ringPos: _ringPos,
                        mode: mode,
                        particles: List.unmodifiable(_particles),
                        rippleActive: _rippleActive,
                        rippleRadius: _rippleRadius,
                        ripplePos: _ripplePos,
                      ),
                      size: Size.infinite,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Cursor Painter ──────────────────────────────────────────────────────────

class _CursorPainter extends CustomPainter {
  final Offset mousePos;
  final Offset ringPos;
  final CursorMode mode;
  final List<_Particle> particles;
  final bool rippleActive;
  final double rippleRadius;
  final Offset ripplePos;

  const _CursorPainter({
    required this.mousePos,
    required this.ringPos,
    required this.mode,
    required this.particles,
    required this.rippleActive,
    required this.rippleRadius,
    required this.ripplePos,
  });

  // ── Design tokens ──
  static const _cyan = Color(0xFF00E5FF);
  static const _blue = Color(0xFF2979FF);
  static const _white = Color(0xFFFFFFFF);

  @override
  void paint(Canvas canvas, Size size) {
    final bool isHover = mode == CursorMode.hover;
    final bool isClick = mode == CursorMode.click;
    final bool isText = mode == CursorMode.text;

    // ── 1. Trail particles ──────────────────────────────────────────────────
    for (final p in particles) {
      final paint = Paint()
        ..color = _cyan.withOpacity(p.opacity * 0.55)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(p.position, p.radius, paint);
    }

    // ── 2. Click ripple ─────────────────────────────────────────────────────
    if (rippleActive && rippleRadius > 0) {
      final fade = 1 - (rippleRadius / 60).clamp(0, 1);
      final ripplePaint = Paint()
        ..color = _cyan.withOpacity(fade * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(ripplePos, rippleRadius, ripplePaint);
    }

    if (isText) {
      // ── 3T. Text-cursor: I-beam style ────────────────────────────────────
      _drawTextBeam(canvas, mousePos);
      return;
    }

    // ── 3. Outer ring ───────────────────────────────────────────────────────
    final double ringSize = isClick ? 18 : (isHover ? 44 : 30);
    final ringPaint = Paint()
      ..color = (isHover ? _blue : _cyan)
          .withOpacity(isClick ? 0.15 : (isHover ? 0.45 : 0.30))
      ..style = PaintingStyle.stroke
      ..strokeWidth = isHover ? 1.0 : 1.5;

    if (isHover) {
      // Dashed ring on hover
      _drawDashedCircle(canvas, ringPos, ringSize, ringPaint, dashCount: 8);
    } else {
      canvas.drawCircle(ringPos, ringSize / 2, ringPaint);
    }

    // ── 4. Inner glow ring (hover only) ────────────────────────────────────
    if (isHover) {
      final glowPaint = Paint()
        ..color = _blue.withOpacity(0.12)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(ringPos, ringSize / 2, glowPaint);
    }

    // ── 5. Center dot ───────────────────────────────────────────────────────
    final double dotSize = isClick ? 3 : (isHover ? 5 : 4);
    final dotColor = isHover ? _blue : _cyan;

    // dot glow
    final glowDot = Paint()
      ..color = dotColor.withOpacity(0.35)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(mousePos, dotSize + 4, glowDot);

    // dot fill
    final dotPaint = Paint()
      ..color = isClick ? _white : dotColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(mousePos, dotSize, dotPaint);

    // ── 6. Crosshair lines (hover) ──────────────────────────────────────────
    if (isHover) {
      _drawCrosshairArcs(canvas, ringPos, ringSize / 2 + 6);
    }
  }

  void _drawDashedCircle(
    Canvas canvas,
    Offset center,
    double diameter,
    Paint paint, {
    int dashCount = 8,
  }) {
    final radius = diameter / 2;
    final dashAngle = (math.pi * 2) / dashCount;
    final gap = dashAngle * 0.35;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * dashAngle;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle - gap,
        false,
        paint,
      );
    }
  }

  void _drawCrosshairArcs(Canvas canvas, Offset center, double outerR) {
    const arcSpan = math.pi / 8;
    final arcPaint = Paint()
      ..color = _blue.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    final angles = [0.0, math.pi / 2, math.pi, 3 * math.pi / 2];
    for (final a in angles) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: outerR),
        a - arcSpan / 2,
        arcSpan,
        false,
        arcPaint,
      );
    }
  }

  void _drawTextBeam(Canvas canvas, Offset pos) {
    const barH = 16.0;
    const stemH = 28.0;
    const barW = 8.0;

    final paint = Paint()
      ..color = _cyan.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    // Top bar
    canvas.drawLine(
      Offset(pos.dx - barW / 2, pos.dy - stemH / 2),
      Offset(pos.dx + barW / 2, pos.dy - stemH / 2),
      paint,
    );
    // Stem
    canvas.drawLine(
      Offset(pos.dx, pos.dy - stemH / 2),
      Offset(pos.dx, pos.dy + stemH / 2),
      paint,
    );
    // Bottom bar
    canvas.drawLine(
      Offset(pos.dx - barW / 2, pos.dy + stemH / 2),
      Offset(pos.dx + barW / 2, pos.dy + stemH / 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(_CursorPainter old) => true;
}
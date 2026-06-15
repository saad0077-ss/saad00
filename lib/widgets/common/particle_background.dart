import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';


/// A particle that floats across the background canvas.
class Particle {
  double x, y, vx, vy, radius, alpha;
  Color color;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
    required this.alpha,
    required this.color,
  });
}

/// CustomPainter that draws animated floating particles with connecting lines.
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final bool isDark;

  ParticlePainter({required this.particles, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withOpacity(isDark ? p.alpha : p.alpha * 0.4);
      canvas.drawCircle(Offset(p.x, p.y), p.radius, paint);
    }

    // Draw connection lines between nearby particles
    final linePaint = Paint()..strokeWidth = 0.5;
    for (int i = 0; i < particles.length; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final dx = particles[i].x - particles[j].x;
        final dy = particles[i].y - particles[j].y;
        final dist = sqrt(dx * dx + dy * dy);
        if (dist < 90) {
          final opacity = (1 - dist / 90) * (isDark ? 0.06 : 0.03);
          linePaint.color = AppColors.flCyan.withOpacity(opacity);
          canvas.drawLine(
            Offset(particles[i].x, particles[i].y),
            Offset(particles[j].x, particles[j].y),
            linePaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(ParticlePainter old) => true;
}

/// Stateful widget that manages the particle animation loop.
class ParticleBackground extends StatefulWidget {
  final bool isDark;
  const ParticleBackground({super.key, required this.isDark});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;
  final Random _rng = Random();
  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    _particles = [];
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _controller.addListener(_tick);
  }

  void _initParticles(Size size) {
    _size = size;
    _particles = List.generate(100, (_) {
      final isBlue = _rng.nextBool();
      return Particle(
        x: _rng.nextDouble() * size.width,
        y: _rng.nextDouble() * size.height,
        vx: (_rng.nextDouble() - 0.5) * 0.25,
        vy: (_rng.nextDouble() - 0.5) * 0.25,
        radius: _rng.nextDouble() * 1.5 + 0.4,
        alpha: _rng.nextDouble() * 0.35 + 0.05,
        color: isBlue ? AppColors.flCyan : AppColors.flBlue,
      );
    });
  }

  void _tick() {
    if (_size == Size.zero) return;
    for (final p in _particles) {
      p.x += p.vx;
      p.y += p.vy;
      if (p.x < 0) p.x = _size.width;
      if (p.x > _size.width) p.x = 0;
      if (p.y < 0) p.y = _size.height;
      if (p.y > _size.height) p.y = 0;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_tick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final size = Size(constraints.maxWidth, constraints.maxHeight);
      if (_particles.isEmpty || _size != size) {
        _initParticles(size);
      }
      return CustomPaint(
        painter: ParticlePainter(particles: _particles, isDark: widget.isDark),
        child: const SizedBox.expand(),
      );
    });
  }
}

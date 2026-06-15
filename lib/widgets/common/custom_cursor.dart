import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';

/// Standalone state class to track hover state across interactive items.
class CursorState {
  static final ValueNotifier<bool> isHovering = ValueNotifier<bool>(false);
}

/// A custom lagging mouse pointer.
/// Replaces the default system cursor with a dot and a lagging outer ring.
class CustomCursor extends StatefulWidget {
  final Widget child;
  const CustomCursor({super.key, required this.child});

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor>
    with SingleTickerProviderStateMixin {
  Offset _mousePos = const Offset(-100, -100);
  Offset _ringPos = const Offset(-100, -100);
  bool _inside = false;
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    // Use a Ticker to update lagging ring position smoothly every frame
    _ticker = createTicker((_) {
      if (!_inside) return;
      final dx = _mousePos.dx - _ringPos.dx;
      final dy = _mousePos.dy - _ringPos.dy;
      if (dx.abs() > 0.05 || dy.abs() > 0.05) {
        setState(() {
          // Lerp for smooth inertia
          _ringPos = Offset(
            _ringPos.dx + dx * 0.12,
            _ringPos.dy + dy * 0.12,
          );
        });
      }
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (event) {
        setState(() {
          _inside = true;
          _mousePos = event.position;
          _ringPos = event.position;
        });
      },
      onExit: (event) {
        setState(() {
          _inside = false;
        });
      },
      onHover: (event) {
        setState(() {
          _mousePos = event.position;
        });
      },
      child: Stack(
        children: [
          // Underlying app UI
          widget.child,

          // Custom pointer overlay
          if (_inside)
            ValueListenableBuilder<bool>(
              valueListenable: CursorState.isHovering,
              builder: (context, hovered, _) {
                // Dimensions and styling based on hover state
                final dotSize = hovered ? 16.0 : 10.0;
                final ringSize = hovered ? 54.0 : 38.0;
                final dotColor = hovered ? AppColors.flBlue : AppColors.flCyan;
                final ringColor = hovered
                    ? AppColors.flBlue.withOpacity(0.5)
                    : AppColors.flCyan.withOpacity(0.35);

                return IgnorePointer(
                  child: Stack(
                    children: [
                      // Outer ring (lagging position)
                      Positioned(
                        left: _ringPos.dx - (ringSize / 2),
                        top: _ringPos.dy - (ringSize / 2),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: ringSize,
                          height: ringSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: ringColor, width: 1),
                          ),
                        ),
                      ),
                      // Central dot (exact mouse position)
                      Positioned(
                        left: _mousePos.dx - (dotSize / 2),
                        top: _mousePos.dy - (dotSize / 2),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: dotSize,
                          height: dotSize,
                          decoration: BoxDecoration(
                            color: dotColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

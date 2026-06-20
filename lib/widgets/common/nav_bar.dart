import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';


/// Top navigation bar with logo, nav links, theme toggle, and hire button.
class PortfolioNavBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDark;
  final bool isScrolled;
  final VoidCallback onThemeToggle;
  final Map<String, VoidCallback> navActions;

  const PortfolioNavBar({
    super.key,
    required this.isDark,
    required this.isScrolled,
    required this.onThemeToggle,
    required this.navActions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      height: 72,
      decoration: BoxDecoration(
        color: isScrolled
            ? (isDark
                ? const Color(0xFF080C10).withOpacity(0.85)
                : const Color(0xFFF4F7FB).withOpacity(0.9))
            : Colors.transparent,
        border: isScrolled
            ? Border(
                bottom: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Logo (Left)
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.hexagon_outlined,
                        color: AppColors.flBlue,
                        size: 34,
                      ),
                      Transform.rotate(
                        angle: 0.785, // 45 degrees
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.flBlue, AppColors.flCyan],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'saad.dev', 
                    style: TextStyle(
                      fontFamily: 'Syne',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),

            // Nav links (Center - hidden on small screens)
            if (MediaQuery.of(context).size.width > 768)
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: navActions.entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: _NavLink(label: e.key, onTap: e.value, isDark: isDark),
                    );
                  }).toList(),
                ),
              ),

            // Theme toggle & Hire Me (Right)
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: onThemeToggle,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 50,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E232C) : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? const Color(0xFF2C323D) : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Stack(
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            left: isDark ? 2 : 22,
                            top: 1.5,
                            child: Container(
                              width: 23,
                              height: 23,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.flBlue, AppColors.flCyan],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFACC15),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  _GradientButton(
                    label: 'Hire Me',
                    onTap: () {
                      navActions['contact']?.call();
                    },
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

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDark;

  const _NavLink({required this.label, required this.onTap, required this.isDark});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontFamily: 'JetBrainsMono',
            fontSize: 12,
            letterSpacing: 1,
            color: _hovered
                ? AppColors.flCyan
                : (widget.isDark ? AppColors.darkText2 : AppColors.lightText2),
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _GradientButton({required this.label, required this.onTap});

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.flBlue, AppColors.flCyan],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: AppColors.flBlue.withOpacity(_hovered ? 0.45 : 0.25),
                  blurRadius: _hovered ? 30 : 20,
                ),
              ],
            ),
            child: Text(
              widget.label,
              style: const TextStyle(
                fontFamily: 'Syne',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

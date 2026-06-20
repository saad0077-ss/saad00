import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/data/portfolio_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_portfolio/core/utils/responsive.dart';

/// Contact section — three distinct layouts for Mobile, Tablet, Desktop.
class ContactSection extends StatelessWidget {
  final bool isDark;
  const ContactSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return _MobileContact(isDark: isDark);
    } else if (Responsive.isTablet(context)) {
      return _TabletContact(isDark: isDark);
    } else {
      return _DesktopContact(isDark: isDark);
    }
  }
}

// ─────────────────────────────────────────────────
// DESKTOP — centred glowing card (original refined)
// ─────────────────────────────────────────────────
class _DesktopContact extends StatelessWidget {
  final bool isDark;
  const _DesktopContact({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg2    = isDark ? AppColors.darkBg2  : AppColors.lightBg2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText  : AppColors.lightText;
    final subColor  = isDark ? AppColors.darkText2 : AppColors.lightText2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 56),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: bg2,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(32),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(alignment: Alignment.center, children: [
          // Radial glow
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.75,
                  colors: [
                    AppColors.flBlue.withOpacity(isDark ? 0.18 : 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Decorative corner accent top-right
          Positioned(
            top: -60, right: -60,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.flCyan.withOpacity(0.10),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 88),
            child: Column(
              children: [
                // Label chip
                _LabelChip(isDark: isDark),
                const SizedBox(height: 28),
                // Heading
                Text(
                  'Ready to Build\nSomething Great?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: Responsive.scale(context, 44, 72), 
                    fontWeight: FontWeight.w800,
                    letterSpacing: -3,
                    height: 1.05,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Whether it's a startup MVP, a mobile app, or a pixel-perfect redesign —\n"
                  "I'm here for it. Let's ship something people love.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: subColor,
                    height: 1.75,
                  ),
                ),
                const SizedBox(height: 52),
                // Email CTA
                const _EmailLink(large: true),
                 const SizedBox(height: 36),
                // Social row
                 const Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _SocialBtn(label: 'GitHub', icon: FontAwesomeIcons.github, url: PortfolioData.githubUrl),
                    _SocialBtn(label: 'LinkedIn', icon: FontAwesomeIcons.linkedinIn, url: PortfolioData.linkedinUrl),
                    _SocialBtn(label: 'Twitter / X', icon: FontAwesomeIcons.xTwitter, url: PortfolioData.xUrl),
                    _SocialBtn(label: 'Instagram', icon: FontAwesomeIcons.instagram, url: PortfolioData.instagramUrl),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// TABLET — horizontal split: left text | right links
// ─────────────────────────────────────────────────
class _TabletContact extends StatelessWidget {
  final bool isDark;
  const _TabletContact({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg2      = isDark ? AppColors.darkBg2  : AppColors.lightBg2;
    final bg3      = isDark ? AppColors.darkBg3  : AppColors.lightBg3;
    final border   = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText  : AppColors.lightText;
    final subColor  = isDark ? AppColors.darkText2 : AppColors.lightText2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        decoration: BoxDecoration(
          color: bg2,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(28),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(children: [
          // Diagonal gradient accent
          Positioned(
            bottom: -80, left: -80,
            child: Container(
              width: 320, height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.flPurple.withOpacity(isDark ? 0.14 : 0.06),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            top: -60, right: 200,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.flCyan.withOpacity(isDark ? 0.12 : 0.05),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          // Content
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // LEFT — heading + email
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LabelChip(isDark: isDark),
                        const SizedBox(height: 24),
                        Text(
                          "Let's Build\nTogether.",
                          style: TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -2.5,
                            height: 1.05,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "MVP, mobile app, or pixel-perfect redesign — I'm ready. Let's ship something people love.",
                          style: TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 14,
                            height: 1.75,
                            color: subColor,
                          ),
                        ),
                        const SizedBox(height: 36),
                        _EmailLink(large: false),
                      ],
                    ),
                  ),
                ),
                // Vertical divider
                Container(
                  width: 1,
                  color: border,
                ),
                // RIGHT — social link cards grid
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(36),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FIND ME ON',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 9,
                            letterSpacing: 2.5,
                            color: AppColors.flCyan,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _TabletSocialCard(
                          isDark: isDark,
                          bg3: bg3,
                          border: border,
                          label: 'GitHub',
                          handle: '@${PortfolioData.githubUsername}',
                          url: PortfolioData.githubUrl,
                          accentColor: const Color(0xFF6E40C9),
                          icon: FontAwesomeIcons.github,
                        ),
                        const SizedBox(height: 10),
                        _TabletSocialCard(
                          isDark: isDark,
                          bg3: bg3,
                          border: border,
                          label: 'LinkedIn',
                          handle: 'Connect with me',
                          url: PortfolioData.linkedinUrl,
                          accentColor: const Color(0xFF0A66C2),
                          icon: FontAwesomeIcons.linkedinIn,
                        ),
                        const SizedBox(height: 10),
                        _TabletSocialCard(
                          isDark: isDark,
                          bg3: bg3,
                          border: border,
                          label: 'Twitter / X',
                          handle: 'Follow for updates',
                          url: PortfolioData.xUrl,
                          accentColor: const Color(0xFF1D9BF0),
                          icon: FontAwesomeIcons.xTwitter,
                        ),
                        const SizedBox(height: 10),
                        _TabletSocialCard(
                          isDark: isDark,
                          bg3: bg3,
                          border: border,
                          label: 'Instagram',
                          handle: 'Behind the scenes',
                          url: PortfolioData.instagramUrl,
                          accentColor: const Color(0xFFE1306C),
                          icon: FontAwesomeIcons.instagram,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────
// MOBILE — beautiful glassmorphic card with stacked layout
// ─────────────────────────────────────────────────
class _MobileContact extends StatelessWidget {
  final bool isDark;
  const _MobileContact({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final subColor  = isDark ? AppColors.darkText2 : AppColors.lightText2;
    final border    = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final bg2       = isDark ? AppColors.darkBg2  : AppColors.lightBg2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: bg2,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // Top-right glow
            Positioned(
              top: -40, right: -40,
              child: Container(
                width: 160, height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.flBlue.withOpacity(isDark ? 0.20 : 0.10),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
            // Bottom-left glow
            Positioned(
              bottom: -60, left: -60,
              child: Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    AppColors.flCyan.withOpacity(isDark ? 0.12 : 0.06),
                    Colors.transparent,
                  ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Top label
                  _LabelChip(isDark: isDark),
                  const SizedBox(height: 24),

                  // Gradient heading
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.flBlue, AppColors.flCyan],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: const Text(
                      "Let's Build\nSomething Great.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.5,
                        height: 1.1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    "Startup MVP, mobile app, or a redesign — I'm in.\nLet's ship something people love.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Syne',
                      fontSize: 13,
                      height: 1.7,
                      color: subColor,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Full-width Email button
                  _MobileEmailButton(isDark: isDark),
                  const SizedBox(height: 24),

                  // Divider with label
                  Row(children: [
                    Expanded(child: Container(height: 1, color: border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'FIND ME ON',
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 8,
                          letterSpacing: 2.0,
                          color: isDark ? AppColors.darkText3 : AppColors.lightText3,
                        ),
                      ),
                    ),
                    Expanded(child: Container(height: 1, color: border)),
                  ]),
                  const SizedBox(height: 20),

                  // Social cards — 2x2 grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.55,
                    children: [
                      _MobileSocialCard(
                        isDark: isDark,
                        label: 'GitHub',
                        url: PortfolioData.githubUrl,
                        accentColor: const Color(0xFF6E40C9),
                        icon: FontAwesomeIcons.github,
                      ),
                      _MobileSocialCard(
                        isDark: isDark,
                        label: 'LinkedIn',
                        url: PortfolioData.linkedinUrl,
                        accentColor: const Color(0xFF0A66C2),
                        icon: FontAwesomeIcons.linkedinIn,
                      ),
                      _MobileSocialCard(
                        isDark: isDark,
                        label: 'Twitter / X',
                        url: PortfolioData.xUrl,
                        accentColor: const Color(0xFF1D9BF0),
                        icon: FontAwesomeIcons.xTwitter,
                      ),
                      _MobileSocialCard(
                        isDark: isDark,
                        label: 'Instagram',
                        url: PortfolioData.instagramUrl,
                        accentColor: const Color(0xFFE1306C),
                        icon: FontAwesomeIcons.instagram,
                      ),
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
}

// ─────────────────────────────────────────────────
// SHARED WIDGETS
// ─────────────────────────────────────────────────

/// Small pill label above heading
class _LabelChip extends StatelessWidget {
  final bool isDark;
  const _LabelChip({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.flCyan.withOpacity(0.3)),
        color: AppColors.flCyan.withOpacity(0.07),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6, height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.flCyan,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'OPEN TO WORK',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              letterSpacing: 2,
              color: AppColors.flCyan,
            ),
          ),
        ],
      ),
    );
  }
}

/// Email link widget — scales between compact and large
class _EmailLink extends StatefulWidget {
  final bool large;
  const _EmailLink({this.large = true});

  @override
  State<_EmailLink> createState() => _EmailLinkState();
}

class _EmailLinkState extends State<_EmailLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri(scheme: 'mailto', path: PortfolioData.email);
          if (await canLaunchUrl(uri)) await launchUrl(uri);
        },
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontFamily: 'Syne',
            fontSize: widget.large
                ? Responsive.scale(context, 20, 36)
                : 18,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: _hovered ? AppColors.flCyan : const Color(0xFF7A8899),
            decoration: _hovered ? TextDecoration.underline : TextDecoration.none,
            decorationColor: AppColors.flCyan,
          ),
          child: const Text(PortfolioData.email),
        ),
      ),
    );
  }
}

/// Full-width email button for Mobile
class _MobileEmailButton extends StatefulWidget {
  final bool isDark;
  const _MobileEmailButton({required this.isDark});

  @override
  State<_MobileEmailButton> createState() => _MobileEmailButtonState();
}

class _MobileEmailButtonState extends State<_MobileEmailButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp:   (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () async {
        final uri = Uri(scheme: 'mailto', path: PortfolioData.email);
        if (await canLaunchUrl(uri)) await launchUrl(uri);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        transform: _pressed
            ? (Matrix4.identity()..scale(0.97))
            : Matrix4.identity(),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [AppColors.flBlue, AppColors.flCyan],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.flBlue.withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(FontAwesomeIcons.envelope, color: Colors.white, size: 16),
            SizedBox(width: 10),
            Text(
              PortfolioData.email,
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Social button for Desktop (pill style)
class _SocialBtn extends StatefulWidget {
  final String label;
  final dynamic icon;
  final String url;
  const _SocialBtn({required this.label, required this.icon, required this.url});

  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: _hovered ? AppColors.flCyan : Colors.white.withOpacity(0.12),
            ),
            borderRadius: BorderRadius.circular(40),
            color: _hovered ? AppColors.flCyan.withOpacity(0.08) : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                widget.icon ,
                size: 14,
                color: _hovered ? AppColors.flCyan : const Color(0xFF7A8899),
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: _hovered ? AppColors.flCyan : const Color(0xFF7A8899),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 4),
              AnimatedSlide(
                duration: const Duration(milliseconds: 200),
                offset: _hovered ? const Offset(0.15, -0.15) : Offset.zero,
                child: Text(
                  '↗',
                  style: TextStyle(
                    fontSize: 11,
                    color: _hovered ? AppColors.flCyan : const Color(0xFF7A8899),
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

/// Social card for Tablet (horizontal row card)
class _TabletSocialCard extends StatefulWidget {
  final bool isDark;
  final Color bg3;
  final Color border;
  final String label;
  final String handle;
  final String url;
  final Color accentColor;
  final dynamic icon;

  const _TabletSocialCard({
    required this.isDark,
    required this.bg3,
    required this.border,
    required this.label,
    required this.handle,
    required this.url,
    required this.accentColor,
    required this.icon,
  });

  @override
  State<_TabletSocialCard> createState() => _TabletSocialCardState();
}

class _TabletSocialCardState extends State<_TabletSocialCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: _hovered
                ? widget.accentColor.withOpacity(0.08)
                : widget.bg3,
            border: Border.all(
              color: _hovered ? widget.accentColor.withOpacity(0.4) : widget.border,
            ),
          ),
          child: Row(
            children: [
              // Icon circle
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.accentColor.withOpacity(0.12),
                ),
                alignment: Alignment.center,
                child: FaIcon(
                  widget.icon ,
                  size: 16,
                  color: widget.accentColor,
                ),
              ),
              const SizedBox(width: 12),
              // Labels
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: widget.isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    Text(
                      widget.handle,
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 9,
                        color: widget.isDark ? AppColors.darkText3 : AppColors.lightText3,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow
              AnimatedSlide(
                duration: const Duration(milliseconds: 200),
                offset: _hovered ? const Offset(0.2, 0) : Offset.zero,
                child: Text(
                  '→',
                  style: TextStyle(
                    color: _hovered ? widget.accentColor : (widget.isDark ? AppColors.darkText3 : AppColors.lightText3),
                    fontSize: 16,
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

/// Social card for Mobile (2×2 grid cell) — enhanced with FA icons
class _MobileSocialCard extends StatefulWidget {
  final bool isDark;
  final String label;
  final String url;
  final Color accentColor;
  final dynamic icon;

  const _MobileSocialCard({
    required this.isDark,
    required this.label,
    required this.url,
    required this.accentColor,
    required this.icon,
  });

  @override
  State<_MobileSocialCard> createState() => _MobileSocialCardState();
}

class _MobileSocialCardState extends State<_MobileSocialCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark ? AppColors.darkBg3 : AppColors.lightBg3;
    final border = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return GestureDetector(
      onTapDown:    (_) => setState(() => _pressed = true),
      onTapUp:      (_) => setState(() => _pressed = false),
      onTapCancel:  () => setState(() => _pressed = false),
      onTap: () async {
        final uri = Uri.parse(widget.url);
        if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        transform: _pressed
            ? (Matrix4.identity()..scale(0.95))
            : Matrix4.identity(),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: _pressed
              ? widget.accentColor.withOpacity(0.10)
              : bg,
          border: Border.all(
            color: _pressed ? widget.accentColor.withOpacity(0.45) : border,
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon in styled circle
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    widget.accentColor.withOpacity(0.20),
                    widget.accentColor.withOpacity(0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: FaIcon(
                widget.icon ,
                size: 16,
                color: widget.accentColor,
              ),
            ),
            // Label + arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontFamily: 'Syne',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: widget.isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.arrowUpRightFromSquare,
                  size: 10,
                  color: widget.accentColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

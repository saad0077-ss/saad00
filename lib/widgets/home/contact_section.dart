import 'package:flutter/material.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/data/portfolio_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_portfolio/core/utils/responsive.dart';

/// Contact section with email link and social buttons.
class ContactSection extends StatelessWidget {
  final bool isDark;
  const ContactSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg2 = isDark ? AppColors.darkBg2 : AppColors.lightBg2;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor = isDark ? AppColors.darkText2 : AppColors.lightText2;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 0),
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: bg2,
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(32),
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(alignment: Alignment.center, children: [
              // Background radial glow effect
              Positioned(
                top: -100,
                bottom: -100,
                left: -100,
                right: -100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 0.7,
                      colors: [
                        AppColors.flBlue.withOpacity(isDark ? 0.18 : 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(80),
                child: Column(
                  children: [
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
                    const SizedBox(height: 16),
                    Text(
                      "Whether it's a startup MVP, a mobile app, or a pixel-perfect redesign —\n"
                      "I'm here for it. Let's ship something people love.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: subColor,
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Email link
                    _EmailLink(),
                    const SizedBox(height: 32),

                    // Social buttons
                    const Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        _SocialBtn(label: 'GitHub ↗', url: PortfolioData.githubUrl),
                        _SocialBtn(label: 'LinkedIn ↗', url: PortfolioData.linkedinUrl),
                        _SocialBtn(label: 'Twitter / X ↗', url: PortfolioData.xUrl),
                        _SocialBtn(label: 'Instagram ↗', url: PortfolioData.instagramUrl),
                      ],
                    ),
                  ],
                ),
              ),
            ])));
  }
}

class _EmailLink extends StatefulWidget {
  @override
  State<_EmailLink> createState() => _EmailLinkState();
}

class _EmailLinkState extends State<_EmailLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          final Uri uri = Uri(scheme: 'mailto', path: PortfolioData.email);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontFamily: 'Syne',
            fontSize: Responsive.scale(context, 20, 36),
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: _hovered ? AppColors.flCyan : const Color(0xFF7A8899),
            decoration:
                _hovered ? TextDecoration.underline : TextDecoration.none,
            decorationColor: AppColors.flCyan,
          ),
          child: Text(PortfolioData.email),
        ),
      ),
    );
  }
}

class _SocialBtn extends StatefulWidget {
  final String label;
  final String url;
  const _SocialBtn({required this.label, required this.url});

  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          final Uri uri = Uri.parse(widget.url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  _hovered ? AppColors.flCyan : Colors.white.withOpacity(0.12),
            ),
            borderRadius: BorderRadius.circular(40),
            color: _hovered
                ? AppColors.flCyan.withOpacity(0.08)
                : Colors.transparent,
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: _hovered ? AppColors.flCyan : const Color(0xFF7A8899),
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

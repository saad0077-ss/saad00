import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_portfolio/core/constants/app_colors.dart';
import 'package:my_portfolio/core/utils/responsive.dart';

/// Projects section — modern card grid matching HTML design.
class ProjectsSection extends StatelessWidget {
  final bool isDark;
  const ProjectsSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final subColor = isDark ? AppColors.darkText2 : AppColors.lightText2;

    // Responsive horizontal padding matching Saad's portfolio style but safely scaling
    final screenWidth = MediaQuery.of(context).size.width;
    final paddingX = screenWidth > 1200
        ? 250.0
        : screenWidth > 800
            ? 120.0
            : screenWidth > 600
                ? 48.0
                : 24.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with padding
        Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingX),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SELECTED WORK',
                style: TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.5,
                  color: AppColors.flCyan,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Projects That\nShipped.',
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: Responsive.scale(context, 40, 64),
                  fontWeight: FontWeight.w800,
                  letterSpacing: -2.5,
                  height: 1.05,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Real apps. Real users. Real impact across every platform Flutter touches.',
                style: TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: subColor,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 64),
            ],
          ),
        ),

        // Horizontal scrollable carousel spanning full width edge-to-edge
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = screenWidth > 900;
            final cardWidth = isWide
                ? 750.0
                : (screenWidth < 460 ? screenWidth - 32.0 : 420.0);

            return _ContinuousHorizontalScroll(
              cardWidth: cardWidth,
              isDark: isDark,
              isWide: isWide,
            );
          },
        ),
        const SizedBox(height: 120),
      ],
    );
  }
}

/// Continuous horizontal scrolling carousel widget
class _ContinuousHorizontalScroll extends StatefulWidget {
  final double cardWidth;
  final bool isDark;
  final bool isWide;

  const _ContinuousHorizontalScroll({
    required this.cardWidth,
    required this.isDark,
    required this.isWide,
  });

  @override
  State<_ContinuousHorizontalScroll> createState() => _ContinuousHorizontalScrollState();
}

class _ContinuousHorizontalScrollState extends State<_ContinuousHorizontalScroll>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late Ticker _ticker; 
  double _scrollOffset = 0.0;
  double _currentSpeed = 35.0; // pixels per second
  double _targetSpeed = 35.0; // pixels per second
  Duration _lastElapsedTime = Duration.zero;
  static const double _spacing = 20.0;

  final List<_ProjectData> projects = [ 
    _ProjectData(
      number: '001 · FEATURED',
      title: 'CreamVentory\nInventory App',
      description:
          'A smart inventory management app for cream & cosmetics businesses. Track stock, manage products, monitor sales, and get low-stock alerts — all in a clean, intuitive Flutter interface.',
      tags: const ['Flutter', 'Hive', 'Riverpod', 'Dart','Animation'],
      platforms: const ['Android', 'iOS','Web'],
      isFeatured: true,
      accentColor: const Color(0xFFF59E0B),
      accentColor2: const Color(0xFFFCD34D), 
      glowColor: const Color(0x2EF59E0B),
      bgGradient: const LinearGradient(
        colors: [Color(0xFF1A0F00), Color(0xFF261600)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      stats: const [
        {'value': '100%', 'label': 'OFFLINE READY'},
        {'value': 'Real-time', 'label': 'STOCK SYNC'},
        {'value': '2', 'label': 'PLATFORMS'},
      ],
      url: 'https://creamventory-07.web.app/',
      deviceMockBuilder: (isHovered) => _CreamVentoryMock(isHovered: isHovered),
    ),
    _ProjectData(
      number: '002',
      title: 'Grade Calculator',
      description:
          'A student-focused grade calculator app that computes GPA, predicts semester outcomes, and visualises academic progress with clean charts and subject-wise breakdowns.',
      tags: const ['Flutter', 'Dart', 'Charts', 'SharedPreferences','Hive'],
      platforms: const ['Android', 'Web','Windows'],
      isFeatured: false,
      accentColor: const Color(0xFF7C4DFF),
      accentColor2: const Color(0xFFA78BFA),
      glowColor: const Color(0x267C4DFF),
      bgGradient: const LinearGradient(
        colors: [Color(0xFF0B0618), Color(0xFF120A24)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      deviceMockBuilder: (isHovered) => _GradeCalculatorMock(isHovered: isHovered),
    ),   
    _ProjectData(
      number: '003',
      title: 'TrainGo — Train Booking',
      description:
          'A full-featured train ticket booking app with real-time seat availability, route search, PNR tracking, and seamless payment integration. Currently under active development.',
      tags: const ['Flutter', 'Firebase', 'REST API', 'Razorpay'],
      platforms: const ['Android', 'iOS','Windows','Web'],
      isFeatured: false,
      statusBadge: const _InDevelopmentBadge(),
      accentColor: const Color(0xFF027DFD),
      accentColor2: const Color(0xFF54C5F8),
      glowColor: const Color(0x26027DFD),
      bgGradient: const LinearGradient(
        colors: [Color(0xFF031014), Color(0xFF050F1C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      deviceMockBuilder: (isHovered) => _TrainGoMock(isHovered: isHovered),
    ),
  ];

  double _getCardWidth(_ProjectData project) {
    double baseW = project.isFeatured
        ? (widget.isWide ? 950.0 : 480.0)
        : widget.cardWidth;

    // Calculate dynamic extra width based on content size to avoid overflow
    final int textLength = project.description.length + project.title.length;
    final int threshold = project.isFeatured ? 250 : 180;
    
    if (textLength > threshold) {
      baseW += ((textLength - threshold) / 50).ceil() * 60.0;
    }

    // Account for extra stats in featured projects
    if (project.isFeatured && project.stats != null && project.stats!.length > 3) {
      baseW += (project.stats!.length - 3) * 120.0;
    }

    // Clamp width on mobile/tablet viewports to fit the screen
    if (!widget.isWide) {
      final screenWidth = MediaQuery.of(context).size.width;
      if (baseW > screenWidth - 32.0) {
        baseW = screenWidth - 32.0;
      }
    }

    return baseW;
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _ticker = createTicker((elapsed) {
      if (!mounted || !_scrollController.hasClients) return;
      if (_lastElapsedTime == Duration.zero) {
        _lastElapsedTime = elapsed;
        return;
      }
      final double deltaTime = (elapsed - _lastElapsedTime).inMicroseconds / 1000000.0;
      _lastElapsedTime = elapsed;

      // Smoothly interpolate current speed towards target speed for deceleration/acceleration
      _currentSpeed = _currentSpeed + (_targetSpeed - _currentSpeed) * 0.1;

      if (_currentSpeed.abs() > 0.01) {
        _scrollOffset += _currentSpeed * deltaTime;
        
        double singleSetWidth = 0.0;
        for (final project in projects) {
          singleSetWidth += _getCardWidth(project) + _spacing;
        }
        
        while (_scrollOffset >= singleSetWidth) {
          _scrollOffset -= singleSetWidth;
        }
        while (_scrollOffset < 0) {
          _scrollOffset += singleSetWidth;
        }

        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollOffset);
        }
      }
    });

    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _targetSpeed = 0.0;
        });
      },
      onExit: (_) {
        setState(() {
          _targetSpeed = 35.0;
        });
      },
      child: SizedBox(
        height: widget.isWide ? 530 : 600,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          physics: const NeverScrollableScrollPhysics(), // Disable manual scroll
          child: Row(
            children: [
              // First pass
              ...projects.map((project) {
                final cardW = _getCardWidth(project);
                return Padding(
                  padding: const EdgeInsets.only(right: _spacing),
                  child: SizedBox(
                    width: cardW,
                    height: widget.isWide ? 530 : 600,
                    child: _ProjectCard(
                      number: project.number,
                      title: project.title,
                      description: project.description,
                      tags: project.tags,
                      platforms: project.platforms,
                      isDark: widget.isDark,
                      isFeatured: project.isFeatured,
                      statusBadge: project.statusBadge,
                      accentColor: project.accentColor,
                      accentColor2: project.accentColor2,
                      glowColor: project.glowColor,
                      bgGradient: project.bgGradient,
                      stats: project.stats,
                      isWide: widget.isWide,
                      deviceMockBuilder: project.deviceMockBuilder,
                    ),
                  ),
                );
              }),
              // Second pass (for infinite loop effect)
              ...projects.map((project) {
                final cardW = _getCardWidth(project);
                return Padding(
                  padding: const EdgeInsets.only(right: _spacing),
                  child: SizedBox(
                    width: cardW,
                    height: widget.isWide ? 530 : 600,
                    child: _ProjectCard(
                      number: project.number,
                      title: project.title,
                      description: project.description,
                      tags: project.tags,
                      platforms: project.platforms,
                      isDark: widget.isDark,
                      isFeatured: project.isFeatured,
                      statusBadge: project.statusBadge,
                      accentColor: project.accentColor,
                      accentColor2: project.accentColor2,
                      glowColor: project.glowColor,
                      bgGradient: project.bgGradient,
                      stats: project.stats,
                      isWide: widget.isWide,
                      deviceMockBuilder: project.deviceMockBuilder,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// Project data model
class _ProjectData {
  final String number;
  final String title;
  final String description;
  final List<String> tags;
  final List<String> platforms;
  final bool isFeatured;
  final Widget? statusBadge;
  final Color accentColor;
  final Color accentColor2;
  final Color glowColor;
  final LinearGradient bgGradient;
  final List<Map<String, String>>? stats;
  final Widget Function(bool isHovered) deviceMockBuilder;
  final String? url;

  _ProjectData({
    required this.number,
    required this.title,
    required this.description,
    required this.tags,
    required this.platforms,
    required this.isFeatured,
    this.statusBadge,
    required this.accentColor,
    required this.accentColor2,
    required this.glowColor,
    required this.bgGradient,
    this.stats,
    required this.deviceMockBuilder,
    this.url,
  });
}

/// Project Card Widget with hover micro-interactions
class _ProjectCard extends StatefulWidget {
  final String number;
  final String title;
  final String description;
  final List<String> tags;
  final List<String> platforms;
  final bool isDark;
  final bool isFeatured;
  final Widget? statusBadge;
  final Color accentColor;
  final Color accentColor2;
  final Color glowColor;
  final LinearGradient bgGradient;
  final List<Map<String, String>>? stats;
  final bool isWide;
  final Widget Function(bool isHovered) deviceMockBuilder;

  const _ProjectCard({
    required this.number,
    required this.title,
    required this.description,
    required this.tags,
    required this.platforms,
    required this.isDark,
    required this.isFeatured,
    this.statusBadge,
    required this.accentColor,
    required this.accentColor2,
    required this.glowColor,
    required this.bgGradient,
    this.stats,
    required this.isWide,
    required this.deviceMockBuilder,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bg2 = widget.isDark ? AppColors.darkBg2 : AppColors.lightBg2;
    final border = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final hoverBorder = widget.isDark ? AppColors.darkBorder2 : AppColors.lightBorder2;

    // Info component
    final infoWidget = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isFeatured ? (widget.isWide ? 36.0 : 28.0) : 24.0,
        vertical: widget.isFeatured ? (widget.isWide ? 28.0 : 20.0) : 18.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.number,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2.0,
                      color: AppColors.flCyan,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 4,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontFamily: 'Syne',
                          fontSize: widget.isFeatured ? (widget.isWide ? 30 : 24) : 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: widget.isFeatured ? -1.2 : -0.6,
                          height: 1.15,
                          color: widget.isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      if (widget.statusBadge != null) widget.statusBadge!,
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontFamily: 'Syne',
                      fontSize: widget.isFeatured ? 13 : 12,
                      height: 1.6,
                      color: widget.isDark ? AppColors.darkText2 : AppColors.lightText2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.tags
                        .map((tag) => _TagWidget(
                              tag: tag,
                              isDark: widget.isDark,
                              isHovered: _hovered,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          if (widget.isFeatured && widget.stats != null) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 20,
              runSpacing: 10,
              children: widget.stats!.map((stat) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [widget.accentColor, widget.accentColor2],
                      ).createShader(bounds),
                      child: Text(
                        stat['value'] ?? '',
                        style: const TextStyle(
                          fontFamily: 'Syne',
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                          color: Colors.white, // essential for shader
                        ),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      stat['label'] ?? '',
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 9,
                        letterSpacing: 1,
                        color: widget.isDark ? AppColors.darkText3 : AppColors.lightText3,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 16),
          // Footer border-top
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: widget.isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: widget.platforms
                      .map((p) => _PlatformPill(
                            platform: p,
                            isDark: widget.isDark,
                            isHovered: _hovered,
                          ))
                      .toList(),
                ),
                _CTAWidget(
                  isFeatured: widget.isFeatured,
                  isHovered: _hovered,
                  isDark: widget.isDark,
                  accentColor: widget.accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Visual Showcase component
    final visualWidget = Container(
      decoration: BoxDecoration(
        gradient: widget.bgGradient,
      ),
      child: Stack(
        children: [
          // Pulse Mesh background
          Positioned.fill(
            child: _MeshBackground(
              accent1: widget.accentColor,
              accent2: widget.accentColor2,
            ),
          ),
          // Glow layer fading in on hover
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: _hovered ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topLeft,
                    radius: 0.65,
                    colors: [
                      widget.glowColor,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Device showcase
          Positioned.fill(
            child: ClipRect(
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: widget.deviceMockBuilder(_hovered),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return MouseRegion(
      cursor: widget.project.url != null ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          if (widget.project.url != null) {
            final uri = Uri.parse(widget.project.url!);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: bg2,
            border: Border.all(
              color: _hovered ? hoverBorder : border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 80,
                      offset: const Offset(0, 30),
                    )
                  ]
                : [],
          ),
          clipBehavior: Clip.antiAlias,
          child: widget.isFeatured
              ? (widget.isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: infoWidget),
                        Expanded(child: visualWidget),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(flex: 4, child: visualWidget),
                        Expanded(flex: 6, child: infoWidget),
                      ],
                    ))
              : Column(
                  children: [
                    Expanded(flex: 4, child: visualWidget),
                    Expanded(flex: 5, child: infoWidget),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Dynamic, pulsing mesh background using repeating animation controller
class _MeshBackground extends StatefulWidget {
  final Color accent1;
  final Color accent2;
  const _MeshBackground({required this.accent1, required this.accent2});

  @override
  State<_MeshBackground> createState() => _MeshBackgroundState();
}

class _MeshBackgroundState extends State<_MeshBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.04).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(-0.4, 0.2), // circle at 30% 50% approx
                        radius: 0.65,
                        colors: [
                          widget.accent1.withOpacity(0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.6, -0.6), // circle at 80% 20% approx
                        radius: 0.55,
                        colors: [
                          widget.accent2.withOpacity(0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Animated Bar widget that slightly updates height dynamically to feel alive
class _AnimatedBar extends StatefulWidget {
  final double initialHeightFactor;
  final Gradient? gradient;
  final Color? color;
  const _AnimatedBar({required this.initialHeightFactor, this.gradient, this.color});

  @override
  State<_AnimatedBar> createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<_AnimatedBar> {
  late double _heightFactor;

  @override
  void initState() {
    super.initState();
    _heightFactor = widget.initialHeightFactor;
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(
      Duration(milliseconds: 1500 + (2000 * (1.0 - widget.initialHeightFactor)).toInt()),
      () {
        if (mounted) {
          setState(() {
            // Animates heights randomly between 20% and 95%
            _heightFactor = 0.2 + (0.75 * (0.2 + 0.8 * widget.initialHeightFactor));
            if (_heightFactor > 0.98) _heightFactor = 0.98;
            if (_heightFactor < 0.2) _heightFactor = 0.2;
          });
          _startTimer();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        height: double.infinity,
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: _heightFactor,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
              gradient: widget.gradient,
              color: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}

/// Common Phone mockup chassis widget
class _PhoneMockChassis extends StatelessWidget {
  final bool isHovered;
  final Color accentColor;
  final Color accentColor2;
  final Widget child;

  const _PhoneMockChassis({
    required this.isHovered,
    required this.accentColor,
    required this.accentColor2,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final phoneMatrix = isHovered
        ? (Matrix4.identity()..scale(1.05))
        : (Matrix4.identity()..rotateZ(-4 * 3.14159 / 180));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      transform: phoneMatrix,
      transformAlignment: Alignment.center,
      width: 90,
      height: 175,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.14), width: 1.5),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E2940), Color(0xFF111827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.06),
            blurRadius: 0.5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: child,
      ),
    );
  }
}

/// Common Tablet mockup chassis widget
class _TabletMockup extends StatelessWidget {
  final bool isHovered;
  final Color accentColor;
  final Color accentColor2;

  const _TabletMockup({
    required this.isHovered,
    required this.accentColor,
    required this.accentColor2,
  });

  @override
  Widget build(BuildContext context) {
    final tabletMatrix = isHovered
        ? (Matrix4.identity()
          ..translate(-14.0, 14.0)
          ..scale(1.04))
        : (Matrix4.identity()
          ..translate(-20.0, 20.0)
          ..rotateZ(2 * 3.14159 / 180));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      transform: tabletMatrix,
      transformAlignment: Alignment.center,
      width: 130,
      height: 95,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.0),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E2940), Color(0xFF111827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 45,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: accentColor.withOpacity(0.3),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  flex: 25,
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white.withOpacity(0.06),
                    ),
                  ),
                ),
                const Spacer(flex: 30),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _AnimatedBar(initialHeightFactor: 0.40, color: accentColor.withOpacity(0.15)),
                    _AnimatedBar(
                      initialHeightFactor: 0.65,
                      gradient: LinearGradient(
                        colors: [accentColor, accentColor2],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    _AnimatedBar(initialHeightFactor: 0.48, color: accentColor.withOpacity(0.15)),
                    _AnimatedBar(
                      initialHeightFactor: 0.88,
                      gradient: LinearGradient(
                        colors: [accentColor, accentColor2],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    _AnimatedBar(initialHeightFactor: 0.35, color: accentColor.withOpacity(0.15)),
                    _AnimatedBar(
                      initialHeightFactor: 0.72,
                      gradient: LinearGradient(
                        colors: [accentColor, accentColor2],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    _AnimatedBar(initialHeightFactor: 0.58, color: accentColor.withOpacity(0.15)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Overlapping mockup view for CreamVentory
class _CreamVentoryMock extends StatelessWidget {
  final bool isHovered;
  const _CreamVentoryMock({required this.isHovered});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFF59E0B);
    const accentColor2 = Color(0xFFFCD34D);

    return SizedBox(
      width: 180,
      height: 175,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Tablet mockup on the back
          Positioned(
            left: -10,
            bottom: 25,
            child: _TabletMockup(
              isHovered: isHovered,
              accentColor: accentColor,
              accentColor2: accentColor2,
            ),
          ),
          // Phone mockup overlapping in front
          Positioned(
            right: -10,
            child: _PhoneMockChassis(
              isHovered: isHovered,
              accentColor: accentColor,
              accentColor2: accentColor2,
              child: Column(
                children: [
                  Container(
                    width: 32,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              gradient: const LinearGradient(colors: [accentColor, accentColor2]),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            height: 44,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: const LinearGradient(colors: [accentColor, accentColor2]),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'TOTAL STOCK',
                                  style: TextStyle(
                                    fontFamily: 'JetBrainsMono',
                                    fontSize: 4,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  '248 items',
                                  style: TextStyle(
                                    fontFamily: 'Syne',
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 24,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.white.withOpacity(0.05),
                                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: accentColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Container(
                                  height: 24,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    color: Colors.white.withOpacity(0.05),
                                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: accentColor2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 22,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _AnimatedBar(initialHeightFactor: 0.40, color: accentColor.withOpacity(0.18)),
                                const _AnimatedBar(
                                  initialHeightFactor: 0.78,
                                  gradient: LinearGradient(
                                    colors: [accentColor, accentColor2],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                _AnimatedBar(initialHeightFactor: 0.52, color: accentColor.withOpacity(0.18)),
                                const _AnimatedBar(
                                  initialHeightFactor: 0.92,
                                  gradient: LinearGradient(
                                    colors: [accentColor, accentColor2],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                _AnimatedBar(initialHeightFactor: 0.44, color: accentColor.withOpacity(0.18)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          _MockListItem(dotColor: accentColor, lineFraction: 0.8),
                          _MockListItem(dotColor: accentColor2, lineFraction: 0.7),
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
    );
  }
}

/// Phone mockup view for Grade Calculator
class _GradeCalculatorMock extends StatelessWidget {
  final bool isHovered;
  const _GradeCalculatorMock({required this.isHovered});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF7C4DFF);
    const accentColor2 = Color(0xFFA78BFA);

    return _PhoneMockChassis(
      isHovered: isHovered,
      accentColor: accentColor,
      accentColor2: accentColor2,
      child: Column(
        children: [
          Container(
            width: 32,
            height: 7,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: const LinearGradient(colors: [accentColor, accentColor2]),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 44,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(colors: [accentColor, accentColor2]),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'CURRENT GPA',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 4,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          '3.87 ✦',
                          style: TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white.withOpacity(0.05),
                            border: Border.all(color: Colors.white.withOpacity(0.06)),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: accentColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white.withOpacity(0.05),
                            border: Border.all(color: Colors.white.withOpacity(0.06)),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: accentColor2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 22,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _AnimatedBar(initialHeightFactor: 0.60, color: accentColor.withOpacity(0.18)),
                        const _AnimatedBar(
                          initialHeightFactor: 0.90,
                          gradient: LinearGradient(
                            colors: [accentColor, accentColor2],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        _AnimatedBar(initialHeightFactor: 0.75, color: accentColor.withOpacity(0.18)),
                        const _AnimatedBar(
                          initialHeightFactor: 0.85,
                          gradient: LinearGradient(
                            colors: [accentColor, accentColor2],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        _AnimatedBar(initialHeightFactor: 0.50, color: accentColor.withOpacity(0.18)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const _MockListItem(dotColor: accentColor, lineFraction: 0.75),
                  const _MockListItem(dotColor: accentColor2, lineFraction: 0.65),
                  _MockListItem(dotColor: accentColor.withOpacity(0.5), lineFraction: 0.80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Phone mockup view for TrainGo
class _TrainGoMock extends StatelessWidget {
  final bool isHovered;
  const _TrainGoMock({required this.isHovered});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFF027DFD);
    const accentColor2 = Color(0xFF54C5F8);

    return _PhoneMockChassis(
      isHovered: isHovered,
      accentColor: accentColor,
      accentColor2: accentColor2,
      child: Column(
        children: [
          Container(
            width: 32,
            height: 7,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(6)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      gradient: const LinearGradient(colors: [accentColor, accentColor2]),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 44,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(colors: [accentColor, accentColor2]),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'NEXT TRAIN',
                          style: TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontSize: 4,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          '🚆 14:32',
                          style: TextStyle(
                            fontFamily: 'Syne',
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white.withOpacity(0.05),
                            border: Border.all(color: Colors.white.withOpacity(0.06)),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: accentColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white.withOpacity(0.05),
                            border: Border.all(color: Colors.white.withOpacity(0.06)),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: accentColor2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  _MockListItem(dotColor: accentColor, lineFraction: 0.8),
                  _MockListItem(dotColor: accentColor2, lineFraction: 0.75),
                  _MockListItem(dotColor: accentColor.withOpacity(0.5), lineFraction: 0.55),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Simulated mock list item inside phones
class _MockListItem extends StatelessWidget {
  final Color dotColor;
  final double lineFraction;

  const _MockListItem({required this.dotColor, required this.lineFraction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 3),
      height: 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: Colors.white.withOpacity(0.04),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: lineFraction,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: Colors.white.withOpacity(0.07),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tag widget inside info card
class _TagWidget extends StatelessWidget {
  final String tag;
  final bool isDark;
  final bool isHovered;
  const _TagWidget({required this.tag, required this.isDark, required this.isHovered});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHovered
              ? AppColors.flCyan.withOpacity(0.25)
              : (isDark ? AppColors.darkBorder2 : AppColors.lightBorder2),
        ),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 9,
          letterSpacing: 0.4,
          color: isHovered
              ? AppColors.flCyan
              : (isDark ? AppColors.darkText3 : AppColors.lightText3),
        ),
      ),
    );
  }
}

/// Platform pill inside footer
class _PlatformPill extends StatelessWidget {
  final String platform;
  final bool isDark;
  final bool isHovered;
  const _PlatformPill({required this.platform, required this.isDark, required this.isHovered});

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    if (platform.toLowerCase() == 'android') {
      dotColor = const Color(0xFF3DDC84);
    } else if (platform.toLowerCase() == 'ios') {
      dotColor = const Color(0xFFA2AAAD);
    } else if (platform.toLowerCase() == 'web') {
      dotColor = const Color(0xFF4FC3F7);
    } else {
      dotColor = const Color(0xFFCE93D8);
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border.all(
          color: isHovered
              ? (isDark ? AppColors.darkBorder2 : AppColors.lightBorder2)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            platform,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 9,
              letterSpacing: 0.3,
              color: isHovered
                  ? (isDark ? AppColors.darkText2 : AppColors.lightText2)
                  : (isDark ? AppColors.darkText3 : AppColors.lightText3),
            ),
          ),
        ],
      ),
    );
  }
}

/// Case Study / Project CTA Arrow widget
class _CTAWidget extends StatelessWidget {
  final bool isFeatured;
  final bool isHovered;
  final bool isDark;
  final Color accentColor;

  const _CTAWidget({
    required this.isFeatured,
    required this.isHovered,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isFeatured) ...[
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: isHovered
                  ? AppColors.flCyan
                  : (isDark ? AppColors.darkText3 : AppColors.lightText3),
            ),
            child: const Text('VIEW CASE STUDY'),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: isHovered ? 12 : 8,
          ),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isHovered ? AppColors.flBlue : Colors.transparent,
            border: Border.all(
              color: isHovered
                  ? AppColors.flBlue
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          child: Center(
            child: AnimatedRotation(
              turns: isHovered ? -0.125 : 0, // -45 degrees
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: Text(
                '→',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isHovered
                      ? Colors.white
                      : (isDark ? AppColors.darkText3 : AppColors.lightText3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Status badge for Work In Progress
class _InDevelopmentBadge extends StatelessWidget {
  const _InDevelopmentBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFAB00).withOpacity(0.12),
        border: Border.all(color: const Color(0xFFFFAB00).withOpacity(0.3)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        '🚧 IN DEVELOPMENT',
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFAB00),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
} 
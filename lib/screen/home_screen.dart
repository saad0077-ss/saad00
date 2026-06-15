import 'package:flutter/material.dart';
import '../providers/theme_provider.dart';
import '../providers/scroll_provider.dart';
import '../widgets/common/particle_background.dart';
import '../widgets/common/nav_bar.dart';
import '../widgets/common/footer.dart';
import '../widgets/home/hero_section.dart';
import '../widgets/home/tech_ticker.dart';
import '../widgets/home/stats_row.dart';
import '../widgets/home/about_section.dart';
import '../widgets/home/projects_section.dart';
import '../widgets/home/experience_section.dart';
import '../widgets/home/contact_section.dart';
import '../widgets/common/custom_cursor.dart';

/// HomeScreen — assembles all portfolio sections with shared providers.
class HomeScreen extends StatefulWidget {
  final ThemeProvider themeProvider;
  const HomeScreen({super.key, required this.themeProvider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollProvider _scrollProvider;

  // Section keys for smooth scrolling
  final _heroKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollProvider = ScrollProvider();
    _scrollProvider.scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    setState(() {}); // rebuild for nav scroll state
  }

  @override
  void dispose() {
    _scrollProvider.dispose();
    super.dispose();
  }

  bool get _isDark => widget.themeProvider.isDark;

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _isDark ? const Color(0xFF080C10) : const Color(0xFFF4F7FB);
    final isScrolled = _scrollProvider.isScrolled;

    return CustomCursor(
      child: Scaffold(
        backgroundColor: bg,
        body: Stack(
        children: [
          // Particle background (always behind)
          Positioned.fill(
            child: ParticleBackground(isDark: _isDark),
          ),

          // Scrollable content
          CustomScrollView(
            controller: _scrollProvider.scrollController,
            slivers: [
              // Fixed nav bar
              SliverAppBar(
                pinned: true,
                toolbarHeight: 72,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: PortfolioNavBar(
                  isDark: _isDark,
                  isScrolled: isScrolled,
                  onThemeToggle: () {
                    widget.themeProvider.toggle();
                    setState(() {});
                  },
                  navActions: {
                    'about': () => _scrollTo(_aboutKey),
                    'work': () => _scrollTo(_projectsKey),
                    'journey': () => _scrollTo(_experienceKey),
                    'contact': () => _scrollTo(_contactKey),
                  },
                ),
              ),

              // Hero
              SliverToBoxAdapter(
                child: KeyedSubtree(
                  key: _heroKey,
                  child: HeroSection(
                    isDark: _isDark,
                    onViewWork: () => _scrollTo(_projectsKey),
                    onContact: () => _scrollTo(_contactKey),
                  ),
                ),
              ),

              // Tech ticker
              SliverToBoxAdapter(
                child: TechTicker(isDark: _isDark),
              ),

              // Stats
              SliverToBoxAdapter(
                child: StatsRow(isDark: _isDark),
              ),

              // About
              SliverToBoxAdapter(
                child: KeyedSubtree(
                  key: _aboutKey,
                  child: AboutSection(isDark: _isDark),
                ),
              ),

              // Projects
              SliverToBoxAdapter(
                child: KeyedSubtree(
                  key: _projectsKey,
                  child: ProjectsSection(isDark: _isDark),
                ),
              ),

              // Experience
              SliverToBoxAdapter(
                child: KeyedSubtree(
                  key: _experienceKey,
                  child: ExperienceSection(isDark: _isDark),
                ),
              ),

              // Contact
              SliverToBoxAdapter(
                child: KeyedSubtree(
                  key: _contactKey,
                  child: ContactSection(isDark: _isDark),
                ),
              ),

              // Footer
              SliverToBoxAdapter(
                child: PortfolioFooter(isDark: _isDark),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}

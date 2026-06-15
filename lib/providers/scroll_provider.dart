import 'package:flutter/material.dart';

/// ScrollProvider — tracks scroll position and active nav section.
class ScrollProvider extends ChangeNotifier {
  final ScrollController scrollController = ScrollController();
  double _scrollOffset = 0;
  String _activeSection = 'home';

  double get scrollOffset => _scrollOffset;
  String get activeSection => _activeSection;
  bool get isScrolled => _scrollOffset > 60;

  ScrollProvider() {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    _scrollOffset = scrollController.offset;
    notifyListeners();
  }

  void setActiveSection(String section) {
    if (_activeSection != section) {
      _activeSection = section;
      notifyListeners();
    }
  }

  void scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }
}

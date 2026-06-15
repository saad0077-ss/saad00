<<<<<<< HEAD
# my_portfolio

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# Saad — Flutter Portfolio App

Flutter port of the HTML portfolio, with all personal details updated.

## Project Structure

```
lib/
├── main.dart                          ← App entry point, MaterialApp
│
├── constants/
│   ├── app_colors.dart                ← All color tokens (dark + light)
│   ├── app_text_styles.dart           ← Reusable TextStyle helpers
│   └── portfolio_data.dart            ← All your content (name, bio, projects…)
│
├── models/
│   └── portfolio_models.dart          ← ProjectModel, ExperienceModel, SkillTag
│
├── providers/
│   ├── theme_provider.dart            ← Dark/light toggle (ChangeNotifier)
│   └── scroll_provider.dart          ← Scroll offset + section tracking
│
├── screens/
│   └── home_screen.dart              ← Assembles all sections, owns scroll + nav
│
└── widgets/
    ├── common/
    │   ├── nav_bar.dart              ← Sticky top navigation bar
    │   ├── particle_background.dart  ← Animated floating particle canvas
    │   └── footer.dart               ← Footer with live clock
    └── home/
        ├── hero_section.dart         ← Full-height hero with device mockups
        ├── tech_ticker.dart          ← Infinite scrolling tech ticker
        ├── stats_row.dart            ← Animated stat counters
        ├── about_section.dart        ← Bento-grid about cards
        ├── projects_section.dart     ← Project list with hover effects
        ├── experience_section.dart   ← Timeline journey section
        └── contact_section.dart      ← Contact box with GitHub link
```

## Personalisation (already done)

| Field | Value |
|---|---|
| Name | Saad |
| GitHub | saad0077-ss |
| Education | +2 Science Graduate |
| Status | Fresher / Self-learner |
| Location | Kerala, India |

## Setup

```bash
# 1. Get dependencies
flutter pub get

# 2. Add fonts — option A (recommended)
#    Add to pubspec.yaml dependencies:
#      google_fonts: ^6.1.0
#    Then replace fontFamily: 'Syne' with GoogleFonts.syne()

# 3. Run
flutter run -d chrome        # Web
flutter run -d android
flutter run -d ios
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

## State Management

- **ThemeProvider** (`ChangeNotifier`) — owned by `_PortfolioAppState`, passed as prop.
  Toggle dark/light by calling `themeProvider.toggle()`.
- **ScrollProvider** — owned by `HomeScreen`, tracks scroll offset and drives
  the sticky nav bar's frosted glass effect.
- All other state is local widget state (`StatefulWidget` / `setState`).
  This keeps things simple for a portfolio that has no backend.
=======
# saad00
A modern, responsive portfolio showcasing my projects and skills in Flutter and core computer science concepts.
>>>>>>> db90c241e5523a9334b60015173afbadacc23511

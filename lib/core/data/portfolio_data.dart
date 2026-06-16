import 'package:my_portfolio/model/portfolio_models.dart';


class PortfolioData {
  // ── Personal Info ──────────────────────────────────────────────
  static const String name = 'Saad';
  static const String githubUsername = 'saad0077-ss';
  static const String githubUrl = 'https://github.com/saad0077-ss';
  static const String linkedinUrl = 'https://linkedin.com/in/muhammed-saad-c';
  static const String email = 'muhammedsaad007700@gmail.com';
  static const String instagramUrl = 'https://www.instagram.com/_sa.___.ad_/';
  static const String xUrl = 'https://x.com/m_saadcr';
  static const String avatarUrl = 'assets/images/me.jpg'; // Placeholder path
  
  static const String location = 'Kerala, India · UTC+5:30';
  static const String tagline = 'Flutter Developer';

  static const String heroBio =
      'Fresher Flutter developer building a strong foundation in cross-platform mobile '
      'development. Passionate about crafting clean UI and learning every layer of the '
      'Flutter ecosystem — from widgets to state management.';

  // ── About Section ──────────────────────────────────────────────
  static const String aboutHeading = "I'm Muhammed Saad C — \na Flutter developer\nbuilding for every platform.";
  static const String aboutBody =
      'I am a fresher Flutter developer passionate about building beautiful, '
      'cross-platform apps. I have completed my +2 in Science and am now '
      'focused on mastering Flutter & Dart. I love turning ideas into '
      'real apps that run on iOS, Android, Web, and Desktop — all from '
      'a single, maintainable codebase.';

  static const String availabilityText = 'Open to\nFreelance &\nOpportunities';
  static const String locationText = 'Based in Kerala, India · Remote · UTC+5:30';

  static const List<String> clients = [
    'NEXUS LABS',
    'PIXEL STUDIO',
    'APPCRAFT',
    'MEDTECH INC',
    'FINOVA',
    'WAVEAPP',
  ];

  // ── Tech Stack ─────────────────────────────────────────────────
  static const List<String> techStack = [
    'Flutter',
    'Dart',
    'Firebase',
    'REST APIs',
    'BLoC',
    'Riverpod',
    'Hive',
    'SQLite',
    'Git',
    'GitHub',
    'Figma',
    'Material 3',
    'VS Code',
  ];

  // ── Stats ──────────────────────────────────────────────────────
  static const List<Map<String, String>> stats = [
    {'value': '3', 'unit': '', 'label': 'Projects Built'},
    {'value': '2', 'unit': 'yr', 'label': 'Learning Flutter'},
    {'value': '4', 'unit': '', 'label': 'Platforms Targeted'},
    {'value': '100', 'unit': '%', 'label': 'Passion & Drive'},
  ];

  // ── Projects ───────────────────────────────────────────────────
  static const List<ProjectModel> projects = [
    ProjectModel(
      number: '001',
      title: 'Flutter Portfolio App',
      tags: ['Flutter', 'Dart', 'Responsive UI', 'Animations'],
      platformEmojis: ['📱', '🌐', '💻'],
      githubUrl: 'https://github.com/saad0077-ss',
    ),
    ProjectModel(
      number: '002',
      title: 'Habit Tracker',
      tags: ['Flutter', 'Hive', 'BLoC', 'Local Storage'],
      platformEmojis: ['📱', '🍎'],
      githubUrl: 'https://github.com/saad0077-ss',
    ),
    ProjectModel(
      number: '003',
      title: 'Weather App',
      tags: ['Flutter', 'REST API', 'Riverpod', 'Material 3'],
      platformEmojis: ['📱', '🌐'],
      githubUrl: 'https://github.com/saad0077-ss',
    ),
    ProjectModel(
      number: '004',
      title: 'To-Do & Notes App',
      tags: ['Flutter', 'SQLite', 'Clean Architecture'],
      platformEmojis: ['📱', '💻', '🪟'],
      githubUrl: 'https://github.com/saad0077-ss',
    ),
  ];

  // ── Experience / Journey ───────────────────────────────────────
  static const List<ExperienceModel> experiences = [
    ExperienceModel(
      period: '2024 — PRESENT',
      role: 'Flutter Developer (Self-Learning)',
      company: 'Independent · Kerala, India',
      description:
          'Actively building a strong foundation in Flutter and Dart. '
          'Learning state management (Provider, Riverpod), Firebase integration, '
          'REST APIs, and UI/UX best practices. Building real-world projects '
          'including an inventory app, a grade calculator, and a train booking app.',
      chips: ['Flutter', 'Dart', 'Firebase', 'Riverpod', 'REST API'],
    ),
    ExperienceModel(
      period: '2022 — 2023',
      role: 'Higher Secondary Education — Science',
      company: 'Plus Two · Science Stream · Kerala',
      description:
          'Completed Higher Secondary (Plus Two) with a focus on the Science stream. '
          'Developed strong analytical thinking and a problem-solving mindset during '
          'these years, which laid the groundwork for my journey into software development.',
      chips: ['Physics', 'Chemistry', 'Mathematics', 'Computer Science'],
    ),
  ];

  // ── Ticker items ───────────────────────────────────────────────
  static const List<String> tickerItems = [
    'Flutter SDK',
    'Dart 3.0',
    'Riverpod',
    'BLoC Pattern',
    'Firebase',
    'Material 3',
    'Clean Architecture',
    'REST APIs',
    'GitHub Actions',
    'Figma',
    'Hive',
    'SQLite',
  ];

  // ── Typewriter phrases ──────────────────────────────────────────
  static const List<String> aboutTypewriterPhrases = [
    'Flutter learner & builder',
    'Science background · Tech passion',
    'Cross-platform enthusiast',
    'Always learning, always growing',
  ];

  // ── About Reveal Items ──────────────────────────────────────────
  static const List<Map<String, String>> aboutRevealItems = [
    {
      'num': '01',
      'title': 'Science Background',
      'desc': 'Completed Plus Two (Higher Secondary) in the Science stream from 2022 to 2023, building a strong analytical and logical foundation that now fuels my approach to problem-solving in code.',
    },
    {
      'num': '02',
      'title': 'Flutter Journey — 2024 to Present',
      'desc': 'Since 2024, I have been actively learning and building with Flutter, exploring Dart, widgets, state management, and cross-platform development — and I\'m still going strong.',
    },
    {
      'num': '03',
      'title': 'Hands-On Builder',
      'desc': 'I learn by building real projects — from inventory apps to grade calculators — turning concepts into working apps that run on Android and iOS.',
    },
    {
      'num': '04',
      'title': 'Ready to Grow',
      'desc': 'As a fresher, I bring curiosity, dedication, and a growth mindset. I\'m eager to collaborate, contribute, and keep levelling up every single day.',
    },
  ];
}

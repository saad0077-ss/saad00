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
      'I craft pixel-perfect, performance-obsessed Flutter apps — '
      '\nfrom silky native mobile experiences to full cross-platform '
      '\nproducts that feel at home on every screen.';

  // ── About Section ──────────────────────────────────────────────
  static const String aboutHeading = "I'm Saad —\na Flutter developer\nbuilding for every platform.";
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
    {'value': '47', 'unit': '', 'label': 'Apps Shipped'},
    {'value': '5', 'unit': 'yr', 'label': 'Flutter Experience'},
    {'value': '2', 'unit': 'M+', 'label': 'App Downloads'},
    {'value': '98', 'unit': '%', 'label': 'Client Satisfaction'},
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
      role: 'Flutter Developer (Self-Taught)',
      company: 'Personal Projects · Kerala, India',
      description:
          'Building cross-platform Flutter apps covering mobile, web, and desktop. '
          'Focused on clean architecture, state management with BLoC & Riverpod, '
          'and delivering polished UI/UX experiences.',
      chips: ['Flutter', 'Dart', 'BLoC', 'Riverpod', 'Firebase'],
    ),
    ExperienceModel(
      period: '2022 — 2024',
      role: 'Higher Secondary Education',
      company: 'Science Stream · Kerala, India',
      description:
          'Completed +2 in Science, building a strong analytical foundation. '
          'Alongside academics, began self-learning Flutter development, '
          'exploring mobile app development and UI design principles.',
      chips: ['Science', 'Mathematics', 'Physics', 'Self-Learning'],
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
}

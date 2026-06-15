class ProjectModel {
  final String number;
  final String title;
  final List<String> tags;
  final List<String> platformEmojis;
  final String githubUrl;

  const ProjectModel({
    required this.number,
    required this.title,
    required this.tags,
    required this.platformEmojis,
    this.githubUrl = '',
  });
}

class ExperienceModel {
  final String period;
  final String role;
  final String company;
  final String description;
  final List<String> chips;

  const ExperienceModel({
    required this.period,
    required this.role,
    required this.company,
    required this.description,
    required this.chips,
  });
}

class SkillTag {
  final String label;
  const SkillTag(this.label);
}

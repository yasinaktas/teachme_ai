import 'package:teachme_ai/models/chapter.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String language;
  final DateTime createdAt;
  final List<Chapter> chapters;
  bool isCompleted;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.createdAt,
    required this.chapters,
    this.isCompleted = false,
  });
}

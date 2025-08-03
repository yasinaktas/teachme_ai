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

  Course copyWith({
    String? id,
    String? title,
    String? description,
    String? language,
    DateTime? createdAt,
    List<Chapter>? chapters,
    bool? isCompleted,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
      chapters: chapters ?? this.chapters,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

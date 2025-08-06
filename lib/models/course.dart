import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:teachme_ai/models/chapter.dart';

part 'course.g.dart';

@HiveType(typeId: 0)
class Course extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String language;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final List<Chapter> chapters;
  @HiveField(6)
  final bool isCompleted;

  const Course({
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

  @override
  List<Object?> get props => [
    chapters,
    isCompleted,
    id,
    title,
    description,
    language,
    createdAt,
  ];
}

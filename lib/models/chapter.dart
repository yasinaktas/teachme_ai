import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:teachme_ai/models/question.dart';

part 'chapter.g.dart';

@HiveType(typeId: 1)
class Chapter extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String courseId;
  @HiveField(2)
  final String title;
  @HiveField(3)
  final String description;
  @HiveField(4)
  final String content;
  @HiveField(5)
  final String transcript;
  @HiveField(6)
  final List<Question> questions;
  @HiveField(7)
  final bool isCompleted;

  const Chapter({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.content,
    required this.transcript,
    required this.questions,
    this.isCompleted = false,
  });

  Chapter copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    String? content,
    String? transcript,
    List<Question>? questions,
    bool? isCompleted,
  }) {
    return Chapter(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      transcript: transcript ?? this.transcript,
      questions: questions ?? this.questions,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, courseId];
}

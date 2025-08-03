import 'package:equatable/equatable.dart';
import 'package:teachme_ai/models/question.dart';

class Chapter extends Equatable {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final String content;
  final String transcript;
  final List<Question> questions;
  bool isCompleted;

  Chapter({
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

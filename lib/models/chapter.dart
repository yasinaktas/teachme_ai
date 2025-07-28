import 'package:teachme_ai/models/question.dart';

class Chapter {
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
}

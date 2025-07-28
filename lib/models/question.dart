import 'package:teachme_ai/models/answer.dart';

class Question {
  final String id;
  final String chapterId;
  final String questionText;
  final List<Answer> answers;
  int answerResult;

  Question({
    required this.id,
    required this.chapterId,
    required this.questionText,
    required this.answers,
    this.answerResult = -1,
  });
}

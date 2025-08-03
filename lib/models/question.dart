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

  Question copyWith({
    String? id,
    String? chapterId,
    String? questionText,
    List<Answer>? answers,
    int? answerResult,
  }) {
    return Question(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      questionText: questionText ?? this.questionText,
      answers: answers ?? this.answers,
      answerResult: answerResult ?? this.answerResult,
    );
  }
}

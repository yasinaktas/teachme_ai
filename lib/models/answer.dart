import 'package:hive/hive.dart';

part 'answer.g.dart';

@HiveType(typeId: 3)
class Answer {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String questionId;
  @HiveField(2)
  final String answerText;
  @HiveField(3)
  final bool isCorrect;
  @HiveField(4)
  int givenAnswer;

  Answer({
    required this.id,
    required this.questionId,
    required this.answerText,
    required this.isCorrect,
    this.givenAnswer = -1,
  });

  Answer copyWith({
    String? id,
    String? questionId,
    String? answerText,
    bool? isCorrect,
    int? givenAnswer,
  }) {
    return Answer(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      answerText: answerText ?? this.answerText,
      isCorrect: isCorrect ?? this.isCorrect,
      givenAnswer: givenAnswer ?? this.givenAnswer,
    );
  }
}
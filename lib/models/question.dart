import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:teachme_ai/models/answer.dart';

part 'question.g.dart';

@HiveType(typeId: 2)
class Question extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String chapterId;
  @HiveField(2)
  final String questionText;
  @HiveField(3)
  final List<Answer> answers;
  @HiveField(4)
  final int answerResult;

  const Question({
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

  @override
  List<Object?> get props => [
    id,
    chapterId,
    questionText,
    answers,
    answerResult,
  ];
}

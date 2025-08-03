class Answer {
  final String id;
  final String questionId;
  final String answerText;
  final bool isCorrect;
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
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
}
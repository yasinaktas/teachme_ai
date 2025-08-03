import 'dart:convert';

DtoChapterQuestions dtoChapterQuestionsFromJson(String str) =>
    DtoChapterQuestions.fromJson(json.decode(str));

String dtoChapterQuestionsToJson(DtoChapterQuestions data) =>
    json.encode(data.toJson());

class DtoChapterQuestions {
  final List<DtoQuestion> questions;

  DtoChapterQuestions({required this.questions});

  DtoChapterQuestions copyWith({List<DtoQuestion>? questions}) =>
      DtoChapterQuestions(questions: questions ?? this.questions);

  factory DtoChapterQuestions.fromJson(Map<String, dynamic> json) =>
      DtoChapterQuestions(
        questions: List<DtoQuestion>.from(
          json["questions"].map((x) => DtoQuestion.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
  };
}

class DtoQuestion {
  final String questionText;
  final List<DtoAnswer> answers;

  DtoQuestion({required this.questionText, required this.answers});

  DtoQuestion copyWith({String? questionText, List<DtoAnswer>? answers}) => DtoQuestion(
    questionText: questionText ?? this.questionText,
    answers: answers ?? this.answers,
  );

  factory DtoQuestion.fromJson(Map<String, dynamic> json) => DtoQuestion(
    questionText: json["questionText"],
    answers: List<DtoAnswer>.from(json["answers"].map((x) => DtoAnswer.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "questionText": questionText,
    "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
  };
}

class DtoAnswer {
  final String text;
  final bool isCorrect;

  DtoAnswer({required this.text, required this.isCorrect});

  DtoAnswer copyWith({String? text, bool? isCorrect}) =>
      DtoAnswer(text: text ?? this.text, isCorrect: isCorrect ?? this.isCorrect);

  factory DtoAnswer.fromJson(Map<String, dynamic> json) =>
      DtoAnswer(text: json["text"], isCorrect: json["isCorrect"]);

  Map<String, dynamic> toJson() => {"text": text, "isCorrect": isCorrect};
}

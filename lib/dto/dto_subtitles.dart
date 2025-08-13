import 'dart:convert';

DtoSubtitles dtoSubtitlesFromJson(String str) =>
    DtoSubtitles.fromJson(json.decode(str));

String dtoSubtitlesToJson(DtoSubtitles data) => json.encode(data.toJson());

class DtoSubtitles {
  final List<Subtitle> subtitles;
  final String courseShortDescription;
  final String courseTitle;

  DtoSubtitles({required this.subtitles, required this.courseShortDescription,
    required this.courseTitle});

  DtoSubtitles copyWith({
    List<Subtitle>? subtitles,
    String? courseShortDescription,
    String? courseTitle,
  }) => DtoSubtitles(
    subtitles: subtitles ?? this.subtitles,
    courseShortDescription:
        courseShortDescription ?? this.courseShortDescription,
    courseTitle: courseTitle ?? this.courseTitle,
  );

  factory DtoSubtitles.fromJson(Map<String, dynamic> json) => DtoSubtitles(
    subtitles: List<Subtitle>.from(
      json["subtitles"].map((x) => Subtitle.fromJson(x)),
    ),
    courseShortDescription: json["courseShortDescription"],
    courseTitle: json["courseTitle"],
  );

  Map<String, dynamic> toJson() => {
    "subtitles": List<dynamic>.from(subtitles.map((x) => x.toJson())),
    "courseShortDescription": courseShortDescription,
    "courseTitle": courseTitle,
  };
}

class Subtitle {
  final String title;

  Subtitle({required this.title});

  Subtitle copyWith({String? title, String? shortDescription}) =>
      Subtitle(title: title ?? this.title);

  factory Subtitle.fromJson(Map<String, dynamic> json) =>
      Subtitle(title: json["title"]);

  Map<String, dynamic> toJson() => {"title": title};
}

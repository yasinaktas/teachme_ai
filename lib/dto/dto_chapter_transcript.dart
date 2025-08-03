import 'dart:convert';

DtoChapterTranscript dtoChapterTranscriptFromJson(String str) => DtoChapterTranscript.fromJson(json.decode(str));

String dtoChapterTranscriptToJson(DtoChapterTranscript data) => json.encode(data.toJson());

class DtoChapterTranscript {
    final String transcript;

    DtoChapterTranscript({
        required this.transcript,
    });

    DtoChapterTranscript copyWith({
        String? transcript,
    }) => 
        DtoChapterTranscript(
            transcript: transcript ?? this.transcript,
        );

    factory DtoChapterTranscript.fromJson(Map<String, dynamic> json) => DtoChapterTranscript(
        transcript: json["transcript"],
    );

    Map<String, dynamic> toJson() => {
        "transcript": transcript,
    };
}

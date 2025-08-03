import 'dart:convert';

DtoChapterContent dtoChapterContentFromJson(String str) => DtoChapterContent.fromJson(json.decode(str));

String dtoChapterContentToJson(DtoChapterContent data) => json.encode(data.toJson());

class DtoChapterContent {
    final String content;
    final String chapterShortDescription;

    DtoChapterContent({
        required this.content,
        required this.chapterShortDescription,
    });

    DtoChapterContent copyWith({
        String? content,
        String? chapterShortDescription,
    }) => 
        DtoChapterContent(
            content: content ?? this.content,
            chapterShortDescription: chapterShortDescription ?? this.chapterShortDescription,
        );

    factory DtoChapterContent.fromJson(Map<String, dynamic> json) => DtoChapterContent(
        content: json["content"],
        chapterShortDescription: json["chapterShortDescription"],
    );

    Map<String, dynamic> toJson() => {
        "content": content,
        "chapterShortDescription": chapterShortDescription,
    };
}

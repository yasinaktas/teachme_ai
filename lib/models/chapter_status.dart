class ChapterStatus {
  final bool isContentGenerated;
  final bool isTranscriptGenerated;
  final bool isQuestionsGenerated;
  final int generationResultCode;

  ChapterStatus({
    this.isContentGenerated = false,
    this.isTranscriptGenerated = false,
    this.isQuestionsGenerated = false,
    this.generationResultCode = 0,
  });

  ChapterStatus copyWith({
    bool? isContentGenerated,
    bool? isTranscriptGenerated,
    bool? isQuestionsGenerated,
    int? generationResultCode,
  }) {
    return ChapterStatus(
      isContentGenerated: isContentGenerated ?? this.isContentGenerated,
      isTranscriptGenerated:
          isTranscriptGenerated ?? this.isTranscriptGenerated,
      isQuestionsGenerated: isQuestionsGenerated ?? this.isQuestionsGenerated,
      generationResultCode: generationResultCode ?? this.generationResultCode,
    );
  }
}

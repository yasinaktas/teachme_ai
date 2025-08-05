class ChapterStatus {
  final bool isContentGenerated;
  final bool isTranscriptGenerated;
  final bool isQuestionsGenerated;
  final bool isAudioGenerated;
  final int generationResultCode;

  ChapterStatus({
    this.isContentGenerated = false,
    this.isTranscriptGenerated = false,
    this.isQuestionsGenerated = false,
    this.isAudioGenerated = false,
    this.generationResultCode = 0,
  });

  ChapterStatus copyWith({
    bool? isContentGenerated,
    bool? isTranscriptGenerated,
    bool? isQuestionsGenerated,
    bool? isAudioGenerated,
    int? generationResultCode,
  }) {
    return ChapterStatus(
      isContentGenerated: isContentGenerated ?? this.isContentGenerated,
      isTranscriptGenerated:
          isTranscriptGenerated ?? this.isTranscriptGenerated,
      isQuestionsGenerated: isQuestionsGenerated ?? this.isQuestionsGenerated,
      isAudioGenerated: isAudioGenerated ?? this.isAudioGenerated,
      generationResultCode: generationResultCode ?? this.generationResultCode,
    );
  }
}

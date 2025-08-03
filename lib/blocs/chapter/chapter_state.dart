import 'package:teachme_ai/models/chapter.dart';

class ChapterState {
  final Chapter? chapter;
  final bool isLoadingAudio;
  final double progress;
  final String currentTime;
  final String totalTime;
  final bool isPlaying;
  final bool isCompleted;

  ChapterState({
    this.chapter,
    this.isLoadingAudio = false,
    this.progress = 0.0,
    this.currentTime = "00:00",
    this.totalTime = "00:00",
    this.isPlaying = false,
    this.isCompleted = false,
  });

  ChapterState copyWith({
    Chapter? chapter,
    bool? isLoadingAudio,
    double? progress,
    String? currentTime,
    String? totalTime,
    bool? isPlaying,
    bool? isCompleted,
  }) {
    return ChapterState(
      chapter: chapter ?? this.chapter,
      isLoadingAudio: isLoadingAudio ?? this.isLoadingAudio,
      progress: progress ?? this.progress,
      currentTime: currentTime ?? this.currentTime,
      totalTime: totalTime ?? this.totalTime,
      isPlaying: isPlaying ?? this.isPlaying,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
import 'package:teachme_ai/models/chapter.dart';

abstract class ChapterEvent {}

class LoadChapter extends ChapterEvent {
  final Chapter chapter;
  LoadChapter(this.chapter);
}

class LoadAudio extends ChapterEvent {
  /*final String audioFilePath;
  LoadAudio(this.audioFilePath);*/
}

class PlayAudio extends ChapterEvent {}

class PauseAudio extends ChapterEvent {}

class SeekAudio extends ChapterEvent {
  final Duration position;
  SeekAudio(this.position);
}

class UpdateAudioProgress extends ChapterEvent {
  final double progress;
  UpdateAudioProgress(this.progress);
}

class SetAudioTotalTime extends ChapterEvent {
  final String totalTime;
  SetAudioTotalTime(this.totalTime);
}

class UpdateAudioCurrentTime extends ChapterEvent {
  final String currentTime;
  UpdateAudioCurrentTime(this.currentTime);
}

class AnswerToggle extends ChapterEvent {
  final String questionId;
  final String answerId;
  final bool isSelected;
  AnswerToggle(this.questionId, this.answerId, this.isSelected);
}

class Completed extends ChapterEvent {}

class DownloadAudio extends ChapterEvent {}

class ReleaseAudio extends ChapterEvent {}

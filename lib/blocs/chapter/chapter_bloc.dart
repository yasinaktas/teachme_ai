import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teachme_ai/blocs/chapter/chapter_event.dart';
import 'package:teachme_ai/blocs/chapter/chapter_state.dart';
import 'package:teachme_ai/constants/app_languages.dart';
import 'package:teachme_ai/repositories/api_result.dart';
import 'package:teachme_ai/repositories/interfaces/i_course_repository.dart';
import 'package:teachme_ai/repositories/interfaces/i_tts_repository.dart';

class ChapterBloc extends Bloc<ChapterEvent, ChapterState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ICourseRepository courseRepository;
  final ITtsRepository ttsRepository;
  late final StreamSubscription _positionSub;
  late final StreamSubscription _durationSub;
  late final StreamSubscription _playerStateSub;

  ChapterBloc({required this.courseRepository, required this.ttsRepository})
    : super(ChapterState()) {
    on<LoadChapter>(_onLoadChapter);
    on<LoadAudio>(_onLoadAudio);
    on<PlayAudio>(_onPlayAudio);
    on<PauseAudio>(_onPauseAudio);
    on<SeekAudio>(_onSeekAudio);
    on<UpdateAudioProgress>(_onUpdateAudioProgress);
    on<SetAudioTotalTime>(_onSetAudioTotalTime);
    on<UpdateAudioCurrentTime>(_onUpdateAudioCurrentTime);
    on<AnswerToggle>(_onAnswerToggle);
    on<Completed>(_onCompleted);
    on<DownloadAudio>(_onDownloadAudio);

    _playerStateSub = _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        add(PauseAudio());
        add(Completed());
      }
    });

    _positionSub = _audioPlayer.positionStream.listen((position) {
      add(UpdateAudioProgress(position.inSeconds.toDouble()));
      final formattedTime = position.toString().split('.').first;
      add(UpdateAudioCurrentTime(formattedTime));
    });

    _durationSub = _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        final formattedTotal = duration.toString().split('.').first;
        add(SetAudioTotalTime(formattedTotal));
      }
    });
  }

  void _onLoadChapter(LoadChapter event, Emitter<ChapterState> emit) {
    emit(
      state.copyWith(
        chapter: event.chapter,
        isCompleted: event.chapter.isCompleted,
        isPlaying: false,
        progress: 0.0,
      ),
    );
  }

  Future _onAnswerToggle(AnswerToggle event, Emitter<ChapterState> emit) async {
    final currentState = state;
    final updatedChapter = currentState.chapter!.copyWith(
      questions: currentState.chapter!.questions.map((question) {
        if (question.id == event.questionId) {
          return question.copyWith(
            answers: question.answers.map((answer) {
              if (answer.id != event.answerId) return answer;
              return answer.copyWith(givenAnswer: event.isSelected ? 1 : 0);
            }).toList(),
          );
        }
        return question;
      }).toList(),
    );

    emit(currentState.copyWith(chapter: updatedChapter));

    await courseRepository.updateChapter(updatedChapter);
  }

  Future<void> _onLoadAudio(LoadAudio event, Emitter<ChapterState> emit) async {
    emit(state.copyWith(isLoadingAudio: true, isAudioExists: false));
    try {
      final dir = await getApplicationDocumentsDirectory();
      final audioFilePath = "${dir.path}/${state.chapter!.id}.mp3";
      if (await File(audioFilePath).exists()) {
        await _audioPlayer.setFilePath(audioFilePath);
        final duration = _audioPlayer.duration;
        if (duration != null) {
          emit(state.copyWith(isAudioExists: true));
        } else {
          emit(state.copyWith(isAudioExists: false, isLoadingAudio: false));
        }
      } else {
        throw Exception("Audio file not found");
      }
    } catch (e) {
      emit(state.copyWith(isAudioExists: false, isLoadingAudio: false));
    }
  }

  void _onPlayAudio(PlayAudio event, Emitter<ChapterState> emit) {
    _audioPlayer.play();
    emit(state.copyWith(isPlaying: true));
  }

  void _onPauseAudio(PauseAudio event, Emitter<ChapterState> emit) {
    _audioPlayer.pause();
    emit(state.copyWith(isPlaying: false));
  }

  void _onSeekAudio(SeekAudio event, Emitter<ChapterState> emit) {
    _audioPlayer.seek(event.position);
  }

  void _onUpdateAudioProgress(
    UpdateAudioProgress event,
    Emitter<ChapterState> emit,
  ) {
    emit(state.copyWith(progress: event.progress));
  }

  void _onSetAudioTotalTime(
    SetAudioTotalTime event,
    Emitter<ChapterState> emit,
  ) {
    emit(state.copyWith(totalTime: event.totalTime));
  }

  void _onUpdateAudioCurrentTime(
    UpdateAudioCurrentTime event,
    Emitter<ChapterState> emit,
  ) {
    emit(state.copyWith(currentTime: event.currentTime));
  }

  Future<void> _onCompleted(Completed event, Emitter<ChapterState> emit) async {
    emit(state.copyWith(isCompleted: true));
  }

  @override
  Future<void> close() {
    _positionSub.cancel();
    _durationSub.cancel();
    _playerStateSub.cancel();
    _audioPlayer.dispose();
    return super.close();
  }

  Future<void> _onDownloadAudio(
    DownloadAudio event,
    Emitter<ChapterState> emit,
  ) async {
    emit(state.copyWith(isLoadingAudio: true));
    emit(state.copyWith(isAudioExists: false));
    try {
      final chapter = state.chapter;
      if (chapter != null) {
        final courses = await courseRepository.getCourses();
        final course = courses.firstWhere((c) => c.id == chapter.courseId);
        final language = AppLanguages.languages.firstWhere(
          (lang) => lang.name == course.language,
        );
        final dir = await getApplicationDocumentsDirectory();
        final audioFilePath = "${dir.path}/${state.chapter!.id}.mp3";
        debugPrint(chapter.transcript);
        final apiResultAudio = await ttsRepository.generateSpeech(
          chapter.transcript,
          language.languageCode,
          language.voiceName,
          chapter.id,
        );
        if (apiResultAudio is Failure) {
          emit(state.copyWith(isAudioExists: false, isLoadingAudio: false));
          return;
        } else {
          await _audioPlayer.setFilePath(audioFilePath);
          emit(state.copyWith(isAudioExists: true));
        }
      }
    } catch (e) {
      emit(state.copyWith(isAudioExists: false, isLoadingAudio: false));
    }
  }
}

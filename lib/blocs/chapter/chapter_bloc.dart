import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:teachme_ai/blocs/chapter/chapter_event.dart';
import 'package:teachme_ai/blocs/chapter/chapter_state.dart';
import 'package:teachme_ai/repositories/i_course_repository.dart';

class ChapterBloc extends Bloc<ChapterEvent, ChapterState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ICourseRepository courseRepository;
  late final StreamSubscription _positionSub;
  late final StreamSubscription _durationSub;
  late final StreamSubscription _playerStateSub;

  ChapterBloc({required this.courseRepository}) : super(ChapterState()) {
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

  Future<void> _onLoadAudio(LoadAudio event, Emitter<ChapterState> emit) async {
    await _audioPlayer.setFilePath(event.audioFilePath);

    final duration = _audioPlayer.duration;
    if (duration != null) {
      emit(state.copyWith(totalTime: duration.toString().split('.').first));
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

  void _onLoadChapter(LoadChapter event, Emitter<ChapterState> emit) {
    emit(
      state.copyWith(
        chapter: event.chapter,
        isCompleted: event.chapter.isCompleted,
      ),
    );
  }

  @override
  Future<void> close() {
    _positionSub.cancel();
    _durationSub.cancel();
    _playerStateSub.cancel();
    _audioPlayer.dispose();
    return super.close();
  }

  Future<void> _onCompleted(Completed event, Emitter<ChapterState> emit) async {
    emit(state.copyWith(isCompleted: true));
  }
}

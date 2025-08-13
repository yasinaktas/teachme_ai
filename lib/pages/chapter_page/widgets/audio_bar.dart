import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/chapter/chapter_bloc.dart';
import 'package:teachme_ai/blocs/chapter/chapter_event.dart';
import 'package:teachme_ai/blocs/chapter/chapter_state.dart';
import 'package:teachme_ai/blocs/course/course_bloc.dart';
import 'package:teachme_ai/blocs/course/course_event.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/widgets/circular_progress.dart';

class AudioBar extends StatelessWidget {
  final Chapter chapter;
  const AudioBar({super.key, required this.chapter});

  Duration _durationFromString(String timeString) {
    final parts = timeString.split(":").map(int.parse).toList();
    if (parts.length == 2) {
      return Duration(minutes: parts[0], seconds: parts[1]);
    } else if (parts.length == 3) {
      return Duration(hours: parts[0], minutes: parts[1], seconds: parts[2]);
    }
    return Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: BlocConsumer<ChapterBloc, ChapterState>(
        listenWhen: (previous, current) {
          return previous.isCompleted != current.isCompleted;
        },
        listener: (context, state) {
          if (state.isCompleted) {
            final updatedChapter = chapter.copyWith(isCompleted: true);
            context.read<CourseBloc>().add(ChapterUpdateEvent(updatedChapter));
          }
        },
        builder: (context, state) {
          final currentSeconds = state.progress;
          final totalSeconds = _durationFromString(
            state.totalTime,
          ).inSeconds.toDouble();
          return Card(
            color: AppColors.blackColor,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                const SizedBox(width: 24),
                Text(
                  state.isAudioExists ? state.currentTime : "--:--",
                  style: AppStyles.textStyleNormalOnSurface,
                ),
                const SizedBox(width: 0),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: !state.isAudioExists
                        ? 1
                        : totalSeconds > 0
                        ? totalSeconds
                        : 1,
                    value: state.isAudioExists
                        ? currentSeconds.clamp(0, totalSeconds)
                        : 0,
                    inactiveColor: AppColors.onCardOppositeColor,
                    activeColor: AppColors.primaryColor,
                    thumbColor: AppColors.primaryColor,
                    onChanged: (value) {
                      context.read<ChapterBloc>().add(PauseAudio());
                      context.read<ChapterBloc>().add(
                        SeekAudio(Duration(seconds: value.toInt())),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 0),
                Text(
                  state.isAudioExists ? state.totalTime : "--:--",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 0),
                state.isAudioExists
                    ? IconButton(
                        onPressed: () {
                          if (state.isPlaying) {
                            context.read<ChapterBloc>().add(PauseAudio());
                          } else {
                            context.read<ChapterBloc>().add(PlayAudio());
                          }
                        },
                        icon: Icon(
                          state.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: AppColors.onCardOppositeColor,
                          size: AppDimensions.iconSizeLarge,
                        ),
                      )
                    : state.isLoadingAudio
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.pagePadding,
                        ),
                        child: const CircularProgress(
                          color: AppColors.onCardOppositeColor,
                        ),
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.download,
                          color: AppColors.onCardOppositeColor,
                          size: AppDimensions.iconSizeMedium,
                        ),
                        onPressed: () {
                          context.read<ChapterBloc>().add(DownloadAudio());
                        },
                      ),
                const SizedBox(width: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/blocs/chapter/chapter_bloc.dart';
import 'package:teachme_ai/blocs/chapter/chapter_event.dart';
import 'package:teachme_ai/blocs/chapter/chapter_state.dart';
import 'package:teachme_ai/blocs/course/course_bloc.dart';
import 'package:teachme_ai/blocs/course/course_event.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/widgets/chapter_page_chapter_card copy.dart';
import 'package:flutter_html/flutter_html.dart';

class ChapterPage extends StatefulWidget {
  final Chapter chapter;
  const ChapterPage({super.key, required this.chapter});

  @override
  ChapterPageState createState() => ChapterPageState();
}

class ChapterPageState extends State<ChapterPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChapterBloc>().add(LoadChapter(widget.chapter));
    context.read<ChapterBloc>().add(LoadAudio());
  }

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
    final chapter = widget.chapter;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "Enjoy Learning",
          style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: SizedBox(
          height: 56,
          child: BlocConsumer<ChapterBloc, ChapterState>(
            listenWhen: (previous, current) {
              return previous.isCompleted != current.isCompleted;
            },
            listener: (context, state) {
              if (state.isCompleted) {
                final updatedChapter = chapter.copyWith(isCompleted: true);
                context.read<CourseBloc>().add(
                  ChapterUpdateEvent(updatedChapter),
                );
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
                      style: const TextStyle(color: Colors.white),
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
                        inactiveColor: Colors.white,
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
                              color: Colors.white,
                              size: 32,
                            ),
                          )
                        : state.isLoadingAudio
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.download,
                              color: Colors.white,
                              size: 24,
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
        ),
      ),

      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Text(
              "Chapter Summary",
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ).withPadding(),
          ),
          SliverToBoxAdapter(child: ChapterPageChapterCard(chapter: chapter)),
          SliverToBoxAdapter(
            child: Text(
              "Content",
              style: GoogleFonts.quicksand(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ).withPadding(),
          ),
          SliverToBoxAdapter(
            child: Card(
              color: AppColors.cardColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: AppColors.secondaryShadowColor,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(
                  AppDimensions.listCardRadius,
                ),
              ),
              margin: EdgeInsets.zero,
              child: Html(data: chapter.content).withPadding(
                EdgeInsets.symmetric(
                  horizontal: AppDimensions.pagePadding / 2,
                  vertical: AppDimensions.pagePadding / 2,
                ),
              ),
            ).withPadding(),
          ),
          if (chapter.questions.isNotEmpty)
            SliverToBoxAdapter(
              child: Text(
                "Questions",
                style: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ).withPadding(),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final question = chapter.questions[index];
              return Card(
                color: AppColors.cardColor,
                elevation: AppDimensions.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.listCardRadius,
                  ),
                ),
                margin: EdgeInsets.zero,
                child: ExpansionTile(
                  shape: RoundedRectangleBorder(),
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primarySurfaceColor,
                    child: Text(
                      "${index + 1}",
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                  title: Text(
                    question.questionText,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  children: question.answers
                      .map(
                        (answer) => Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: BlocBuilder<ChapterBloc, ChapterState>(
                            builder: (context, state) {
                              return CheckboxListTile(
                                title: Text(
                                  answer.answerText,
                                  style: GoogleFonts.quicksand(
                                    fontSize: 14,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                                value:
                                    state.chapter!.questions[index].answers
                                        .firstWhere(
                                          (a) => a.id == answer.id,
                                          orElse: () => answer,
                                        )
                                        .givenAnswer ==
                                    1,
                                onChanged: (value) {
                                  context.read<ChapterBloc>().add(
                                    AnswerToggle(
                                      question.id,
                                      answer.id,
                                      value ?? false,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      )
                      .toList(),
                ),
              ).withPadding();
            }, childCount: chapter.questions.length),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height:
                  MediaQuery.of(context).padding.bottom +
                  AppDimensions.pagePadding +
                  80,
            ),
          ),
        ],
      ),
    );
  }
}

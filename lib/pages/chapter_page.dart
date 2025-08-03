import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teachme_ai/blocs/chapter/chapter_bloc.dart';
import 'package:teachme_ai/blocs/chapter/chapter_event.dart';
import 'package:teachme_ai/blocs/chapter/chapter_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/widgets/chapter_page_chapter_card copy.dart';

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
    _loadAudioFromFile();
  }

  Future<void> _loadAudioFromFile() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final audioFilePath = "${dir.path}/${widget.chapter.id}.mp3";
      if (await File(audioFilePath).exists()) {
        if (!mounted) return;
        context.read<ChapterBloc>().add(LoadAudio(audioFilePath));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Audio file not found for chapter ${widget.chapter.id}",
            ),
          ),
        );
        throw Exception("Audio file not found");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error loading audio: $e")));
    }
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
        color: AppColors.backgroundColor,
        child: SizedBox(
          height: 56,
          child: BlocBuilder<ChapterBloc, ChapterState>(
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
                      state.currentTime,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 0),
                    Expanded(
                      child: Slider(
                        min: 0,
                        max: totalSeconds > 0 ? totalSeconds : 1,
                        value: currentSeconds.clamp(0, totalSeconds),
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
                      state.totalTime,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 0),
                    IconButton(
                      icon: Icon(
                        state.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: () {
                        //context.read<ChapterBloc>().add( ToggleAudioPlayPause(!state.isPlaying),);
                        if (state.isPlaying) {
                          context.read<ChapterBloc>().add(PauseAudio());
                        } else {
                          context.read<ChapterBloc>().add(PlayAudio());
                        }
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
              elevation: AppDimensions.cardElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.listCardRadius,
                ),
              ),
              margin: EdgeInsets.zero,
              child:
                  Text(
                    chapter.content,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ).withPadding(
                    EdgeInsets.symmetric(
                      horizontal: AppDimensions.pagePadding,
                      vertical: AppDimensions.pagePadding,
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
                  AppDimensions.pagePadding,
            ),
          ),
        ],
      ),
    );
  }
}

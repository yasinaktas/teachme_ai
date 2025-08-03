import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/widgets/chapter_page_chapter_card copy.dart';

class ChapterPage extends StatefulWidget {
  final Chapter chapter;
  const ChapterPage({super.key, required this.chapter});

  @override
  _ChapterPageState createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  final AudioPlayer _player = AudioPlayer();
  Duration _totalDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initAudio();
    _listenStreams();
  }

  void _listenStreams() {
    _player.positionStream.listen((pos) {
      setState(() => _currentPosition = pos);
    });

    _player.durationStream.listen((dur) {
      setState(() => _totalDuration = dur ?? Duration.zero);
    });

    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        //_player.seek(Duration.zero);
        setState(() {
          _isPlaying = false;
          //_currentPosition = Duration.zero;
        });
      } else {
        setState(() {
          _isPlaying = state.playing;
        });
      }
    });

    // Bitince buton play'e dönsün
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        //_player.seek(Duration.zero);
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  Future<void> _initAudio() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final audioFilePath = "${dir.path}/${widget.chapter.id}.mp3";
      if (await File(audioFilePath).exists()) {
        await _player.setFilePath(audioFilePath);
      } else {
        throw Exception("Audio file not found");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  String _formatDuration(Duration d) {
    final min = d.inMinutes.toString().padLeft(2, '0');
    final sec = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$min:$sec";
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
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
          child: Card(
            color: AppColors.blackColor,
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            child: Row(
              children: [
                const SizedBox(width: 24),
                Text(
                  _formatDuration(_currentPosition),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 0),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: _totalDuration.inMilliseconds.toDouble().clamp(
                      1,
                      double.infinity,
                    ),
                    value: _totalDuration.inMilliseconds == 0
                        ? 0
                        : (_currentPosition.inMilliseconds
                              .clamp(0, _totalDuration.inMilliseconds)
                              .toDouble()),
                    inactiveColor: Colors.white,
                    activeColor: AppColors.primaryColor,
                    thumbColor: AppColors.primaryColor,
                    onChanged: (value) {
                      _player.seek(Duration(milliseconds: value.toInt()));
                    },
                    onChangeStart: (value) async {
                      if (_isPlaying) {
                        await _player.pause();
                        setState(() {
                          _isPlaying = false;
                        });
                      }
                    },
                    onChangeEnd: (value) async {
                      await _player.seek(Duration(milliseconds: value.toInt()));
                    },
                  ),
                ),
                const SizedBox(width: 0),
                Text(
                  _formatDuration(_totalDuration),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(width: 0),
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () async {
                    if (_isPlaying) {
                      await _player.pause();
                    } else {
                      await _player.play();
                    }
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
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
                      color: AppColors.secondaryColor,
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
                          child: CheckboxListTile(
                            title: Text(
                              answer.answerText,
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            value: false,
                            onChanged: (value) {},
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

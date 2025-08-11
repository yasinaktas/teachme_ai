import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/chapter/chapter_bloc.dart';
import 'package:teachme_ai/blocs/chapter/chapter_event.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/extensions/sliver_box_extension.dart';
import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/pages/chapter/widgets/audio_bar.dart';
import 'package:teachme_ai/pages/chapter/widgets/question_list.dart';
import 'package:teachme_ai/widgets/chapter_page_chapter_card copy.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:teachme_ai/widgets/list_card.dart';

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

  @override
  Widget build(BuildContext context) {
    final chapter = widget.chapter;
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text("Enjoy Learning", style: AppStyles.textStylePageTitle),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: AudioBar(chapter: chapter),
      ),

      body: CustomScrollView(
        slivers: [
          Text(
            "Chapter Summary",
            style: AppStyles.textStyleTitleStrong,
          ).withPadding().asSliverBox(),
          SliverToBoxAdapter(child: ChapterPageChapterCard(chapter: chapter)),
          Text(
            "Content",
            style: AppStyles.textStyleTitleStrong,
          ).withPadding().asSliverBox(),
          ListCard(
            hasBorder: true,
            elevation: 0,
            child: Html(data: chapter.content).withPadding(
              const EdgeInsets.symmetric(
                horizontal: AppDimensions.pagePadding / 2,
                vertical: AppDimensions.pagePadding / 2,
              ),
            ),
          ).withPadding().asSliverBox(),
          if (chapter.questions.isNotEmpty)
            Text(
              "Questions",
              style: AppStyles.textStyleTitleStrong,
            ).withPadding().asSliverBox(),
          QuestionList(chapter: chapter),
          SizedBox(
            height:
                MediaQuery.of(context).padding.bottom +
                AppDimensions.pagePadding +
                80,
          ).asSliverBox(),
        ],
      ),
    );
  }
}

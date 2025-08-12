import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/chapter/chapter_bloc.dart';
import 'package:teachme_ai/blocs/chapter/chapter_event.dart';
import 'package:teachme_ai/blocs/chapter/chapter_state.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/models/chapter.dart';
import 'package:teachme_ai/widgets/icon_number.dart';
import 'package:teachme_ai/widgets/list_card.dart';

class QuestionList extends StatelessWidget {
  final Chapter chapter;
  const QuestionList({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final question = chapter.questions[index];
        return ListCard(
          child: ExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.listCardRadius),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.listCardRadius),
            ),
            leading: IconNumber(index: index),
            title: Text(
              question.questionText,
              style: AppStyles.textStyleNormalWeak,
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
                            style: AppStyles.textStyleNormalLight,
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
    );
  }
}

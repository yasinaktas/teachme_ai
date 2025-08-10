import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/course/course_bloc.dart';
import 'package:teachme_ai/blocs/course/course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/extensions/sliver_box_extension.dart';
import 'package:teachme_ai/pages/home/widgets/home_course_list.dart';
import 'package:teachme_ai/pages/home/widgets/home_generating_course.dart';
import 'package:teachme_ai/pages/home/widgets/home_top_bar.dart';
import 'package:teachme_ai/widgets/search_card.dart';
import 'package:teachme_ai/widgets/subscription_banner.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GenerateCourseBloc, GenerateCourseState>(
      listenWhen: (previous, current) {
        return previous.isCourseGenerated != current.isCourseGenerated;
      },
      listener: (context, state) {
        if (state.isCourseGenerated) {
          context.read<GenerateCourseBloc>().add(Clear());
          context.read<CourseBloc>().add(CourseAddEvent(state.course));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Course created successfully!"),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: CustomScrollView(
            slivers: [
              const HomeGeneratingCourse().asSliverBox(),
              const HomeTopBar().asSliverBox(),
              SearchCard(
                hintText: "Search your courses",
                onSearchChanged: (value) {
                  context.read<CourseBloc>().add(CourseSearchEvent(value));
                },
              ).withPadding().asSliverBox(),
              SubscriptionBanner().asSliverBox(),
              Text(
                "My Courses",
                style: AppStyles.textStyleTitleStrong,
              ).withPadding().asSliverBox(),
              const HomeCourseList(),
              SizedBox(
                height:
                    MediaQuery.of(context).padding.bottom +
                    AppDimensions.pagePadding,
              ).asSliverBox(),
            ],
          ),
        ),
      ),
    );
  }
}

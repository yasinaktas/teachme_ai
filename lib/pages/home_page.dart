import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/course/course_bloc.dart';
import 'package:teachme_ai/blocs/course/course_event.dart';
import 'package:teachme_ai/blocs/course/course_state.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/blocs/settings/settings_bloc.dart';
import 'package:teachme_ai/blocs/settings/settings_state.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/extensions/sliver_box_extension.dart';
import 'package:teachme_ai/widgets/course_card.dart';
import 'package:teachme_ai/widgets/loading_bar.dart';
import 'package:teachme_ai/widgets/search_card.dart';
import 'package:teachme_ai/widgets/subscription_banner.dart';
import 'package:teachme_ai/widgets/top_banner.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GenerateCourseBloc, GenerateCourseState>(
      listenWhen: (previous, current) {
        return previous.errorMessage != current.errorMessage ||
            previous.isLoadingCourse != current.isLoadingCourse ||
            previous.isCourseGenerated != current.isCourseGenerated;
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
      builder: (context, state) {
        final isLoading = state.chapterLoadingStatus.values.any(
          (status) => status.isGenerating,
        );
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                if (isLoading)
                  LoadingBar(
                    title: "Generating course...",
                  ).withPadding().asSliverBox(),
                BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                    return TopBanner(
                      topText: "Hello,",
                      bottomText: state.username.isNotEmpty
                          ? state.username
                          : "Guest",
                      imagePath: "assets/images/panda3.png",
                      leftToRight: true,
                    );
                  },
                ).asSliverBox(),
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
                BlocBuilder<CourseBloc, CourseState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (state.error != null) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            state.error!,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    } else if (state.filteredCourses.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child:
                              Text(
                                'No courses available',
                                style: AppStyles.textStyleNormal,
                              ).withPadding(
                                EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).padding.bottom +
                                      AppDimensions.pagePadding,
                                ),
                              ),
                        ),
                      );
                    } else {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final course = state.filteredCourses[index];
                          return CourseCard(course: course);
                        }, childCount: state.filteredCourses.length),
                      );
                    }
                  },
                ),
                SizedBox(
                  height:
                      MediaQuery.of(context).padding.bottom +
                      AppDimensions.pagePadding,
                ).asSliverBox(),
              ],
            ),
          ),
        );
      },
    );
  }
}

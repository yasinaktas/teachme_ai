import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/blocs/course/course_bloc.dart';
import 'package:teachme_ai/blocs/course/course_event.dart';
import 'package:teachme_ai/blocs/course/course_state.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_bloc.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_event.dart';
import 'package:teachme_ai/blocs/generate_course/generate_course_state.dart';
import 'package:teachme_ai/blocs/settings/settings_bloc.dart';
import 'package:teachme_ai/blocs/settings/settings_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/course_card.dart';
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
                  SliverToBoxAdapter(
                    child: Card(
                      color: AppColors.cardColor,
                      elevation: AppDimensions.listCardElevation,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      margin: EdgeInsets.zero,
                      child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                "Generating course...",
                                style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  color: AppColors.secondaryColor,
                                ),
                              ),
                            ],
                          ).withPadding(
                            EdgeInsets.symmetric(
                              horizontal: AppDimensions.pagePadding,
                              vertical: AppDimensions.pagePadding / 2,
                            ),
                          ),
                    ).withPadding(),
                  ),
                SliverToBoxAdapter(
                  child: BlocBuilder<SettingsBloc, SettingsState>(
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
                  ),
                ),
                SliverToBoxAdapter(
                  child: Card(
                    margin: EdgeInsets.zero,
                    color: AppColors.cardColor,
                    elevation: AppDimensions.cardElevation,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.searchBarRadius,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 2.0,
                      ),
                      child: TextField(
                        onChanged: (value) {
                          context.read<CourseBloc>().add(
                            CourseSearchEvent(value),
                          );
                        },
                        decoration: InputDecoration(
                          icon: Icon(
                            Icons.search,
                            color: AppColors.secondaryColor,
                          ),
                          hintText: 'Search your courses',
                          hintStyle: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 14,
                          ),
                          labelStyle: TextStyle(
                            color: AppColors.secondaryColor,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ).withPadding(),
                ),
                SliverToBoxAdapter(child: SubscriptionBanner()),
                SliverToBoxAdapter(
                  child: Text(
                    "My Courses",
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ).withPadding(),
                ),
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
                                style: TextStyle(
                                  color: AppColors.secondaryColor,
                                ),
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
                SliverToBoxAdapter(
                  child: SizedBox(
                    height:
                        MediaQuery.of(context).padding.bottom +
                        AppDimensions.pagePadding,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

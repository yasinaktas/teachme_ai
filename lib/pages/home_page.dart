import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/blocs/course/course_bloc.dart';
import 'package:teachme_ai/blocs/course/course_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
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
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: AppColors.secondaryColor),
                      hintText: 'Search your courses',
                      hintStyle: TextStyle(color: AppColors.secondaryColor),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ).withPadding(),
            ),
            SliverToBoxAdapter(
              child: Card(
                margin: EdgeInsets.zero,
                color: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/subscription");
                  },
                  borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
                  child: ListTile(
                    leading: Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 32,
                    ),
                    title: Text(
                      "Discover",
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      "Subscriptions",
                      style: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    trailing: Container(
                      width: 80,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        spacing: 4,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "view",
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ).withPadding(),
            ),
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
                } else if (state.courses.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'No courses available',
                        style: TextStyle(color: AppColors.secondaryColor),
                      ),
                    ),
                  );
                } else {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final course = state.courses[index];
                      return Card(
                        margin: EdgeInsets.zero,
                        color: AppColors.cardColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: AppColors.secondaryColor.withAlpha(50),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/course",
                              arguments: course,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(course.title),
                                  subtitle: Text(
                                    course.description,
                                    style: TextStyle(
                                      color: AppColors.secondaryColor,
                                    ),
                                  ),
                                  trailing: Icon(Icons.keyboard_arrow_right),
                                  leading: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: CircularProgressIndicator(
                                      value:
                                          course.chapters.fold(
                                            0,
                                            (value, chapter) => value +=
                                                chapter.isCompleted ? 1 : 0,
                                          ) /
                                          course.chapters.length,
                                      backgroundColor:
                                          AppColors.primaryShadowColor,
                                      color: AppColors.primaryColor,
                                      strokeWidth: 6.0,
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: AppColors.secondaryShadowColor,
                                  thickness: 0.5,
                                  indent: 8,
                                  endIndent: 8,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          spacing: 4,
                                          children: [
                                            Icon(
                                              Icons.calendar_today,
                                              color: AppColors.secondaryColor,
                                              size: 20,
                                            ),
                                            Text(
                                              " ${course.createdAt.toLocal().toIso8601String().split('T')[0]}",
                                              style: TextStyle(
                                                color: AppColors.secondaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          spacing: 4,
                                          children: [
                                            Icon(
                                              Icons.book_outlined,
                                              color: AppColors.secondaryColor,
                                              size: 20,
                                            ),
                                            Text(
                                              " ${course.chapters.length} chapters",
                                              style: TextStyle(
                                                color: AppColors.secondaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).withPadding();
                    }, childCount: state.courses.length),
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
  }
}

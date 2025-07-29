import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/blocs/course/course_bloc.dart';
import 'package:teachme_ai/blocs/course/course_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/course_card.dart';
import 'package:teachme_ai/widgets/subscription_banner.dart';

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
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello,",
                        style: GoogleFonts.quicksand(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      Text(
                        "Guest",
                        style: GoogleFonts.quicksand(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Image.asset("assets/images/panda.png", height: 80),
                ],
              ).withPadding(),
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
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: AppColors.secondaryColor),
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
                      return CourseCard(course: course);
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

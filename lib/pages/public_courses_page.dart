import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/course/course_bloc.dart';
import 'package:teachme_ai/blocs/course/course_state.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/extensions/sliver_box_extension.dart';
import 'package:teachme_ai/widgets/public_course_card.dart';
import 'package:teachme_ai/widgets/search_card.dart';
import 'package:teachme_ai/widgets/top_banner.dart';

class PublicCoursesPage extends StatelessWidget {
  const PublicCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          TopBanner(
            topText: "Public courses for",
            bottomText: "Subscribers",
            imagePath: "assets/images/tavsan.png",
            leftToRight: false,
          ).asSliverBox(),
          SearchCard(
            hintText: "Search public courses",
            onSearchChanged: (value) {},
          ).withPadding().asSliverBox(),
          Text(
            "Public Courses",
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
              } else if (state.courses.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No courses available',
                      style: AppStyles.textStyleNormal,
                    ),
                  ),
                );
              } else {
                return SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: SliverGrid.builder(
                    itemCount: state.courses.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      final course = state.courses[index];
                      return PublicCourseCard(course: course);
                    },
                  ),
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
    );
  }
}

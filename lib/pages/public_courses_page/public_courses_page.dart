import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/extensions/sliver_box_extension.dart';
import 'package:teachme_ai/pages/public_courses_page/widgets/public_courses_list.dart';
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
          const PublicCoursesList(),
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

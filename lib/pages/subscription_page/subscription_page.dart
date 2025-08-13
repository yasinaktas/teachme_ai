import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/pages/subscription_page/widgets/subscription_choice.dart';
import 'package:teachme_ai/widgets/app_elevated_button.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(toolbarHeight: 0),
      body: ListView(
        children: [
          Row(
            children: [
              Spacer(),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.secondaryColor,
                  child: Icon(
                    Icons.close,
                    color: AppColors.onCardOppositeColor,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.pagePadding),
            ],
          ),
          RichText(
            text: TextSpan(
              text: "Learn anything even more ",
              style: GoogleFonts.quicksand(
                fontSize: 32,
                color: AppColors.textColor,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: "effectively",
                  style: GoogleFonts.quicksand(
                    fontSize: 32,
                    color: AppColors.primaryDarkColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ).withPadding(),
          const SizedBox(height: AppDimensions.pagePadding),
          Row(
            children: [
              Icon(Icons.star_rounded, color: Colors.amber),
              const SizedBox(width: AppDimensions.pagePadding / 2),
              RichText(
                text: TextSpan(
                  text: "Create your own ",
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: AppColors.textColorLight,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: "customized course",
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: AppColors.textColorLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).withPadding(),
          Row(
            children: [
              Icon(Icons.star_rounded, color: Colors.amber),
              const SizedBox(width: AppDimensions.pagePadding / 2),
              RichText(
                text: TextSpan(
                  text: "Listen ",
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: AppColors.textColorLight,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: " to your course",
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: AppColors.textColorLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).withPadding(),
          Row(
            children: [
              Icon(Icons.star_rounded, color: Colors.amber),
              const SizedBox(width: AppDimensions.pagePadding / 2),
              RichText(
                text: TextSpan(
                  text: "Search for ",
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: AppColors.textColorLight,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: " public courses",
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: AppColors.textColorLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).withPadding(),
          Row(
            children: [
              Icon(Icons.star_rounded, color: Colors.amber),
              const SizedBox(width: AppDimensions.pagePadding / 2),
              RichText(
                text: TextSpan(
                  text: "Generate ",
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    color: AppColors.textColorLight,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: " questions",
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: AppColors.textColorLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: " for chapters ",
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: AppColors.textColorLight,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).withPadding(),
          const SizedBox(height: AppDimensions.pagePadding * 2),
          SubscriptionChoice(
            title: Row(
              children: [Text("Monthly", style: AppStyles.textStyleNormalWeak)],
            ),
            subtitle: Text(
              "Unlock all features",
              style: GoogleFonts.quicksand(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textColorLight,
              ),
            ),
            mainContent: Text(
              "\$9.99/month",
              style: GoogleFonts.quicksand(
                fontSize: 24,
                color: AppColors.primaryDarkColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            isSelected: false,
          ).withPadding(),
          SubscriptionChoice(
            title: Row(
              children: [
                Text("Yearly", style: AppStyles.textStyleNormalWeak),
                const SizedBox(width: AppDimensions.pagePadding / 2),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.pagePadding / 2,
                    vertical: AppDimensions.pagePadding / 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusTiny,
                    ),
                  ),
                  child: Text(
                    "BEST VALUE",
                    style: AppStyles.textStyleSmallStrong,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              "Unlock all features",
              style: GoogleFonts.quicksand(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textColorLight,
              ),
            ),
            mainContent: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\$79.99/year",
                  style: GoogleFonts.quicksand(
                    fontSize: 24,
                    color: AppColors.primaryDarkColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: AppDimensions.pagePadding / 2),
                Text(
                  "(\$6.58/month)",
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            isSelected: true,
          ).withPadding(),
          const SizedBox(height: AppDimensions.pagePadding * 2),
          AppElevatedButton(
            isActive: true,
            text: "Agree & Continue",
            backgroundColor: AppColors.primaryDarkColor,
            onPressed: () {},
          ).withPadding(),
          Text(
            "Subscribe to our premium plan to unlock all features and get the most out of your learning experience.",
            style: GoogleFonts.quicksand(
              fontSize: 12,
              color: AppColors.textColorWeak,
            ),
          ).withPadding(),
        ],
      ),
    );
  }
}

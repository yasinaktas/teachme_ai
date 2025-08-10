import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';

class SearchCard extends StatelessWidget {
  final String hintText;
  final Function(String) onSearchChanged;
  const SearchCard({
    super.key,
    required this.onSearchChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.cardColor,
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.searchBarRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
        child: TextField(
          onChanged: onSearchChanged,
          style: AppStyles.textStyleNormalWeak,
          decoration: InputDecoration(
            icon: Icon(
              Icons.search,
              color: AppColors.secondaryColor,
              size: AppDimensions.iconSizeMedium,
            ),
            hintText: hintText,
            hintStyle: AppStyles.textStyleNormalLight,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

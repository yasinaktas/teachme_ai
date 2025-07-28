import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/models/navigation_item.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final List<NavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  const CustomBottomNavigationBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.cardOppositeColor,
      elevation: AppDimensions.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == selectedIndex;
          return Material(
            color: isSelected
                ? AppColors.primaryShadowColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppDimensions.cardRadius - 4),
            child: InkWell(
              onTap: () => onItemSelected(index),
              borderRadius: BorderRadius.circular(AppDimensions.cardRadius - 4),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    Icon(
                      item.iconData,
                      color: isSelected
                          ? AppColors.primaryColor
                          : AppColors.secondaryColor,
                    ),
                    Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primaryColor
                            : AppColors.secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

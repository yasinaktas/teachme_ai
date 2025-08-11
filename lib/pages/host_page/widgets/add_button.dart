import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';

class AddButton extends StatelessWidget {
  final Function onPressed;
  const AddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardOppositeColor,
      borderRadius: BorderRadius.circular(AppDimensions.bottomCardRadius),
      elevation: AppDimensions.cardElevation,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.bottomCardRadius),
        splashColor: AppColors.splashColor,
        onTap: () {
          onPressed();
        },
        child: Container(
          height: 60,
          width: 60,
          alignment: Alignment.center,
          child: Icon(Icons.add, color: AppColors.primaryColor),
        ),
      ),
    );
  }
}

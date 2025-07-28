import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';

class AddButton extends StatelessWidget {
  final Function onPressed;
  const AddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardColor,
      borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
      elevation: AppDimensions.cardElevation,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
        splashColor: Colors.black.withAlpha(30),
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

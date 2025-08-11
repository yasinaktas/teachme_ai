import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';

class PasswordPolicy extends StatelessWidget {
  final bool isEightCharacters;
  final bool isNumber;
  final bool isUppercase;
  final bool isSpecialCharacter;
  const PasswordPolicy({
    super.key,
    required this.isEightCharacters,
    required this.isNumber,
    required this.isUppercase,
    required this.isSpecialCharacter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "• 8 characters",
                style: AppStyles.textStyleNormalWeak.copyWith(
                  color: isEightCharacters
                      ? Colors.green
                      : AppColors.secondaryColor,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "• Number",
                style: AppStyles.textStyleNormalWeak.copyWith(
                  color: isNumber ? Colors.green : AppColors.secondaryColor,
                ),
              ),
            ),
          ],
        ).withPadding(const EdgeInsets.only(left: 8.0)),
        const SizedBox(height: 8.0),
        Row(
          children: [
            Expanded(
              child: Text(
                "• Uppercase",
                style: AppStyles.textStyleNormalWeak.copyWith(
                  color: isUppercase ? Colors.green : AppColors.secondaryColor,
                ),
              ),
            ),
            Expanded(
              child: Text(
                "• Special character",
                style: AppStyles.textStyleNormalWeak.copyWith(
                  color: isSpecialCharacter
                      ? Colors.green
                      : AppColors.secondaryColor,
                ),
              ),
            ),
          ],
        ).withPadding(const EdgeInsets.only(left: 8.0, top: 4.0)),
      ],
    );
  }
}

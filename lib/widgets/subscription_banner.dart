import 'package:flutter/material.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teachme_ai/widgets/list_card.dart';

class SubscriptionBanner extends StatelessWidget {
  const SubscriptionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ListCard(
      onTap: () {
        Navigator.pushNamed(context, "/subscription");
      },
      color: AppColors.primaryColor,
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(
            FontAwesomeIcons.graduationCap,
            color: Colors.white,
            size: AppDimensions.iconSizeMedium,
          ),
        ),
        title: Text("Learn", style: AppStyles.textStyleNormalOnSurface),
        subtitle: Text("Everything", style: AppStyles.textStyleLargeOnSurface),
        trailing: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(AppDimensions.listCardRadius),
          ),
          child: Row(
            spacing: 4,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("subscribe", style: AppStyles.textStyleNormalOnSurface),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
            ],
          ),
        ),
      ),
    ).withPadding();
  }
}

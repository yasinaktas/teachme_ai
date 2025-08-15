import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teachme_ai/blocs/auth/auth_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_event.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/pages/drawer_page/widgets/drawer_list_tile.dart';
import 'package:teachme_ai/widgets/app_alert_dialog.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      backgroundColor: AppColors.backgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/images/panda.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      "TeachMe.ai",
                      style: TextStyle(
                        color: AppColors.primaryDarkColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            DrawerListTile(
              title: "My Subscription",
              icon: FontAwesomeIcons.crown,
              iconColor: Colors.orangeAccent,
              iconSize: AppDimensions.iconSizeSmall,
              onTap: () {},
            ),
            DrawerListTile(
              title: "My Profile",
              icon: Icons.person_outline,
              iconColor: AppColors.primaryColor,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/profile");
              },
            ),
            DrawerListTile(
              title: "My Statistics",
              icon: Icons.bar_chart_outlined,
              iconColor: AppColors.primaryColor,
              onTap: () {},
            ),
            const Spacer(),
            DrawerListTile(
              title: "Settings",
              icon: Icons.settings_outlined,
              hasDivider: true,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/settings");
              },
            ),
            DrawerListTile(
              title: "Privacy Policy",
              icon: Icons.privacy_tip_outlined,
              hasDivider: true,
              onTap: () {},
            ),
            DrawerListTile(
              title: "Terms and Conditions",
              icon: Icons.article_outlined,
              onTap: () {},
            ),
            DrawerListTile(
              title: "Logout",
              icon: Icons.logout,
              hasDivider: true,
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AppAlertDialog(
                      title: "Logout",
                      content: "Are you sure you want to logout?",
                      actionButtonText: "Logout",
                      onActionButtonPressed: () {
                        context.read<AuthBloc>().add(SignOutRequested());
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

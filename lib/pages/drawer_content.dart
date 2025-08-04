import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/constants/app_colors.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      backgroundColor: AppColors.backgroundColor,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(),
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
          ListTile(
            leading: Icon(
              FontAwesomeIcons.crown,
              color: Colors.orangeAccent,
              size: 18,
            ),
            title: Text(
              "My Subscription",
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {},
          ),

          Spacer(),
          Divider(color: AppColors.secondarySurfaceColor),
          ListTile(
            leading: Icon(
              Icons.privacy_tip_outlined,
              color: AppColors.secondaryColor,
            ),
            title: Text(
              "Privacy Policy",
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.article_outlined,
              color: AppColors.secondaryColor,
            ),
            title: Text(
              "Terms and Conditions",
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {},
          ),
          Divider(color: AppColors.secondarySurfaceColor),
          ListTile(
            leading: Icon(Icons.logout, color: AppColors.secondaryColor),
            title: Text(
              "Logout",
              style: GoogleFonts.quicksand(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {},
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

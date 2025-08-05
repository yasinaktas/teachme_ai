import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/blocs/auth/auth_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_event.dart';
import 'package:teachme_ai/blocs/auth/auth_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil("/auth", (route) => false);
          });
        }
      },
      child: Drawer(
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
            ListTile(
              leading: Icon(
                Icons.person_outline,
                color: AppColors.primaryColor,
              ),
              title: Text(
                "My Profile",
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.bar_chart_outlined,
                color: AppColors.primaryColor,
              ),
              title: Text(
                "My Statistics",
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
                Icons.settings_outlined,
                color: AppColors.secondaryColor,
              ),
              title: Text(
                "Settings",
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {},
            ),
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
              onTap: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }
}

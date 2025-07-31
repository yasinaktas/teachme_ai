import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_strings.dart';
import 'package:teachme_ai/pages/login_page.dart';
import 'package:teachme_ai/pages/signup_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [LoginPage(), SignupPage()];
    return DefaultTabController(
      length: pages.length,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            AppStrings.appName,
            style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 16.0),
              TabBar(
                dividerHeight: 0,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 32),
                indicatorColor: AppColors.primaryDarkColor,
                labelColor: AppColors.primaryDarkColor,
                unselectedLabelColor: AppColors.secondaryColor,
                labelStyle: GoogleFonts.quicksand(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                tabs: [
                  Tab(text: "Log in"),
                  Tab(text: "Sign up"),
                ],
              ),
              Expanded(child: TabBarView(children: pages)),
            ],
          ),
        ),
      ),
    );
  }
}

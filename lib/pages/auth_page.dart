import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/blocs/auth/auth_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_strings.dart';
import 'package:teachme_ai/pages/login_page.dart';
import 'package:teachme_ai/pages/signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final List<Widget> pages = [LoginPage(), SignupPage()];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
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
              actions: [
                Visibility(
                  visible: state is AuthLoading,
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: AppDimensions.pagePadding),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 16.0),
                  TabBar(
                    controller: tabController,
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
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: pages,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

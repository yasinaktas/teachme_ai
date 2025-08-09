import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/blocs/auth/auth_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_strings.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
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
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushReplacementNamed('/host');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppDimensions.pagePadding),
                      ),
                      border: Border.all(color: AppColors.primaryShadowColor),
                      color: AppColors.primarySurfaceColor,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.pagePadding,
                      vertical: AppDimensions.pagePadding,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello,",
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryColor,
                              ),
                            ),
                            Text(
                              "Welcome",
                              style: GoogleFonts.quicksand(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Image.asset(
                          "assets/images/panda_welcome.png",
                          height: 80,
                        ),
                      ],
                    ),
                  ).withPadding(),
                  const SizedBox(height: 16.0),
                  Card(
                    margin: EdgeInsets.zero,
                    color: AppColors.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.listCardRadius,
                      ),
                    ),
                    child: TabBar(
                      controller: tabController,
                      dividerHeight: 0,
                      indicator: BoxDecoration(),
                      labelColor: AppColors.primaryDarkColor,
                      unselectedLabelColor: AppColors.secondaryColor,
                      labelStyle: GoogleFonts.quicksand(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      labelPadding: EdgeInsets.zero,
                      tabs: [
                        Tab(text: "Login"),
                        Tab(text: "Register"),
                      ],
                    ),
                  ).withPadding(
                    EdgeInsets.symmetric(
                      horizontal: AppDimensions.pagePadding,
                      vertical: 8.0,
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        LoginPage(
                          onSwitchToSignup: () {
                            tabController.animateTo(1);
                          },
                        ),
                        SignupPage(
                          onSwithToLogin: () {
                            tabController.animateTo(0);
                          },
                        ),
                      ],
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

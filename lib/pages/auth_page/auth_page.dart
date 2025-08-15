import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_strings.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/extensions/sliver_box_extension.dart';
import 'package:teachme_ai/pages/auth_page/login_page.dart';
import 'package:teachme_ai/pages/auth_page/signup_page.dart';
import 'package:teachme_ai/widgets/app_snack_bar.dart';
import 'package:teachme_ai/widgets/circular_progress.dart';
import 'package:teachme_ai/widgets/list_card.dart';
import 'package:teachme_ai/widgets/top_banner.dart';

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
          AppSnackBar.show(
            context,
            message: "Welcome back, ${state.username}!",
          );
          Navigator.of(context).pushReplacementNamed('/host');
        } else if (state is AuthError) {
          AppErrorSnackBar.show(context, message: state.message);
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
                style: AppStyles.textStylePageTitle,
              ),
              actions: [
                Visibility(
                  visible: state is AuthLoading,
                  child: CircularProgress(),
                ),
                SizedBox(width: AppDimensions.pagePadding),
              ],
            ),
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  TopBanner(
                    topText: "Hello,",
                    bottomText: "Welcome",
                    imagePath: "assets/images/panda_welcome.png",
                  ).asSliverBox(),
                  const SizedBox(height: 16.0).asSliverBox(),
                  ListCard(
                        child: TabBar(
                          controller: tabController,
                          dividerHeight: 0,
                          splashBorderRadius: BorderRadius.circular(
                            AppDimensions.listCardRadius,
                          ),
                          indicator: BoxDecoration(),
                          labelColor: AppColors.primaryDarkColor,
                          unselectedLabelColor: AppColors.secondaryColor,
                          labelStyle: AppStyles.textStyleLarge,
                          labelPadding: EdgeInsets.zero,
                          tabs: [
                            Tab(text: "Login"),
                            Tab(text: "Register"),
                          ],
                        ),
                      )
                      .withPadding(
                        const EdgeInsets.symmetric(
                          horizontal: AppDimensions.pagePadding,
                          vertical: AppDimensions.pagePadding / 2,
                        ),
                      )
                      .asSliverBox(),
                  SliverFillRemaining(
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

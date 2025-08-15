import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_state.dart';
import 'package:teachme_ai/blocs/cache/cache_bloc.dart';
import 'package:teachme_ai/blocs/cache/cache_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/pages/profile_page/widgets/app_language_selector.dart';
import 'package:teachme_ai/pages/profile_page/widgets/delete_account.dart';
import 'package:teachme_ai/widgets/app_expansion_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil("/auth", (route) => false);
        });
      },
      child: BlocBuilder<CacheBloc, CacheState>(
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundColor,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: Text("My Profile", style: AppStyles.textStylePageTitle),
            ),
            body: ListView(
              children: [
                Text(
                  "My Information",
                  style: AppStyles.textStyleTitleStrong,
                ).withPadding(),
                AppExpansionTile(
                  leadingIcon: Icons.person_outline,
                  title: "Username",
                  subtitle: state.username,
                ).withPadding(),
                AppExpansionTile(
                  leadingIcon: Icons.email_outlined,
                  title: "Email",
                  subtitle: state.email,
                ).withPadding(),
                Text(
                  "My Preferences",
                  style: AppStyles.textStyleTitleStrong,
                ).withPadding(),
                AppExpansionTile(
                  leadingIcon: Icons.language_outlined,
                  title: "Language",
                  subtitle: state.appLanguage,
                  children: [
                    const AppLanguageSelector(),
                    const SizedBox(height: AppDimensions.pagePadding),
                  ],
                ).withPadding(),
                Text(
                  "My Account",
                  style: AppStyles.textStyleTitleStrong,
                ).withPadding(),
                AppExpansionTile(
                  leadingIcon: Icons.account_circle_outlined,
                  title: "Account Status",
                  subtitle: "Delete My Account",
                  children: [
                    const DeleteAccount(),
                    const SizedBox(height: AppDimensions.pagePadding),
                  ],
                ).withPadding(),
              ],
            ),
          );
        },
      ),
    );
  }
}

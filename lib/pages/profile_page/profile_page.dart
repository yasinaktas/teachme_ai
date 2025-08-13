import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/settings/settings_bloc.dart';
import 'package:teachme_ai/blocs/settings/settings_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/pages/profile_page/widgets/app_language_selector.dart';
import 'package:teachme_ai/widgets/app_expansion_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
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
                  AppLanguageSelector(),
                  const SizedBox(height: AppDimensions.pagePadding),
                ],
              ).withPadding(),
            ],
          ),
        );
      },
    );
  }
}

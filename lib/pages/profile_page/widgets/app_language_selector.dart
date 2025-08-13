import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/settings/settings_bloc.dart';
import 'package:teachme_ai/blocs/settings/settings_event.dart';
import 'package:teachme_ai/blocs/settings/settings_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_languages.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/app_choice_chip.dart';

class AppLanguageSelector extends StatelessWidget {
  const AppLanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) {
        return previous.appLanguage != current.appLanguage;
      },
      builder: (context, state) {
        return Wrap(
          spacing: 8,
          children: AppLanguages.languages.map((language) {
            final isSelected = state.appLanguage == language.name;
            return AppChoiceChip(
              text: language.name,
              backgroundColor: AppColors.cardColor,
              isSelected: isSelected,
              onSelected: (selected) {
                context.read<SettingsBloc>().add(
                  SetAppLanguageEvent(language.name),
                );
              },
            );
          }).toList(),
        );
      },
    ).withPadding();
  }
}

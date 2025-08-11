import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/settings/settings_bloc.dart';
import 'package:teachme_ai/blocs/settings/settings_state.dart';
import 'package:teachme_ai/widgets/top_banner.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return TopBanner(
          topText: "Hello,",
          bottomText: state.username.isNotEmpty ? state.username : "Guest",
          imagePath: "assets/images/panda3.png",
          leftToRight: true,
        );
      },
    );
  }
}

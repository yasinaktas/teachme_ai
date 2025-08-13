import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushReplacementNamed(context, '/host');
        } else if (state is Unauthenticated) {
          Navigator.pushReplacementNamed(context, '/auth');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        extendBody: true,
        appBar:
            AppBar(),
      ),
    );
  }
}

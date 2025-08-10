import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_event.dart';
import 'package:teachme_ai/blocs/auth/auth_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/expanded_extension.dart';
import 'package:teachme_ai/widgets/app_elevated_button.dart';
import 'package:teachme_ai/widgets/app_text_field.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onSwitchToSignup;
  const LoginPage({super.key, required this.onSwitchToSignup});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        bool isActive = state is! AuthLoading;
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.pagePadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32.0),
                  Text("Your Email", style: AppStyles.textStyleNormalStrong),
                  const SizedBox(height: 8.0),
                  AppTextField(
                    controller: _emailController,
                    hintText: "Email",
                    isEnabled: isActive,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  Text("Your Password", style: AppStyles.textStyleNormalStrong),
                  const SizedBox(height: 8.0),
                  AppTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    isPassword: true,
                    isEnabled: isActive,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: !isActive ? null : () {},
                      child: Text(
                        "Forgot password?",
                        style: AppStyles.textStyleNormalPrimaryDark,
                      ),
                    ),
                  ),
                  AppElevatedButton(
                    isActive: isActive,
                    text: "Continue",
                    backgroundColor: AppColors.primaryDarkColor,
                    radius: AppDimensions.buttonRadiusMedium,
                    onPressed: () {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
                      context.read<AuthBloc>().add(
                        SignInRequested(email, password),
                      );
                    },
                  ).asExpanded(),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: AppStyles.textStyleNormalLight,
                      ),
                      TextButton(
                        onPressed: () {
                          widget.onSwitchToSignup();
                        },
                        child: Text(
                          "Sign up",
                          style: AppStyles.textStyleNormalPrimaryDark,
                        ),
                      ),
                    ],
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_event.dart';
import 'package:teachme_ai/blocs/auth/auth_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/expanded_extension.dart';
import 'package:teachme_ai/pages/auth_page/widgets/password_policy.dart';
import 'package:teachme_ai/widgets/app_elevated_button.dart';
import 'package:teachme_ai/widgets/app_snack_bar.dart';
import 'package:teachme_ai/widgets/app_text_field.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback onSwithToLogin;
  const SignupPage({super.key, required this.onSwithToLogin});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  bool isEightCharacters = false;
  bool isNumber = false;
  bool isUppercase = false;
  bool isSpecialCharacter = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
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
                  Text("Your Username", style: AppStyles.textStyleNormalStrong),
                  const SizedBox(height: 8.0),
                  AppTextField(
                    controller: _usernameController,
                    hintText: "Username",
                    isEnabled: !isLoading,
                  ),
                  const SizedBox(height: 16.0),
                  Text("Your Email", style: AppStyles.textStyleNormalStrong),
                  const SizedBox(height: 8.0),
                  AppTextField(
                    controller: _emailController,
                    hintText: "Email",
                    isEnabled: !isLoading,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  Text("Your Password", style: AppStyles.textStyleNormalStrong),
                  const SizedBox(height: 8.0),
                  AppTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    isPassword: true,
                    isEnabled: !isLoading,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (value) {
                      setState(() {
                        isEightCharacters = value.length >= 8;
                        isNumber = value.contains(RegExp(r'\d'));
                        isUppercase = value.contains(RegExp(r'[A-Z]'));
                        isSpecialCharacter = value.contains(
                          RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
                        );
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  PasswordPolicy(
                    isEightCharacters: isEightCharacters,
                    isNumber: isNumber,
                    isUppercase: isUppercase,
                    isSpecialCharacter: isSpecialCharacter,
                  ),
                  const SizedBox(height: 32.0),
                  AppElevatedButton(
                    isActive: !isLoading,
                    text: "Register",
                    backgroundColor: AppColors.primaryDarkColor,
                    radius: AppDimensions.buttonRadiusMedium,
                    onPressed: () {
                      final email = _emailController.text.trim();
                      final password = _passwordController.text.trim();
                      final username = _usernameController.text.trim();

                      if (email.isEmpty ||
                          password.isEmpty ||
                          username.isEmpty) {
                        AppErrorSnackBar.show(
                          context,
                          message: "Please fill in all fields",
                        );
                        return;
                      }

                      if (!isEightCharacters ||
                          !isNumber ||
                          !isUppercase ||
                          !isSpecialCharacter) {
                        AppErrorSnackBar.show(
                          context,
                          message: "Password must meet all requirements",
                        );
                        return;
                      }

                      context.read<AuthBloc>().add(
                        SignUpRequested(email, password, username),
                      );
                    },
                  ).asExpanded(),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Have an account?",
                        style: AppStyles.textStyleNormalLight,
                      ),
                      TextButton(
                        onPressed: () {
                          widget.onSwithToLogin();
                        },
                        child: Text(
                          "Log in",
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

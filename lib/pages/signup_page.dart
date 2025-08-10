import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_event.dart';
import 'package:teachme_ai/blocs/auth/auth_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';
import 'package:teachme_ai/constants/app_styles.dart';
import 'package:teachme_ai/extensions/expanded_extension.dart';
import 'package:teachme_ai/extensions/padding_extension.dart';
import 'package:teachme_ai/widgets/app_elevated_button.dart';
import 'package:teachme_ai/widgets/app_text_field.dart';

class SignupPage extends StatefulWidget {
  final VoidCallback onSwithToLogin;
  const SignupPage({super.key, required this.onSwithToLogin});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isEightCharacters = false;
  bool isNumber = false;
  bool isUppercase = false;
  bool isSpecialCharacter = false;
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "• 8 characters",
                          style: AppStyles.textStyleNormalWeak.copyWith(
                            color: isEightCharacters
                                ? Colors.green
                                : AppColors.secondaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "• Number",
                          style: AppStyles.textStyleNormalWeak.copyWith(
                            color: isNumber
                                ? Colors.green
                                : AppColors.secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ).withPadding(const EdgeInsets.only(left: 8.0)),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "• Uppercase",
                          style: AppStyles.textStyleNormalWeak.copyWith(
                            color: isUppercase
                                ? Colors.green
                                : AppColors.secondaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "• Special character",
                          style: AppStyles.textStyleNormalWeak.copyWith(
                            color: isSpecialCharacter
                                ? Colors.green
                                : AppColors.secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ).withPadding(const EdgeInsets.only(left: 8.0, top: 4.0)),
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please fill in all fields")),
                        );
                        return;
                      }

                      if (!isEightCharacters ||
                          !isNumber ||
                          !isUppercase ||
                          !isSpecialCharacter) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Password must meet all requirements",
                            ),
                          ),
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

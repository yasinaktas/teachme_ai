import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:teachme_ai/blocs/auth/auth_bloc.dart';
import 'package:teachme_ai/blocs/auth/auth_event.dart';
import 'package:teachme_ai/blocs/auth/auth_state.dart';
import 'package:teachme_ai/constants/app_colors.dart';
import 'package:teachme_ai/constants/app_dimensions.dart';

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
  bool _isPasswordVisible = false;
  bool isEightCharacters = false;
  bool isNumber = false;
  bool isUppercase = false;
  bool isSpecialCharacter = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.pagePadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48.0),
                  Text(
                    "Your Username",
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    enabled: !isLoading,
                    controller: _usernameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.textFieldRadius,
                        ),
                      ),
                      hintText: 'Username',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    "Your Email",
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    enabled: !isLoading,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.textFieldRadius,
                        ),
                      ),
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    "Your Password",
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    enabled: !isLoading,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 12.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.textFieldRadius,
                        ),
                      ),
                      hintText: 'Password',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.secondaryShadowColor,
                          ),
                        ),
                      ),
                    ),
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
                          "8 characters",
                          style: GoogleFonts.quicksand(
                            color: isEightCharacters
                                ? Colors.green
                                : AppColors.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Number",
                          style: GoogleFonts.quicksand(
                            color: isNumber
                                ? Colors.green
                                : AppColors.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Uppercase",
                          style: GoogleFonts.quicksand(
                            color: isUppercase
                                ? Colors.green
                                : AppColors.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Special character",
                          style: GoogleFonts.quicksand(
                            color: isSpecialCharacter
                                ? Colors.green
                                : AppColors.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : () {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            final username = _usernameController.text.trim();
            
                            if (email.isEmpty ||
                                password.isEmpty ||
                                username.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Please fill in all fields"),
                                ),
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
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.textFieldRadius,
                              ),
                            ),
                            backgroundColor: AppColors.primaryDarkColor,
                          ),
                          child: Text(
                            "Register",
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Have an account?",
                        style: GoogleFonts.quicksand(
                          color: AppColors.secondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.onSwithToLogin();
                        },
                        child: Text(
                          "Log in",
                          style: GoogleFonts.quicksand(
                            color: AppColors.primaryDarkColor,
                            fontWeight: FontWeight.w600,
                          ),
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/di/dependency_injection.dart';
import 'package:store_app/core/helpers/spacing.dart';
import 'package:store_app/core/routing/routers.dart';
import 'package:store_app/core/utils/app_colors.dart';
import 'package:store_app/core/widgets/app_text_form_field.dart';
import 'package:store_app/core/widgets/auth_header.dart';
import 'package:store_app/core/widgets/custom_button.dart';
import 'package:store_app/core/widgets/social_btn_row.dart';
import 'package:store_app/features/login/logic/cubit.dart';
import 'package:store_app/features/login/logic/states.dart';
import '../../../core/widgets/or_divider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDemoCredentials() {
    setState(() {
      _emailController.text = 'emilys';
      _passwordController.text = 'emilyspass';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getit<LoginCubit>(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is LoginSuccess) {
            Navigator.pushReplacementNamed(context, Routers.home);
          }
        },
        builder: (context, state) {
          final cubit = context.read<LoginCubit>();
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        verticalSpace(60),
                        const AuthHeader(
                          title: 'Sign In',
                          subtitle:
                              'Welcome back! Sign in to discover the latest\nfashion trends just for you.',
                        ),
                        verticalSpace(32),
                        const SocialButtonsRow(),
                        verticalSpace(28),
                        const OrDivider(),
                        verticalSpace(28),

                        // ── Autofill Demo Button ──────────────────────────
                        // ── Demo Account Card ─────────────────────────────────
                        // ── Demo Account Card ─────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.accent.withOpacity(0.35),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 16,
                                    color: AppColors.accent,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'No registration required!',
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Use the demo account below to log in:',
                                style: TextStyle(
                                  color: AppColors.bodyText,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.person_outline,
                                    size: 14,
                                    color: AppColors.bodyText,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Username: ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.bodyText,
                                    ),
                                  ),
                                  Text(
                                    'emilys',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.title,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: const [
                                  Icon(
                                    Icons.lock_outline,
                                    size: 14,
                                    color: AppColors.bodyText,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Password: ',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.bodyText,
                                    ),
                                  ),
                                  Text(
                                    'emilyspass',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.title,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: _fillDemoCredentials,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.auto_fix_high_rounded,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        'Tap to autofill credentials',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ─────────────────────────────────────────────────────

                        // ─────────────────────────────────────────────────────   // ─────────────────────────────────────────────────
                        verticalSpace(20),
                        AppTextFormField(
                          hintText: "Email",
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            }
                            return null;
                          },
                        ),
                        verticalSpace(16),
                        AppTextFormField(
                          hintText: "Password",
                          controller: _passwordController,
                          isObscureText: _isPasswordObscure,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        verticalSpace(12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        verticalSpace(40),
                        state is LoginLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                                text: "Log In",
                                color: AppColors.primary,
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    cubit.login(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                                  }
                                },
                              ),
                        verticalSpace(24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

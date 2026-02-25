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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    bool isPasswordObscure = true;

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
                  key: formKey,
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
                        AppTextFormField(
                          hintText: "Email",
                          controller: emailController,
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
                          controller: passwordController,
                          isObscureText: isPasswordObscure,
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
                                  if (formKey.currentState!.validate()) {
                                    cubit.login(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
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

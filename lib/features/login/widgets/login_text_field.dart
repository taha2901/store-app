import 'package:flutter/material.dart';
import 'package:store_app/core/helpers/spacing.dart';
import 'package:store_app/core/utils/app_colors.dart';
import 'package:store_app/core/widgets/app_text_form_field.dart';

class LoginTextField extends StatefulWidget {
  const LoginTextField({super.key});

  @override
  State<LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<LoginTextField> {
  

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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

        verticalSpace(20),

        /// Password
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
          backFroundColor: AppColors.textFieldBg,

          suffixIcon: IconButton(
            icon: Icon(
              isPasswordObscure ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                isPasswordObscure = !isPasswordObscure;
              });
            },
          ),
        ),
      ],
    );
  }
}

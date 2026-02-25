import 'package:flutter/material.dart';
import 'package:store_app/core/routing/routers.dart';

import '../../../core/utils/app_colors.dart';

class DontHaveAccountWidget extends StatelessWidget {
  const DontHaveAccountWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.hintText,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, Routers.signUp);
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

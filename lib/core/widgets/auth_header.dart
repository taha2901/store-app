import 'package:flutter/material.dart';
import 'package:store_app/core/utils/app_colors.dart';

// class AuthHeader extends StatelessWidget {
//   final String title;
//   final String subtitle;

//   const AuthHeader({
//     super.key,
//     required this.title,
//     required this.subtitle,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text(
//           title,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.w600,
//             color: AppColors.title,
//           ),
//         ),
//         const SizedBox(height: 16), // verticalSpace(16)
//         Text(
//           subtitle,
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontSize: 14,
//             fontWeight: FontWeight.w400,
//             color: AppColors.bodyText,
//           ),
//         ),
//       ],
//     );
//   }
// }



class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.title,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.bodyText,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

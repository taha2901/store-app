import 'package:flutter/material.dart';
import 'package:store_app/core/utils/app_colors.dart';
import 'custom_button.dart';

// class SocialButtonsRow extends StatelessWidget {
//   final VoidCallback? onFacebookTap;
//   final VoidCallback? onGoogleTap;

//   const SocialButtonsRow({
//     super.key,
//     this.onFacebookTap,
//     this.onGoogleTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: CustomButton(
//             text: 'Facebook',
//             textColor: AppColors.bodyText,
//             onTap: onFacebookTap ?? () {},
//             icon: Image.asset(
//               "assets/images/Facebook.png",
//               width: 25,
//               height: 25,
//             ),
//           ),
//         ),
//         const SizedBox(width: 20), // horizontalSpace(20)
//         Expanded(
//           child: CustomButton(
//             text: 'Google',
//             textColor: AppColors.bodyText,
//             onTap: onGoogleTap ?? () {},
//             icon: Image.asset(
//               "assets/images/Google.png",
//               width: 25,
//               height: 25,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }



class SocialButtonsRow extends StatelessWidget {
  final VoidCallback? onFacebookTap;
  final VoidCallback? onGoogleTap;

  const SocialButtonsRow({
    super.key,
    this.onFacebookTap,
    this.onGoogleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SocialBtn(
            label: 'Facebook',
            icon: Icons.facebook_rounded,
            iconColor: const Color(0xFF1877F2),
            onTap: onFacebookTap ?? () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SocialBtn(
            label: 'Google',
            icon: Icons.g_mobiledata_rounded,
            iconColor: const Color(0xFFEA4335),
            onTap: onGoogleTap ?? () {},
          ),
        ),
      ],
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SocialBtn({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.title,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


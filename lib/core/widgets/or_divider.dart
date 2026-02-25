import 'package:flutter/material.dart';
import 'package:store_app/core/utils/app_colors.dart';

// class OrDivider extends StatelessWidget {
//   final String text;

//   const OrDivider({super.key, this.text = 'or'});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Expanded(
//           child: Divider(color: AppColors.divider),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           child: Text(
//             text,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//               color: AppColors.textDark,
//             ),
//           ),
//         ),
//         const Expanded(
//           child: Divider(color: AppColors.divider),
//         ),
//       ],
//     );
//   }
// }



class OrDivider extends StatelessWidget {
  final String text;
  const OrDivider({super.key, this.text = 'Or'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.bodyText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.divider, thickness: 1)),
      ],
    );
  }
}
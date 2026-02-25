// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomButton extends StatelessWidget {
//   const CustomButton({
//     super.key,
//     this.onTap,
    
//     required this.text,
//     this.isLoading = false,
//     this.icon, // 👈 الأيقونة أو الصورة
//     this.color = const Color(0xFFF5F9FE), 
//     this.textColor =  Colors.white,
//   });

//   final void Function()? onTap;
//   final Color color;
//   final Color textColor;
//   final bool isLoading;
//   final String text;
//   final Widget? icon; // 👈 ممكن Icon أو Image

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: isLoading ? null : onTap,
//       child: Container(
//         width: double.infinity,
//         height: 60.h,
//         decoration: ShapeDecoration(
//           color: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15.r),
//           ),
//         ),
//         child: isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(color: Colors.white),
//               )
//             : Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (icon != null) ...[
//                     icon!,
//                     SizedBox(width: 8.w),
//                   ],
//                   Text(
//                     text,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 16.sp,
//                       fontWeight: FontWeight.w600,
//                       color: textColor,
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:store_app/core/utils/app_colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    required this.text,
    this.isLoading = false,
    this.icon,
    this.color = AppColors.primary,
    this.textColor = Colors.white,
    this.borderRadius,
  });

  final void Function()? onTap;
  final Color color;
  final Color textColor;
  final bool isLoading;
  final String text;
  final Widget? icon;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 14),
          ),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 8)],
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

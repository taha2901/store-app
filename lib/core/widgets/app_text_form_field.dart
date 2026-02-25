import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:store_app/core/utils/app_colors.dart';

// class AppTextFormField extends StatelessWidget {
//   final String hintText;
//   final String? Function(String?) validator;
//   final TextEditingController? controller;
//   final Color? backFroundColor;
//   final bool? isObscureText;
//   final Widget? suffixIcon;
//   final EdgeInsetsGeometry? contentPadding;
//   final InputBorder? focusedBorder;
//   final InputBorder? enabledBorder;
//   final TextStyle? hintStyle;
//   final TextStyle? inputTextStyle;

//   const AppTextFormField({
//     super.key,
//     required this.hintText,

//     this.isObscureText,
//     this.suffixIcon,
//     this.contentPadding,
//     this.focusedBorder,
//     this.enabledBorder,
//     this.hintStyle,
//     this.inputTextStyle,
//     this.backFroundColor,
//     required this.validator,
//     this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final borderRadius = BorderRadius.circular(25.r);

//     OutlineInputBorder getBorder(Color color) {
//       return OutlineInputBorder(
//         borderRadius: borderRadius,
//         borderSide: BorderSide(color: color, width: 1.5),
//       );
//     }

//     return TextFormField(
//       controller: controller,
//       validator: validator,
//       obscureText: isObscureText ?? false,
//       style: inputTextStyle ?? TextStyle(color: Colors.black, fontSize: 14.sp),
//       decoration: InputDecoration(
//         isDense: true,
//         contentPadding:
//             contentPadding ??
//             EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
//         hintText: hintText,
//         hintStyle: hintStyle ?? TextStyle(color: Colors.grey, fontSize: 14.sp),
//         suffixIcon: suffixIcon,
//         filled: true,
//         fillColor: backFroundColor ?? const Color(0xFFF5F9FE),

//         // Borders لجميع الحالات مع المحافظة على الـ radius
//         border: getBorder(Colors.transparent),
//         enabledBorder: getBorder(Colors.transparent),
//         focusedBorder: getBorder(Colors.blue.withOpacity(0.5)), // عند التركيز
//         errorBorder: getBorder(Colors.redAccent),
//         focusedErrorBorder: getBorder(Colors.redAccent),
//       ),
//     );
//   }
// }




class AppTextFormField extends StatelessWidget {
  final String hintText;
  final String? Function(String?) validator;
  final TextEditingController? controller;
  final Color? backFroundColor;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? hintStyle;
  final TextStyle? inputTextStyle;

  const AppTextFormField({
    super.key,
    required this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.hintStyle,
    this.inputTextStyle,
    this.backFroundColor,
    required this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(14);

    OutlineInputBorder getBorder(Color color) {
      return OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: color, width: 1.5),
      );
    }

    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isObscureText ?? false,
      style: inputTextStyle ??
          const TextStyle(color: AppColors.title, fontSize: 14),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintText: hintText,
        hintStyle:
            hintStyle ?? const TextStyle(color: AppColors.hintText, fontSize: 14),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: backFroundColor ?? AppColors.textFieldBg,
        border: getBorder(Colors.transparent),
        enabledBorder: getBorder(Colors.transparent),
        focusedBorder:
            getBorder(AppColors.primary.withOpacity(0.4)),
        errorBorder: getBorder(Colors.redAccent),
        focusedErrorBorder: getBorder(Colors.redAccent),
      ),
    );
  }
}

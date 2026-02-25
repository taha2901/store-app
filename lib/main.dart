import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:store_app/core/di/dependency_injection.dart';
import 'package:store_app/core/routing/app_router.dart';
import 'package:store_app/store_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // لازم تنتظر ScreenUtil و GetIt يخلصوا
  await ScreenUtil.ensureScreenSize();

  // ✅ سجل كل الـ dependencies قبل runApp
  await setUpGetIt();

  runApp(
    StoreApp(appRouter: AppRouter()),
  );
}


// Future<void> checkLoggedInUser() async {
//   String? userToken = await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
//   if (!userToken.isNullOrEmpty()) {
//     isLoggedInUser = true;
//   } else {
//     isLoggedInUser = false;
//   }
// }
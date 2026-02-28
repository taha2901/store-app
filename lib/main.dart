import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:store_app/core/di/dependency_injection.dart';
import 'package:store_app/core/routing/app_router.dart';
import 'package:store_app/store_app.dart';

void main() async {
  // 1️⃣ لازم يكون أول سطر
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  
  // 2️⃣ قوله "افضل شاغل"
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await ScreenUtil.ensureScreenSize();
  await setUpGetIt();

  // 3️⃣ بعد ما كل حاجة اتحملت، شيله
  FlutterNativeSplash.remove();

  runApp(
    StoreApp(appRouter: AppRouter()),
  );
}
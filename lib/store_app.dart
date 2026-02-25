import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:store_app/core/di/dependency_injection.dart';
import 'package:store_app/core/routing/app_router.dart';
import 'package:store_app/core/routing/routers.dart';
import 'package:store_app/features/cart/logic/local_cart_cubit.dart';

class StoreApp extends StatelessWidget {
  final AppRouter appRouter;
  const StoreApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      builder: (context, child) {
        final cartCubit = getit<LocalCartCubit>();

        // ← حمّل الكارت من SQLite عند بدء التطبيق
        cartCubit.loadCart();

        return BlocProvider.value(
          value: cartCubit,
          child: MaterialApp(
            title: 'Store App',
            debugShowCheckedModeBanner: false,
            initialRoute: Routers.login,
            onGenerateRoute: appRouter.generateRoute,
          ),
        );
      },
    );
  }
}
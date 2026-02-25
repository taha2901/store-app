
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/di/dependency_injection.dart';
import 'package:store_app/core/routing/routers.dart';
import 'package:store_app/core/widgets/custom_nav_bar.dart';
import 'package:store_app/features/cart/view/cart_screen_sqlite.dart';
import 'package:store_app/features/home/data/model/product_model.dart';
import 'package:store_app/features/home/logic/cubit.dart';
import 'package:store_app/features/home/views/product_detail_screen.dart';
import 'package:store_app/features/home/views/product_search_screen.dart';
import 'package:store_app/features/login/views/login_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case Routers.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case Routers.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getit<ProductCubit>()..getProducts(),
            child: const CustomBottomNavBar(),
          ),
        );

      // ✅ بسيط — LocalCartCubit موجود من فوق في MaterialApp
      case Routers.productDetail:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        );

      case Routers.productSearch:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getit<ProductCubit>(),
            child: const ProductSearchScreen(),
          ),
        );

      // ✅ بسيط — مش محتاج try/catch دلوقتي
      case Routers.cart:
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
        );

      default:
        return null;
    }
  }
}
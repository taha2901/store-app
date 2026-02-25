import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/di/dependency_injection.dart';
import 'package:store_app/core/utils/app_colors.dart';
import 'package:store_app/features/cart/view/cart_screen_sqlite.dart';
import 'package:store_app/features/home/views/home_screen.dart';
import 'package:store_app/features/todo/logic/todo_cubit.dart';
import 'package:store_app/features/todo/view/todo_screen.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getit<TodoCubit>(),
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: const [ProductListScreen(), CartScreen(), TodoScreen()],
        ),
        extendBody: true,
        bottomNavigationBar: FloatingNavBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
        ),
      ),
    );
  }
}

class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.storefront_rounded, 'label': 'Menu'},
      {'icon': Icons.shopping_bag_outlined, 'label': 'Cart'},
      {'icon': Icons.checklist_rounded, 'label': 'Tasks'},
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final isActive = currentIndex == i;
            return GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: isActive
                    ? BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                      )
                    : null,
                child: isActive
                    ? Row(
                        children: [
                          Icon(
                            items[i]['icon'] as IconData,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            items[i]['label'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Icon(
                        items[i]['icon'] as IconData,
                        color: Colors.white.withOpacity(0.5),
                        size: 22,
                      ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/widgets/section_title.dart';
import 'package:store_app/features/home/logic/cubit.dart';
import 'package:store_app/features/home/views/product_Search_screen.dart';

class SearchBarHomePage extends StatelessWidget {
  const SearchBarHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ProductCubit>(),
                    child: const ProductSearchScreen(),
                  ),
                ),
              ),
              child: const SearchBarWidget(
                  hint: 'Search products...'),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.tune_rounded,
                color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

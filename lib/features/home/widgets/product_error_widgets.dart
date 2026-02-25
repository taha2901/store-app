import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_colors.dart';
import '../logic/cubit.dart';

class ProductErrorWidget extends StatelessWidget {
  final String message;
  const ProductErrorWidget({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('😕',
              style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppColors.bodyText, fontSize: 14),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () =>
                context.read<ProductCubit>().getProducts(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Retry',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

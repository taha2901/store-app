import 'package:flutter/material.dart';

import '../../../core/utils/app_colors.dart';

class EmptyProductWidget extends StatelessWidget {
  const EmptyProductWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No products found',
          style: TextStyle(
              color: AppColors.bodyText, fontSize: 14)),
    );
  }
}

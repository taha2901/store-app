import 'package:flutter/material.dart';
import 'package:store_app/core/utils/app_colors.dart';

class HeaderHomePage extends StatelessWidget {
  const HeaderHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning 👋',
                style: TextStyle(
                    fontSize: 13, color: AppColors.bodyText),
              ),
              SizedBox(height: 2),
              Text(
                'What are you looking for?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.title,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.tagBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.title,
                  size: 20,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

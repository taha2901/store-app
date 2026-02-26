import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/di/dependency_injection.dart';
import 'package:store_app/core/utils/app_colors.dart';
import 'package:store_app/features/cart/data/model/local_cart_item.dart';
import 'package:store_app/features/cart/logic/local_cart_cubit.dart';
import 'package:store_app/features/cart/view/cart_screen_sqlite.dart';
import 'package:store_app/features/comments/data/repo/commentt_repo.dart';
import 'package:store_app/features/comments/logic/cubit.dart';
import 'package:store_app/features/comments/logic/states.dart';
import 'package:store_app/features/comments/view/comment_screen.dart';
import 'package:store_app/features/home/data/model/product_model.dart';
import 'package:store_app/features/home/widgets/info_badge.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  int selectedImageIndex = 0;
  bool isFav = false;
  bool _addedToCart = false;

  double get totalPrice => widget.product.discountedPrice * quantity;

  Future<void> _goToCart() async {
    final p = widget.product;
    final cubit = context.read<LocalCartCubit>();

    await cubit.addItem(
      LocalCartItem(
        productId: p.id,
        title: p.title,
        price: p.price,
        discountedPrice: p.discountedPrice,
        discountPercentage: p.discountPercentage,
        thumbnail: p.thumbnail,
        brand: p.brand,
        quantity: quantity,
      ),
    );

    setState(() => _addedToCart = true);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            BlocProvider.value(value: cubit, child: const CartScreen()),
      ),
    ).then((_) {
      if (mounted) setState(() => _addedToCart = false);
    });
  }

  // ✅ Navigate to ReviewScreen
  void _goToReviews() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => ReviewCubit(
            getit<ReviewRepository>(),
            productId: widget.product.id,
          ),
          child: ReviewScreen(
            productId: widget.product.id,
            productTitle: widget.product.title,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final images = p.images.isNotEmpty ? p.images : [p.thumbnail];

    return BlocProvider(
      // ✅ ReviewCubit يبدأ مع الصفحة عشان نعرض الـ avg rating في الصفحة
      create: (_) => ReviewCubit(getit<ReviewRepository>(), productId: p.id),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // ── Hero Image ──────────────────────────────────────
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.42,
                  width: double.infinity,
                  child: Image.network(
                    images[selectedImageIndex],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.tagBg,
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.hintText,
                          size: 64,
                        ),
                      ),
                    ),
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: AppColors.tagBg,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                if (images.length > 1)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(images.length, (i) {
                        return GestureDetector(
                          onTap: () => setState(() => selectedImageIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: selectedImageIndex == i ? 20 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: selectedImageIndex == i
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16,
                              color: AppColors.title,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => isFav = !isFav),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav
                                  ? AppColors.heartColor
                                  : AppColors.hintText,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Detail Card ──────────────────────────────────────
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _formatCategory(p.category),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  p.title,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.title,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                if (p.brand != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'by ${p.brand}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.bodyText,
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 6),
                                // ✅ Rating row - يعرض local avg لو موجود
                                GestureDetector(
                                  onTap: _goToReviews,
                                  child: BlocBuilder<ReviewCubit, ReviewState>(
                                    builder: (context, state) {
                                      double avg = p.rating;
                                      int count = 0; // ✅ مش p.reviews.length
                                      bool hasLocalReviews = false;

                                      if (state is ReviewLoaded &&
                                          state.reviewCount > 0) {
                                        avg = state.averageRating;
                                        count = state.reviewCount;
                                        hasLocalReviews = true;
                                      }

                                      return Row(
                                        children: [
                                          const Icon(
                                            Icons.star_rounded,
                                            color: AppColors.starColor,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            avg.toStringAsFixed(1),
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.title,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            hasLocalReviews
                                                ? '($count local reviews)'
                                                : 'Tap to review',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.bodyText,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(
                                            Icons.chevron_right_rounded,
                                            size: 14,
                                            color: AppColors.primary,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.divider),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (quantity > 1)
                                      setState(() => quantity--);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    child: Icon(
                                      Icons.remove,
                                      size: 16,
                                      color: AppColors.title,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.title,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() => quantity++),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 16,
                                      color: AppColors.title,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Text(
                            '\$${p.discountedPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.title,
                            ),
                          ),
                          if (p.discountPercentage > 0) ...[
                            const SizedBox(width: 8),
                            Text(
                              '\$${p.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.hintText,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.heartColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '-${p.discountPercentage.toStringAsFixed(0)}% OFF',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.heartColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 16),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          InfoBadge(
                            icon: Icons.inventory_2_outlined,
                            label: '${p.stock} in stock',
                          ),
                          InfoBadge(
                            icon: Icons.local_shipping_outlined,
                            label: p.shippingInformation,
                          ),
                          InfoBadge(
                            icon: Icons.assignment_return_outlined,
                            label: p.returnPolicy,
                          ),
                          if (p.warrantyInformation.isNotEmpty)
                            InfoBadge(
                              icon: Icons.verified_outlined,
                              label: p.warrantyInformation,
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Text(
                        p.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.bodyText,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 16),

                      if (p.tags.isNotEmpty) ...[
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: p.tags
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.tagBg,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: AppColors.divider,
                                    ),
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.bodyText,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                      ],

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: p.isInStock
                              ? const Color(0xFF4CAF50).withOpacity(0.08)
                              : Colors.orange.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: p.isInStock
                                ? const Color(0xFF4CAF50).withOpacity(0.3)
                                : Colors.orange.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              p.isInStock
                                  ? Icons.check_circle_outline
                                  : Icons.warning_amber_outlined,
                              size: 18,
                              color: p.isInStock
                                  ? const Color(0xFF4CAF50)
                                  : Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              p.availabilityStatus,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: p.isInStock
                                    ? const Color(0xFF4CAF50)
                                    : Colors.orange,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Min order: ${p.minimumOrderQuantity}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.bodyText,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ✅ Reviews Button
                      GestureDetector(
                        onTap: _goToReviews,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.starColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.reviews_outlined,
                                  color: AppColors.starColor,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Reviews & Ratings',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.title,
                                      ),
                                    ),
                                    Text(
                                      'See all reviews or write your own',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.bodyText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              BlocBuilder<ReviewCubit, ReviewState>(
                                builder: (context, state) {
                                  if (state is ReviewLoaded &&
                                      state.reviewCount > 0) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${state.reviewCount}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    );
                                  }
                                  return const Icon(
                                    Icons.chevron_right_rounded,
                                    color: AppColors.bodyText,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Add to Cart Button
                      GestureDetector(
                        onTap: _goToCart,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 56,
                          decoration: BoxDecoration(
                            color: _addedToCart
                                ? const Color(0xFF4CAF50)
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _addedToCart
                                    ? Icons.check_circle_outline
                                    : Icons.shopping_bag_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _addedToCart
                                    ? 'Added! View Cart'
                                    : 'Add to Cart  |  \$${totalPrice.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCategory(String slug) =>
      slug.split('-').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
}

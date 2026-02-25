import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/utils/app_colors.dart' hide AppColors;
import 'package:store_app/features/home/data/model/product_model.dart';
import 'package:store_app/features/home/logic/cubit.dart';
import 'package:store_app/features/home/logic/states.dart';
import 'package:store_app/features/home/views/product_Search_screen.dart';
import 'package:store_app/features/home/views/product_detail_screen.dart';
import 'package:store_app/core/widgets/section_title.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int _selectedCategory = 0;
  String _selectedSlug = ''; // '' means all

  // Will be populated from API
  List<String> categoryNames = ['🛍️ All'];
  List<String> categorySlugs = [''];

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProductCubit>();
    cubit.getProducts();
    cubit.getCategoryList(); // load category names too
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────
            Padding(
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
            ),

            // ── Search Bar ──────────────────────────────────
            Padding(
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
            ),

            const SizedBox(height: 20),

            // ── Categories (from API) ────────────────────────
            BlocListener<ProductCubit, ProductState>(
              listenWhen: (_, s) => s is CategoryListLoaded,
              listener: (context, state) {
                if (state is CategoryListLoaded) {
                  setState(() {
                    categoryNames = ['🛍️ All', ...state.categoryList
                        .map((s) => _formatCategory(s))];
                    categorySlugs = ['', ...state.categoryList];
                  });
                }
              },
              child: SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categoryNames.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => ChipWidget(
                    label: categoryNames[i],
                    isSelected: _selectedCategory == i,
                    onTap: () {
                      setState(() => _selectedCategory = i);
                      _selectedSlug = categorySlugs[i];
                      if (_selectedSlug.isEmpty) {
                        context.read<ProductCubit>().getProducts();
                      } else {
                        context
                            .read<ProductCubit>()
                            .getProductsByCategory(_selectedSlug);
                      }
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Products Grid ────────────────────────────────
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                buildWhen: (_, s) =>
                    s is ProductLoading ||
                    s is ProductsLoaded ||
                    s is ProductError,
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    );
                  }

                  if (state is ProductError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('😕',
                              style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
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

                  if (state is ProductsLoaded) {
                    final products = state.products;

                    if (products.isEmpty) {
                      return const Center(
                        child: Text('No products found',
                            style: TextStyle(
                                color: AppColors.bodyText, fontSize: 14)),
                      );
                    }

                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return _ProductCard(
                          product: products[index],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(
                                  product: products[index]),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCategory(String slug) {
    return slug
        .split('-')
        .map((w) => w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }
}

// ─── Product Card (uses real ProductModel) ───────────────────
class _ProductCard extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onTap;
  const _ProductCard({required this.product, required this.onTap});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool isFav = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final hasDiscount = p.discountPercentage > 0;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──────────────────────────────────────
            Expanded(
              child: Stack(
                children: [
                  // Product thumbnail from API
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      p.thumbnail,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.tagBg,
                        child: const Center(
                          child: Icon(Icons.image_not_supported_outlined,
                              color: AppColors.hintText, size: 32),
                        ),
                      ),
                      loadingBuilder: (_, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: AppColors.tagBg,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Fav button
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => setState(() => isFav = !isFav),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav
                              ? AppColors.heartColor
                              : AppColors.hintText,
                          size: 16,
                        ),
                      ),
                    ),
                  ),

                  // Discount badge
                  if (hasDiscount)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.heartColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-${p.discountPercentage.toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                  // Low stock badge
                  if (p.isLowStock)
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Low Stock',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Info ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.title,
                    ),
                  ),
                  if (p.brand != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      p.brand!,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.bodyText),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${p.discountedPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.title,
                            ),
                          ),
                          if (hasDiscount)
                            Text(
                              '\$${p.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.hintText,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.star_rounded,
                          color: AppColors.starColor, size: 13),
                      const SizedBox(width: 2),
                      Text(
                        p.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.title,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
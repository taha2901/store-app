import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/features/home/logic/cubit.dart';
import 'package:store_app/features/home/logic/states.dart';
import 'package:store_app/features/home/views/product_Search_screen.dart';
import 'package:store_app/features/home/views/product_detail_screen.dart';
import 'package:store_app/core/widgets/section_title.dart';
import 'package:store_app/features/home/widgets/empty_product_widget.dart';
import 'package:store_app/features/home/widgets/header_home_page.dart';
import 'package:store_app/features/home/widgets/product_card.dart';
import 'package:store_app/features/home/widgets/product_error_widgets.dart';
import 'package:store_app/features/home/widgets/search_bar_home_page.dart';

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
            HeaderHomePage(),

            // ── Search Bar ──────────────────────────────────
            SearchBarHomePage(),

            const SizedBox(height: 20),

            // ── Categories ────────────────────────
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
                    return ProductErrorWidget(
                      message: state.message,
                    );
                  }

                  if (state is ProductsLoaded) {
                    final products = state.products;

                    if (products.isEmpty) {
                      return EmptyProductWidget();
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
                        return ProductCard(
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
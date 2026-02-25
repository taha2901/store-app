import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/features/home/logic/cubit.dart';
import 'package:store_app/features/home/logic/states.dart';
import 'package:store_app/features/home/views/product_detail_screen.dart';

import '../data/model/product_model.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({super.key});

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String query = '';

  final List<String> recentSearches = [
    'Beauty', 'Furniture', 'Laptops', 'Smartphones', 'Groceries',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String value) {
    setState(() => query = value);
    if (value.trim().isNotEmpty) {
      context.read<ProductCubit>().searchProducts(value.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── Search Input Row ────────────────────────────
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: AppColors.title,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppColors.primary, width: 1.5),
                      ),
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        onChanged: _search,
                        onSubmitted: _search,
                        style: const TextStyle(
                            color: AppColors.title, fontSize: 14),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search products...',
                          hintStyle: const TextStyle(
                              color: AppColors.hintText, fontSize: 14),
                          prefixIcon: const Icon(Icons.search,
                              color: AppColors.hintText, size: 20),
                          suffixIcon: query.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    _controller.clear();
                                    setState(() => query = '');
                                  },
                                  child: const Icon(Icons.close,
                                      color: AppColors.hintText, size: 18),
                                )
                              : null,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ── Recent Searches (shown when query is empty) ──
              if (query.isEmpty) ...[
                const Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.title,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: recentSearches
                      .map((s) => GestureDetector(
                            onTap: () {
                              _controller.text = s;
                              _search(s);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: AppColors.divider),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.history_rounded,
                                      size: 14, color: AppColors.bodyText),
                                  const SizedBox(width: 6),
                                  Text(s,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.bodyText)),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 24),
              ],

              // ── Results / States ──────────────────────────────
              Expanded(
                child: BlocBuilder<ProductCubit, ProductState>(
                  builder: (context, state) {
                    // Show hint when idle and query empty
                    if (query.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('🔍',
                                style: TextStyle(fontSize: 48)),
                            SizedBox(height: 12),
                            Text(
                              'Search for any product',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.title),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'e.g. "beauty", "laptop", "phone"',
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.bodyText),
                            ),
                          ],
                        ),
                      );
                    }

                    // Loading
                    if (state is ProductLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      );
                    }

                    // Error
                    if (state is ProductError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(
                              color: AppColors.bodyText, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    // Results
                    if (state is ProductsLoaded) {
                      final results = state.products;

                      if (results.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('😕',
                                  style: TextStyle(fontSize: 48)),
                              SizedBox(height: 12),
                              Text(
                                'No results found',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.title,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Try a different keyword',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.bodyText),
                              ),
                            ],
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${state.total} results for "$query"',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.bodyText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: results.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (_, i) => _SearchResultTile(
                                product: results[i],
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(
                                        product: results[i]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Search Result Tile ──────────────────────────────────────
class _SearchResultTile extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  const _SearchResultTile({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final p = product;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                p.thumbnail,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: AppColors.tagBg,
                  child: const Icon(Icons.image_not_supported_outlined,
                      color: AppColors.hintText, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.title,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatCategory(p.category),
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.bodyText),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: AppColors.starColor, size: 13),
                      const SizedBox(width: 2),
                      Text(
                        p.rating.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.bodyText),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${p.discountedPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.title,
                  ),
                ),
                if (p.discountPercentage > 0)
                  Text(
                    '\$${p.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.hintText,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
              ],
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

// ============================================================
// lib/features/home/views/comment_screen.dart
// CommentsScreen — Updated to accept real ReviewModel list
// ============================================================

// import 'package:flutter/material.dart';
// import 'package:store_app/core/utils/app_colors.dart';
// import 'package:store_app/features/home/data/model/product_model.dart';
// import 'package:store_app/features/home/widgets/comment_tile.dart';
// import 'package:store_app/features/home/widgets/section_title.dart' hide BackButton;

class CommentsScreen extends StatefulWidget {
  // Real reviews passed from ProductDetailScreen
  final List<ReviewModel> reviews;

  const CommentsScreen({
    super.key,
    this.reviews = const [],
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();
  late List<ReviewModel> _reviews;

  @override
  void initState() {
    super.initState();
    _reviews = List.from(widget.reviews);
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  // Average rating
  double get avgRating {
    if (_reviews.isEmpty) return 0;
    return _reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        _reviews.length;
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;
    // In real app → call API to add comment
    // For now we add locally as a placeholder
    setState(() {
      _reviews.insert(
        0,
        ReviewModel(
          rating: 5,
          comment: _commentController.text.trim(),
          date: DateTime.now().toIso8601String(),
          reviewerName: 'You',
          reviewerEmail: 'you@example.com',
        ),
      );
      _commentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 16, color: AppColors.title),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${_reviews.length} Reviews',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.title,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            // Rating summary
            if (_reviews.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          avgRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: AppColors.title,
                            letterSpacing: -1,
                          ),
                        ),
                        const Text(
                          'out of 5',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.bodyText),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        children: List.generate(5, (i) {
                          final starVal = 5 - i;
                          final count = _reviews
                              .where((r) => r.rating == starVal)
                              .length;
                          final ratio = _reviews.isEmpty
                              ? 0.0
                              : count / _reviews.length;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                Text('$starVal',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.bodyText)),
                                const SizedBox(width: 4),
                                const Icon(Icons.star_rounded,
                                    color: AppColors.starColor, size: 12),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: ratio,
                                      backgroundColor: AppColors.tagBg,
                                      valueColor:
                                          const AlwaysStoppedAnimation(
                                              AppColors.starColor),
                                      minHeight: 6,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text('$count',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.bodyText)),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Reviews List
            Expanded(
              child: _reviews.isEmpty
                  ? const Center(
                      child: Text('No reviews yet. Be the first!',
                          style: TextStyle(
                              color: AppColors.bodyText, fontSize: 14)),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _reviews.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final r = _reviews[i];
                        return CommentTile(
                          name: r.reviewerName,
                          comment: r.comment,
                          rating: r.rating,
                          timeAgo: _formatDate(r.date),
                          isOwn: r.reviewerName == 'You',
                          onDelete: r.reviewerName == 'You'
                              ? () => setState(() => _reviews.removeAt(i))
                              : null,
                        );
                      },
                    ),
            ),

            // Add comment bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border:
                    Border(top: BorderSide(color: AppColors.divider)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _commentController,
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.title),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write a review...',
                          hintStyle: TextStyle(
                              color: AppColors.hintText, fontSize: 14),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _addComment,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} months ago';
      if (diff.inDays > 0) return '${diff.inDays} days ago';
      if (diff.inHours > 0) return '${diff.inHours} hours ago';
      return 'Just now';
    } catch (_) {
      return isoDate;
    }
  }
}

// ── Placeholder classes for standalone compilation ──────────
// (Remove these if already defined in your project)

class AppColors {
  static const Color primary = Color(0xFF1A1A1A);
  static const Color accent = Color(0xFFFF6B35);
  static const Color background = Color(0xFFF7F7F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color title = Color(0xFF1A1A1A);
  static const Color bodyText = Color(0xFF888888);
  static const Color hintText = Color(0xFFAAAAAA);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color tagBg = Color(0xFFF2F2F2);
  static const Color starColor = Color(0xFFFFC107);
  static const Color heartColor = Color(0xFFFF4B4B);
}

// Stub ReviewModel & CommentTile for reference — use your real ones
class ReviewModel {
  final int rating;
  final String comment;
  final String date;
  final String reviewerName;
  final String reviewerEmail;
  const ReviewModel({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });
}

class CommentTile extends StatelessWidget {
  final String name;
  final String comment;
  final int rating;
  final String timeAgo;
  final bool isOwn;
  final VoidCallback? onDelete;
  const CommentTile({
    super.key,
    required this.name,
    required this.comment,
    required this.rating,
    required this.timeAgo,
    this.isOwn = false,
    this.onDelete,
  });
  @override
  Widget build(BuildContext context) => const SizedBox(); // use your real widget
}
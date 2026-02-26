import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/utils/app_colors.dart';
import 'package:store_app/features/comments/data/model/review_model.dart';
import 'package:store_app/features/comments/logic/cubit.dart';
import 'package:store_app/features/comments/logic/states.dart';

class ReviewScreen extends StatefulWidget {
  final int productId;
  final String productTitle;

  const ReviewScreen({
    super.key,
    required this.productId,
    required this.productTitle,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  double _selectedRating = 5.0;
  bool _showForm = false;

  @override
  void dispose() {
    _nameController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  // ✅ FIX: بنبعت أول وبعدين بنعمل clear - مش بنعمل clear الأول
  void _submitReview(ReviewCubit cubit) {
    final name = _nameController.text.trim();
    final comment = _commentController.text.trim();

    // Validation
    if (name.isEmpty || comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in your name and comment'),
          backgroundColor: AppColors.heartColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    // ✅ أول بعت للـ cubit
    cubit.addReview(
      reviewerName: name,
      comment: comment,
      rating: _selectedRating,
    );

    // ✅ بعدين clear
    _nameController.clear();
    _commentController.clear();
    setState(() {
      _selectedRating = 5.0;
      _showForm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReviewCubit>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reviews',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.title),
                        ),
                        Text(
                          widget.productTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.bodyText),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _showForm = !_showForm),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: _showForm
                            ? AppColors.primary.withOpacity(0.1)
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                        border: _showForm
                            ? Border.all(color: AppColors.primary)
                            : null,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _showForm ? Icons.close : Icons.add,
                            size: 14,
                            color: _showForm ? AppColors.primary : Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _showForm ? 'Cancel' : 'Review',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _showForm
                                  ? AppColors.primary
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Summary Bar (fixed height) ───────────────
            BlocBuilder<ReviewCubit, ReviewState>(
              builder: (context, state) {
                double avg = 0;
                int count = 0;
                if (state is ReviewLoaded) {
                  avg = state.averageRating;
                  count = state.reviewCount;
                }
                return _RatingSummaryBar(avg: avg, count: count);
              },
            ),

            // ── Add Review Form (scrollable inside Expanded) ─
            // ✅ FIX: Form داخل Expanded مع SingleChildScrollView عشان مفيش overflow
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Form
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _showForm
                          ? _AddReviewForm(
                              nameController: _nameController,
                              commentController: _commentController,
                              selectedRating: _selectedRating,
                              onRatingChanged: (r) =>
                                  setState(() => _selectedRating = r),
                              onSubmit: () => _submitReview(cubit),
                            )
                          : const SizedBox.shrink(),
                    ),

                    // ── Reviews List ─────────────────────────────
                    BlocConsumer<ReviewCubit, ReviewState>(
                      listener: (context, state) {
                        if (state is ReviewError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: AppColors.heartColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is ReviewLoading) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.primary, strokeWidth: 2),
                            ),
                          );
                        }

                        List<LocalReview> reviews = [];
                        if (state is ReviewLoaded) reviews = state.reviews;
                        if (state is ReviewSubmitting) {
                          reviews = state.currentReviews;
                        }

                        if (reviews.isEmpty) {
                          // ✅ FIX: مش بنستخدم Expanded جوا Column - بنديه height ثابتة
                          return _EmptyReviews(
                            onAddReview: () =>
                                setState(() => _showForm = true),
                          );
                        }

                        // ✅ FIX: ListView.builder بـ shrinkWrap جوا SingleChildScrollView
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                          itemCount: reviews.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (_, i) {
                            final review = reviews[i];
                            return Dismissible(
                              key: Key('review-${review.id}'),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) => context
                                  .read<ReviewCubit>()
                                  .deleteReview(review.id),
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                decoration: BoxDecoration(
                                  color: AppColors.heartColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: AppColors.heartColor,
                                    size: 22),
                              ),
                              child: _ReviewCard(review: review),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Rating Summary Bar ──────────────────────────────────────
class _RatingSummaryBar extends StatelessWidget {
  final double avg;
  final int count;

  const _RatingSummaryBar({required this.avg, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                avg > 0 ? avg.toStringAsFixed(1) : '—',
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.title),
              ),
              _StarRow(rating: avg, size: 16),
              const SizedBox(height: 4),
              Text(
                '$count ${count == 1 ? 'review' : 'reviews'}',
                style:
                    const TextStyle(fontSize: 11, color: AppColors.bodyText),
              ),
            ],
          ),
          const SizedBox(width: 20),
          if (avg > 0)
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  final star = 5 - i;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Text('$star',
                            style: const TextStyle(
                                fontSize: 10, color: AppColors.bodyText)),
                        const SizedBox(width: 4),
                        const Icon(Icons.star_rounded,
                            size: 10, color: AppColors.starColor),
                        const SizedBox(width: 6),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: avg >= star
                                ? 1.0
                                : avg > star - 1
                                    ? (avg - (star - 1))
                                    : 0.0,
                            backgroundColor: AppColors.divider,
                            valueColor: const AlwaysStoppedAnimation(
                                AppColors.starColor),
                            minHeight: 4,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Star Row (display only) ──────────────────────────────────
class _StarRow extends StatelessWidget {
  final double rating;
  final double size;

  const _StarRow({required this.rating, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (rating >= i + 1) {
          return Icon(Icons.star_rounded,
              color: AppColors.starColor, size: size);
        } else if (rating > i) {
          return Icon(Icons.star_half_rounded,
              color: AppColors.starColor, size: size);
        } else {
          return Icon(Icons.star_outline_rounded,
              color: AppColors.divider, size: size);
        }
      }),
    );
  }
}

// ── Interactive Star Picker ──────────────────────────────────
class _StarPicker extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;

  const _StarPicker({required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return GestureDetector(
          onTap: () => onChanged((i + 1).toDouble()),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              i < rating ? Icons.star_rounded : Icons.star_outline_rounded,
              color: i < rating ? AppColors.starColor : AppColors.divider,
              size: 36,
            ),
          ),
        );
      }),
    );
  }
}

// ── Add Review Form ─────────────────────────────────────────
class _AddReviewForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController commentController;
  final double selectedRating;
  final ValueChanged<double> onRatingChanged;
  final VoidCallback onSubmit;

  const _AddReviewForm({
    required this.nameController,
    required this.commentController,
    required this.selectedRating,
    required this.onRatingChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Write a Review',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.title),
          ),
          const SizedBox(height: 12),

          // Rating picker
          Center(
              child:
                  _StarPicker(rating: selectedRating, onChanged: onRatingChanged)),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              child: Text(
                _ratingLabel(selectedRating),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.bodyText),
              ),
            ),
          ),

          // Name field
          _InputField(
            controller: nameController,
            hint: 'Your name',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 10),

          // Comment field
          _InputField(
            controller: commentController,
            hint: 'Share your experience...',
            icon: Icons.chat_bubble_outline_rounded,
            maxLines: 3,
          ),
          const SizedBox(height: 14),

          // Submit button
          GestureDetector(
            onTap: onSubmit,
            child: Container(
              width: double.infinity,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Submit Review',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _ratingLabel(double r) {
    if (r >= 5) return '⭐ Excellent!';
    if (r >= 4) return '😊 Very Good';
    if (r >= 3) return '😐 Average';
    if (r >= 2) return '😕 Below Average';
    return '😞 Poor';
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14, color: AppColors.title),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle:
              const TextStyle(color: AppColors.hintText, fontSize: 14),
          prefixIcon: Icon(icon, size: 18, color: AppColors.hintText),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }
}

// ── Review Card ─────────────────────────────────────────────
class _ReviewCard extends StatelessWidget {
  final LocalReview review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    review.reviewerName.isNotEmpty
                        ? review.reviewerName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.title),
                    ),
                    Text(
                      review.timeAgo,
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.bodyText),
                    ),
                  ],
                ),
              ),
              _StarRow(rating: review.rating, size: 14),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: const TextStyle(
                fontSize: 13, color: AppColors.bodyText, height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ── Empty State ─────────────────────────────────────────────
// ✅ FIX: شيلنا Expanded وخلينا height ثابتة عشان مفيش overflow
class _EmptyReviews extends StatelessWidget {
  final VoidCallback onAddReview;

  const _EmptyReviews({required this.onAddReview});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280, // ✅ height ثابتة بدل Expanded
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // ✅ min مش max
          children: [
            const Text('💬', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            const Text(
              'No reviews yet',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.title),
            ),
            const SizedBox(height: 6),
            const Text(
              'Be the first to share your experience!',
              style: TextStyle(fontSize: 13, color: AppColors.bodyText),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onAddReview,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Write a Review',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
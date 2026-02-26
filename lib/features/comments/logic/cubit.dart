// lib/features/reviews/logic/review_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/features/comments/data/model/review_model.dart';
import 'package:store_app/features/comments/data/repo/commentt_repo.dart';
import 'package:store_app/features/comments/logic/states.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository _repo;
  final int productId;

  ReviewCubit(this._repo, {required this.productId}) : super(ReviewInitial()) {
    loadReviews();
  }

  Future<void> loadReviews() async {
    if (state is! ReviewLoaded) emit(ReviewLoading());
    try {
      final reviews = await _repo.getReviews(productId);
      final avg = await _repo.getAverageRating(productId);
      final count = await _repo.getReviewCount(productId);
      emit(ReviewLoaded(
        reviews: reviews,
        averageRating: avg,
        reviewCount: count,
      ));
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> addReview({
    required String reviewerName,
    required String comment,
    required double rating,
  }) async {
    final current = state is ReviewLoaded
        ? (state as ReviewLoaded).reviews
        : <LocalReview>[];
    emit(ReviewSubmitting(current));
    try {
      final review = LocalReview(
        productId: productId,
        reviewerName: reviewerName.trim(),
        comment: comment.trim(),
        rating: rating,
      );
      await _repo.addReview(review);
      await loadReviews();
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }

  Future<void> deleteReview(String id) async {
    try {
      await _repo.deleteReview(id);
      await loadReviews();
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
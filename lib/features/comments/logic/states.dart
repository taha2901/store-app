import 'package:store_app/features/comments/data/model/review_model.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<LocalReview> reviews;
  final double averageRating;
  final int reviewCount;

  ReviewLoaded({
    required this.reviews,
    required this.averageRating,
    required this.reviewCount,
  });
}

class ReviewError extends ReviewState {
  final String message;
  ReviewError(this.message);
}

class ReviewSubmitting extends ReviewState {
  final List<LocalReview> currentReviews;
  ReviewSubmitting(this.currentReviews);
}
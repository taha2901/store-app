import 'package:store_app/features/comments/data/model/review_model.dart';
import 'package:store_app/features/comments/data/repo/review_db.dart';
import 'package:store_app/features/home/data/model/product_model.dart';

abstract class ReviewRepository {
  Future<List<LocalReview>> getReviews(int productId);
  Future<void> addReview(LocalReview review);
  Future<void> deleteReview(String id);
  Future<double> getAverageRating(int productId);
  Future<int> getReviewCount(int productId);
}

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewDatabase _db;
  ReviewRepositoryImpl(this._db);

  @override
  Future<List<LocalReview>> getReviews(int productId) =>
      _db.getReviewsForProduct(productId);

  @override
  Future<void> addReview(LocalReview review) => _db.insertReview(review);

  @override
  Future<void> deleteReview(String id) => _db.deleteReview(id);

  @override
  Future<double> getAverageRating(int productId) =>
      _db.getAverageRating(productId);

  @override
  Future<int> getReviewCount(int productId) => _db.getReviewCount(productId);
}
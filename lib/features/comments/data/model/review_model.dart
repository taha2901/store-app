// lib/features/reviews/data/model/local_review.dart

import 'package:uuid/uuid.dart';

class LocalReview {
  final String id;
  final int productId;
  final String reviewerName;
  final String comment;
  final double rating;
  final String createdAt;

  LocalReview({
    String? id,
    required this.productId,
    required this.reviewerName,
    required this.comment,
    required this.rating,
    String? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now().toIso8601String();

  Map<String, dynamic> toMap() => {
        'id': id,
        'product_id': productId,
        'reviewer_name': reviewerName,
        'comment': comment,
        'rating': rating,
        'created_at': createdAt,
      };

  factory LocalReview.fromMap(Map<String, dynamic> map) => LocalReview(
        id: map['id'] as String,
        productId: map['product_id'] as int,
        reviewerName: map['reviewer_name'] as String,
        comment: map['comment'] as String,
        rating: (map['rating'] as num).toDouble(),
        createdAt: map['created_at'] as String,
      );

  String get timeAgo {
    try {
      final diff = DateTime.now().difference(DateTime.parse(createdAt));
      if (diff.inDays > 30) return '${(diff.inDays / 30).floor()} months ago';
      if (diff.inDays > 0) return '${diff.inDays} days ago';
      if (diff.inHours > 0) return '${diff.inHours} hours ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes} minutes ago';
      return 'Just now';
    } catch (_) {
      return createdAt;
    }
  }
}
// lib/features/reviews/data/repo/review_database.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:store_app/features/comments/data/model/review_model.dart';
class ReviewDatabase {
  ReviewDatabase._();
  static final ReviewDatabase instance = ReviewDatabase._();
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'store_reviews.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE reviews (
            id            TEXT    PRIMARY KEY,
            product_id    INTEGER NOT NULL,
            reviewer_name TEXT    NOT NULL,
            comment       TEXT    NOT NULL,
            rating        REAL    NOT NULL,
            created_at    TEXT    NOT NULL
          )
        ''');
        await db.execute(
            'CREATE INDEX idx_reviews_product ON reviews (product_id)');
      },
    );
  }

  Future<List<LocalReview>> getReviewsForProduct(int productId) async {
    final db = await database;
    final maps = await db.query(
      'reviews',
      where: 'product_id = ?',
      whereArgs: [productId],
      orderBy: 'created_at DESC',
    );
    return maps.map((m) => LocalReview.fromMap(m)).toList(); // ✅ explicit cast
  }

  Future<void> insertReview(LocalReview review) async {
    final db = await database;
    await db.insert(
      'reviews',
      review.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteReview(String id) async {
    final db = await database;
    await db.delete('reviews', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> getAverageRating(int productId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT AVG(rating) as avg FROM reviews WHERE product_id = ?',
      [productId],
    );
    return (result.first['avg'] as num?)?.toDouble() ?? 0.0;
  }

  Future<int> getReviewCount(int productId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as cnt FROM reviews WHERE product_id = ?',
      [productId],
    );
    return (result.first['cnt'] as int?) ?? 0;
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
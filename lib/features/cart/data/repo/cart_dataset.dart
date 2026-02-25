import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:store_app/features/cart/data/model/local_cart_item.dart';

class CartDatabase {
  CartDatabase._();
  static final CartDatabase instance = CartDatabase._();

  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'store_cart.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cart_items (
            id               INTEGER PRIMARY KEY AUTOINCREMENT,
            product_id       INTEGER NOT NULL UNIQUE,
            title            TEXT    NOT NULL,
            price            REAL    NOT NULL,
            discounted_price REAL    NOT NULL,
            discount_percentage REAL NOT NULL,
            thumbnail        TEXT    NOT NULL,
            brand            TEXT,
            quantity         INTEGER NOT NULL DEFAULT 1
          )
        ''');
      },
    );
  }

  // ── INSERT or UPDATE if product already exists ─────────────
  Future<void> addOrUpdate(LocalCartItem item) async {
    final db = await database;
    final existing = await db.query(
      'cart_items',
      where: 'product_id = ?',
      whereArgs: [item.productId],
    );

    if (existing.isEmpty) {
      await db.insert('cart_items', item.toMap());
    } else {
      final currentQty = existing.first['quantity'] as int;
      await db.update(
        'cart_items',
        {'quantity': currentQty + item.quantity},
        where: 'product_id = ?',
        whereArgs: [item.productId],
      );
    }
  }

  // ── GET ALL ───────────────────────────────────────────────
  Future<List<LocalCartItem>> getAllItems() async {
    final db = await database;
    final maps = await db.query('cart_items', orderBy: 'id DESC');
    return maps.map(LocalCartItem.fromMap).toList();
  }

  // ── UPDATE QUANTITY ───────────────────────────────────────
  Future<void> updateQuantity(int productId, int quantity) async {
    final db = await database;
    if (quantity <= 0) {
      await deleteItem(productId);
    } else {
      await db.update(
        'cart_items',
        {'quantity': quantity},
        where: 'product_id = ?',
        whereArgs: [productId],
      );
    }
  }

  // ── DELETE ONE ────────────────────────────────────────────
  Future<void> deleteItem(int productId) async {
    final db = await database;
    await db.delete(
      'cart_items',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  // ── CLEAR ALL (after order placed) ───────────────────────
  Future<void> clearCart() async {
    final db = await database;
    await db.delete('cart_items');
  }

  // ── COUNT ─────────────────────────────────────────────────
  Future<int> getItemCount() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT SUM(quantity) as total FROM cart_items');
    return (result.first['total'] as int?) ?? 0;
  }
}
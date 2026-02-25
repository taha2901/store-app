// ─────────────────────────────────────────────────────────────
// lib/features/cart/data/models/local_cart_item.dart
// ─────────────────────────────────────────────────────────────

class LocalCartItem {
  final int? id;          // SQLite auto-increment
  final int productId;
  final String title;
  final double price;         // original price
  final double discountedPrice;
  final double discountPercentage;
  final String thumbnail;
  final String? brand;
  int quantity;

  LocalCartItem({
    this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.thumbnail,
    this.brand,
    required this.quantity,
  });

  // ── Computed getters ──────────────────────────────────────
  double get itemTotal => discountedPrice * quantity;
  double get itemOriginalTotal => price * quantity;
  double get saving => itemOriginalTotal - itemTotal;
  bool get hasDiscount => discountPercentage > 0;

  // ── SQLite Map ────────────────────────────────────────────
  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'product_id': productId,
        'title': title,
        'price': price,
        'discounted_price': discountedPrice,
        'discount_percentage': discountPercentage,
        'thumbnail': thumbnail,
        'brand': brand ?? '',
        'quantity': quantity,
      };

  factory LocalCartItem.fromMap(Map<String, dynamic> map) => LocalCartItem(
        id: map['id'] as int?,
        productId: map['product_id'] as int,
        title: map['title'] as String,
        price: (map['price'] as num).toDouble(),
        discountedPrice: (map['discounted_price'] as num).toDouble(),
        discountPercentage: (map['discount_percentage'] as num).toDouble(),
        thumbnail: map['thumbnail'] as String,
        brand: map['brand'] as String?,
        quantity: map['quantity'] as int,
      );

  LocalCartItem copyWith({int? quantity}) => LocalCartItem(
        id: id,
        productId: productId,
        title: title,
        price: price,
        discountedPrice: discountedPrice,
        discountPercentage: discountPercentage,
        thumbnail: thumbnail,
        brand: brand,
        quantity: quantity ?? this.quantity,
      );
}
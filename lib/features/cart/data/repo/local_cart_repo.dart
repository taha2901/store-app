import 'package:store_app/features/cart/data/model/local_cart_item.dart';
import 'package:store_app/features/cart/data/repo/cart_dataset.dart';



class LocalCartRepo {
  final CartDatabase _db;

  LocalCartRepo(this._db);

  Future<void> addOrUpdate(LocalCartItem item) => _db.addOrUpdate(item);

  Future<List<LocalCartItem>> getAllItems() => _db.getAllItems();

  Future<void> updateQuantity(int productId, int quantity) =>
      _db.updateQuantity(productId, quantity);

  Future<void> deleteItem(int productId) => _db.deleteItem(productId);

  Future<void> clearCart() => _db.clearCart();

  Future<int> getItemCount() => _db.getItemCount();
}
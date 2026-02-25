
import 'package:store_app/features/cart/data/model/local_cart_item.dart';

abstract class LocalCartState {}

class LocalCartInitial extends LocalCartState {}

class LocalCartLoading extends LocalCartState {}

class LocalCartLoaded extends LocalCartState {
  final List<LocalCartItem> items;

  LocalCartLoaded(this.items);

  // ── Computed totals ───────────────────────────────────────
  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.itemTotal);

  double get originalTotal =>
      items.fold(0, (sum, item) => sum + item.itemOriginalTotal);

  double get totalSaving => originalTotal - subtotal;

  int get totalQuantity =>
      items.fold(0, (sum, item) => sum + item.quantity);

  int get itemCount => items.length;

  bool get isEmpty => items.isEmpty;
}

class LocalCartError extends LocalCartState {
  final String message;
  LocalCartError(this.message);
}

class LocalCartItemAdded extends LocalCartLoaded {
  LocalCartItemAdded(super.items);
}

class LocalCartItemRemoved extends LocalCartLoaded {
  LocalCartItemRemoved(super.items);
}

class LocalCartCleared extends LocalCartState {}

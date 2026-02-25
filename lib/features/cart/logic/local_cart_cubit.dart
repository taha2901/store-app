import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/features/cart/data/model/local_cart_item.dart';
import 'package:store_app/features/cart/data/repo/local_cart_repo.dart';
import 'package:store_app/features/cart/logic/states.dart';

class LocalCartCubit extends Cubit<LocalCartState> {
  final LocalCartRepo _repo;

  LocalCartCubit(this._repo) : super(LocalCartInitial()) {
    print("CUBIT CREATED: ${hashCode}");
  }

  Future<void> loadCart() async {
    // ✅ لو عندنا items محملة فعلاً → refresh صامت بدون loading
    if (state is! LocalCartLoaded) {
      emit(LocalCartLoading());
    }
    try {
      final items = await _repo.getAllItems();
      emit(LocalCartLoaded(items));
    } catch (e) {
      emit(LocalCartError(e.toString()));
    }
  }

  Future<void> addItem(LocalCartItem item) async {
    try {
      print("ADDING ITEM: ${item.title}");
      await _repo.addOrUpdate(item);
      final items = await _repo.getAllItems();
      print("ITEMS COUNT: ${items.length}");
      emit(LocalCartLoaded(items)); // ← بدل ItemAdded
    } catch (e) {
      emit(LocalCartError(e.toString()));
    }
  }

  Future<void> updateQuantity(int productId, int newQty) async {
    try {
      await _repo.updateQuantity(productId, newQty);
      final items = await _repo.getAllItems();
      emit(LocalCartLoaded(items));
    } catch (e) {
      emit(LocalCartError(e.toString()));
    }
  }

 Future<void> removeItem(int productId) async {
  await _repo.deleteItem(productId);
  final items = await _repo.getAllItems();
  emit(LocalCartLoaded(items));
}

  Future<void> clearCart() async {
    try {
      await _repo.clearCart();
      emit(LocalCartCleared());
    } catch (e) {
      emit(LocalCartError(e.toString()));
    }
  }

  Future<void> increment(LocalCartItem item) =>
      updateQuantity(item.productId, item.quantity + 1);

  Future<void> decrement(LocalCartItem item) =>
      updateQuantity(item.productId, item.quantity - 1);
}

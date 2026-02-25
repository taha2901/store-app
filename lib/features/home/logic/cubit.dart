import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/features/home/data/model/product_model.dart';
import 'package:store_app/features/home/data/repo/product_repo.dart';
import 'package:store_app/features/home/logic/states.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo _repo;
  ProductCubit(this._repo) : super(ProductInitial());

  List<ProductModel> _allProducts = [];

  Future<void> getProducts({int limit = 20, int skip = 0}) async {
    emit(ProductLoading());
    try {
      final res = await _repo.getProducts(limit: limit, skip: skip);
      _allProducts = res.products;
      emit(ProductsLoaded(res.products, res.total));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getProduct(int id) async {
    emit(ProductLoading());
    try {
      final product = await _repo.getProduct(id);
      emit(ProductLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> searchProducts(String query) async {
    emit(ProductLoading());
    try {
      final res = await _repo.searchProducts(query);
      emit(ProductsLoaded(res.products, res.total));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getCategories() async {
    emit(ProductLoading());
    try {
      final categories = await _repo.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getCategoryList() async {
    emit(ProductLoading());
    try {
      final list = await _repo.getCategoryList();
      emit(CategoryListLoaded(list));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> getProductsByCategory(String category) async {
    emit(ProductLoading());
    try {
      final res = await _repo.getProductsByCategory(category);
      emit(ProductsLoaded(res.products, res.total));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> addProduct(AddProductRequestModel req) async {
    emit(ProductLoading());
    try {
      final product = await _repo.addProduct(req);
      emit(ProductAdded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> updateProduct(int id, UpdateProductRequestModel req) async {
    emit(ProductLoading());
    try {
      final product = await _repo.updateProduct(id, req);
      emit(ProductUpdated(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> deleteProduct(int id) async {
    emit(ProductLoading());
    try {
      final deleted = await _repo.deleteProduct(id);
      emit(ProductDeleted(deleted));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/features/home/data/repo/product_repo.dart';
import 'package:store_app/features/home/logic/states.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo _repo;
  ProductCubit(this._repo) : super(ProductInitial());


  Future<void> getProducts({int limit = 20, int skip = 0}) async {
    emit(ProductLoading());
    try {
      final res = await _repo.getProducts(limit: limit, skip: skip);
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

  // Future<void> getCategories() async {
  //   emit(ProductLoading());
  //   try {
  //     final categories = await _repo.getCategories();
  //     emit(CategoriesLoaded(categories));
  //   } catch (e) {
  //     emit(ProductError(e.toString()));
  //   }
  // }

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

  }

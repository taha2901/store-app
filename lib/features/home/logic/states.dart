
import 'package:store_app/features/home/data/model/product_model.dart';

abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<ProductModel> products;
  final int total;
  ProductsLoaded(this.products, this.total);
}

class ProductLoaded extends ProductState {
  final ProductModel product;
  ProductLoaded(this.product);
}

class CategoriesLoaded extends ProductState {
  final List<CategoryModel> categories;
  CategoriesLoaded(this.categories);
}

class CategoryListLoaded extends ProductState {
  final List<String> categoryList;
  CategoryListLoaded(this.categoryList);
}

class ProductAdded extends ProductState {
  final ProductModel product;
  ProductAdded(this.product);
}

class ProductUpdated extends ProductState {
  final ProductModel product;
  ProductUpdated(this.product);
}

class ProductDeleted extends ProductState {
  final DeletedProductModel deletedProduct;
  ProductDeleted(this.deletedProduct);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

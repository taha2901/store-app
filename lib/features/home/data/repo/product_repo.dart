
import 'package:store_app/core/networking/api_services.dart';
import 'package:store_app/features/home/data/model/product_model.dart';

class ProductRepo {
  final ApiServices _apiServices;
  ProductRepo(this._apiServices);

  Future<ProductsResponseModel> getProducts({
    int limit = 20,
    int skip = 0,
  }) =>
      _apiServices.getProducts(limit: limit, skip: skip);

  Future<ProductModel> getProduct(int id) =>
      _apiServices.getProduct(id);

  Future<ProductsResponseModel> searchProducts(String query) =>
      _apiServices.searchProducts(query);

  Future<List<CategoryModel>> getCategories() =>
      _apiServices.getCategories();

  Future<List<String>> getCategoryList() =>
      _apiServices.getCategoryList();

  Future<ProductsResponseModel> getProductsByCategory(
          String category) =>
      _apiServices.getProductsByCategory(category);

  Future<ProductModel> addProduct(AddProductRequestModel req) =>
      _apiServices.addProduct(req);

  Future<ProductModel> updateProduct(
          int id, UpdateProductRequestModel req) =>
      _apiServices.updateProduct(id, req);

  Future<DeletedProductModel> deleteProduct(int id) =>
      _apiServices.deleteProduct(id);
}
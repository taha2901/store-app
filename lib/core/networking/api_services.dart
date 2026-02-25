import 'package:dio/dio.dart';
import 'package:store_app/core/networking/api_constants.dart';
import 'package:store_app/features/home/data/model/product_model.dart';
import 'package:store_app/features/login/data/models/login_request_model.dart';
import 'package:store_app/features/login/data/models/login_response_model.dart';

class ApiServices {
  final Dio _dio;

  ApiServices(this._dio) {
    _dio.options.baseUrl = ApiConstants.apiBaseUrl;
  }

  // =================== Auth ===================

  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: loginRequestModel.toJson(),
    );
    return LoginResponseModel.fromJson(response.data);
  }

  /// GET /products?limit=20&skip=0
  Future<ProductsResponseModel> getProducts({
    int limit = 20,
    int skip = 0,
  }) async {
    final res = await _dio.get(
      ApiConstants.products,
      queryParameters: {'limit': limit, 'skip': skip},
    );
    return ProductsResponseModel.fromJson(res.data);
  }

  /// GET /products/{id}
  Future<ProductModel> getProduct(int id) async {
    final res = await _dio.get(ApiConstants.singleProduct(id));
    return ProductModel.fromJson(res.data);
  }

  /// GET /products/search?q=phone
  Future<ProductsResponseModel> searchProducts(String query) async {
    final res = await _dio.get(
      ApiConstants.productSearch,
      queryParameters: {'q': query},
    );
    return ProductsResponseModel.fromJson(res.data);
  }

  /// GET /products/categories
  Future<List<CategoryModel>> getCategories() async {
    final res = await _dio.get(ApiConstants.productCategories);
    return (res.data as List).map((c) => CategoryModel.fromJson(c)).toList();
  }

  /// GET /products/category-list
  Future<List<String>> getCategoryList() async {
    final res = await _dio.get(ApiConstants.productCategoryList);
    return List<String>.from(res.data);
  }

  /// GET /products/category/{category}
  Future<ProductsResponseModel> getProductsByCategory(String category) async {
    final res = await _dio.get(ApiConstants.productsByCategory(category));
    return ProductsResponseModel.fromJson(res.data);
  }
}

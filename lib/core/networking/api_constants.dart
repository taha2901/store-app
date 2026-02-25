
class ApiConstants {
  static const String apiBaseUrl = 'https://dummyjson.com/';

  // Auth
  static const String login = 'auth/login';
  static const String register = 'auth/register';
  static const String logout = 'auth/logout';

  // Products
  static const String products = 'products';
  static const String productCategories = 'products/categories';
  static const String productCategoryList = 'products/category-list';
  static const String productSearch = 'products/search';
  static String singleProduct(int id) => 'products/$id';
  static String productsByCategory(String category) =>
      'products/category/$category';
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
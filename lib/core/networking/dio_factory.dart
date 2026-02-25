import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:store_app/core/helpers/shared_pref_helper.dart';

class DioFactory {
  DioFactory._();

  static Dio? _dio;

  static Future<Dio> getDio() async {
    if (_dio != null) return _dio!;

    _dio = Dio()
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30);

    await _addDioHeaders();
    _addDioInterceptor();

    return _dio!;
  }

  /// اضافة headers تلقائي
  static Future<void> _addDioHeaders() async {
    String token = await SharedPrefHelper.getSecuredString('accessToken');
    _dio?.options.headers = {
      'Accept': 'application/json',
      if (token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// تحديث الـ header بعد login
  static void setTokenIntoHeaderAfterLogin(String token) {
    _dio?.options.headers['Authorization'] = 'Bearer $token';
  }

  /// اضافة interceptors لتسجيل الطلبات والردود
  static void _addDioInterceptor() {
    _dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
  }
}
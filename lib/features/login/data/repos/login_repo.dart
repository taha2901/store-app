import 'package:store_app/core/helpers/shared_pref_helper.dart';
import 'package:store_app/core/networking/api_error_handler.dart';
import 'package:store_app/core/networking/api_result.dart';
import 'package:store_app/core/networking/api_services.dart';
import 'package:store_app/core/networking/dio_factory.dart';
import 'package:store_app/features/login/data/models/login_request_model.dart';
import 'package:store_app/features/login/data/models/login_response_model.dart';

class LoginRepo {
  final ApiServices _apiServices;
  LoginRepo(this._apiServices);
  Future<ApiResult<LoginResponseModel>> login(
    LoginRequestModel loginRequestBody,
  ) async {
    try {
      final response = await _apiServices.login(loginRequestBody);

      // خزن الـ tokens في secure storage
      await SharedPrefHelper.setSecuredString(
        'accessToken',
        response.accessToken,
      );
      await SharedPrefHelper.setSecuredString(
        'refreshToken',
        response.refreshToken,
      );

      // حدث header للديو
      DioFactory.setTokenIntoHeaderAfterLogin(response.accessToken);

      return ApiSuccess(response);
    } catch (error) {
      return ApiFailure(ErrorHandler.handle(error));
    }
  }
}

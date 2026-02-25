import 'api_error_handler.dart';

abstract class ApiResult<T> {
  const ApiResult();
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiFailure<T> extends ApiResult<T> {
  final ErrorHandler errorHandler;
  const ApiFailure(this.errorHandler);
}

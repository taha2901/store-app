import 'package:bloc/bloc.dart';
import 'package:store_app/core/networking/api_result.dart';
import 'package:store_app/features/login/data/models/login_request_model.dart';
import 'package:store_app/features/login/data/models/login_response_model.dart';
import 'package:store_app/features/login/data/repos/login_repo.dart';
import 'package:store_app/features/login/logic/states.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;
  LoginCubit(this._loginRepo) : super(LoginInitial());

  Future<void> login(String username, String password) async {
    emit(LoginLoading());

    final loginRequest = LoginRequestModel(
      username: username,
      password: password,
    );
    final result = await _loginRepo.login(loginRequest);

    if (result is ApiSuccess<LoginResponseModel>) {
      emit(LoginSuccess(result.data));
    } else if (result is ApiFailure) {
      emit(LoginFailure(result.toString()));
    }
  }
}

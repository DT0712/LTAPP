import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../../network/auth_api.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await AuthApi.login(event.email, event.password);
        if (result['success']) {
          emit(AuthSuccess(result['message']));
        } else {
          emit(AuthFailure(result['message']));
        }
      } catch (e) {
        emit(AuthFailure('Lỗi kết nối máy chủ'));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final result = await AuthApi.register(
          event.username,
          event.email,
          event.password,
        );
        if (result['success']) {
          emit(AuthSuccess(result['message']));
        } else {
          emit(AuthFailure(result['message']));
        }
      } catch (e) {
        emit(AuthFailure('Lỗi kết nối máy chủ'));
      }
    });

    on<GoogleSignInEvent>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthSuccess('Đăng nhập bằng Google thành công (demo)'));
    });
  }
}

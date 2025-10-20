import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/network/result.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await _repository.login(event.email, event.password);
      if (result is Success) {
        emit(AuthSuccess('Đăng nhập thành công'));
      } else if (result is Failure) {
        emit(AuthFailure((result as Failure).message));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      final result = await _repository.register(
        event.name,
        event.email,
        event.password,
      );
      if (result is Success) {
        emit(AuthSuccess('Đăng ký thành công'));
      } else if (result is Failure) {
        emit(AuthFailure((result as Failure).message));
      }
    });

    on<GoogleSignInEvent>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthSuccess('Đăng nhập bằng Google thành công (demo)'));
    });
  }
}

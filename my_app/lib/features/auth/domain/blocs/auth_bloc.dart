// lib/features/auth/domain/blocs/auth_bloc.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;

  AuthBloc({required this.registerUseCase});

  // Implement event handling
}

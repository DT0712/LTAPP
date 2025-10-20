import '../../../../core/network/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  final String name;
  final String email;
  final String password;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Result<User>> execute(RegisterParams params) async {
    return await repository.register(
      params.name,
      params.email,
      params.password,
    );
  }
}

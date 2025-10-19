import 'package:either_dart/either.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import '../entities/user.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, User>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await repository.register(name, email, password);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(e.toString()));
    }
  }
}

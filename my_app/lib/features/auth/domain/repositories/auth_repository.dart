import '../entities/user.dart';
import '../data/datasources/auth_remote_data_source.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  Future<User> login(String email, String password) async {
    return remoteDataSource.login(email, password);
  }

  Future<User> register(String name, String email, String password) async {
    return remoteDataSource.register(name, email, password);
  }
}

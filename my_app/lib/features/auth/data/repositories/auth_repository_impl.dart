import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/network/result.dart';

class AuthRepositoryImpl implements AuthRepository {
  final String baseUrl =
      'http://10.0.2.2:3000/api/auth'; // Dùng 10.0.2.2 cho Android emulator

  @override
  Future<Result<User>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': name,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode != 201) {
        return Failure(data['message'] ?? 'Đăng ký thất bại');
      }

      return Success(
        User(id: data['id'], name: data['username'], email: data['email']),
      );
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<User>> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(res.body);

      if (res.statusCode != 200) {
        return Failure(data['message'] ?? 'Đăng nhập thất bại');
      }

      return Success(
        User(id: data['id'], name: data['username'], email: data['email']),
      );
    } catch (e) {
      return Failure(e.toString());
    }
  }
}

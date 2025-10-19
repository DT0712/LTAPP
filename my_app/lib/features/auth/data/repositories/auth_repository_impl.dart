import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepositoryImpl {
  final String baseUrl =
      'http://10.0.2.2:3000/api/auth'; // Dùng 10.0.2.2 cho Android emulator

  Future<void> register(String name, String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': name,
        'email': email,
        'password': password,
      }),
    );

    if (res.statusCode != 201) {
      throw Exception(jsonDecode(res.body)['message']);
    }
  }

  Future<void> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode != 200) {
      throw Exception(jsonDecode(res.body)['message']);
    }

    final data = jsonDecode(res.body);
    // lưu token nếu cần
  }
}

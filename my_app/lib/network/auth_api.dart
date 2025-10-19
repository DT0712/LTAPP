import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApi {
  static const String baseUrl =
      'http://10.0.2.2:3000/api/auth'; // dùng cho emulator Android
  // Nếu bạn chạy Flutter Web hoặc Windows:
  // static const String baseUrl = 'http://localhost:3000/api/auth';

  // Đăng nhập
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return {
        'success': true,
        'message': data['message'],
        'token': data['token'],
      };
    } else {
      return {'success': false, 'message': data['message'] ?? 'Lỗi đăng nhập'};
    }
  }

  // Đăng ký
  static Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return {'success': true, 'message': data['message']};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Lỗi đăng ký'};
    }
  }
}


app.get('/', (req, res) => {
  res.send('API đang chạy ngon lành 🚀');
});

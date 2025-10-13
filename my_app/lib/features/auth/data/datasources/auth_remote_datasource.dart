import 'dart:async';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  // Mô phỏng API đăng nhập
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // giả lập delay API
    if (email == "test@gmail.com" && password == "123456") {
      return UserModel(id: 1, name: "Duy", email: email);
    } else {
      throw Exception("Sai email hoặc mật khẩu!");
    }
  }

  // Mô phỏng API đăng ký
  Future<UserModel> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(id: 99, name: name, email: email);
  }
}

class AuthRemoteDataSource {
  // Giả lập danh sách user trên "server"
  static final List<Map<String, String>> _users = [];

  Future<void> register(String name, String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final existed = _users.any((u) => u["email"] == email);
    if (existed) {
      throw Exception("Email đã tồn tại");
    }

    _users.add({"name": name, "email": email, "password": password});
  }

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final matched = _users.any(
      (u) => u["email"] == email && u["password"] == password,
    );

    if (!matched) throw Exception("Sai email hoặc mật khẩu");
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/register';
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _agreeTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bạn cần đồng ý với điều khoản và chính sách bảo mật')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công!')),
      );
      Navigator.pop(context); // quay về Login
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Đăng ký thất bại')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // giữ nền/tiêu đề cố định khi mở bàn phím
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Ảnh nền
          Image.asset('assets/images/auth/itour_login_bg.jpg', fit: BoxFit.cover),
          // Lớp phủ mờ
          Container(color: Colors.black.withOpacity(0.4)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: LayoutBuilder(
                builder: (context, _) {
                  final size = MediaQuery.of(context).size;
                  final kb   = MediaQuery.of(context).viewInsets.bottom;

                  // Card sẽ không cao quá phần không gian còn lại
                  final double cardMaxH =
                  (size.height - kb - 140).clamp(320.0, size.height);

                  return Stack(
                    children: [
                      // ===== HEADER: cố định =====
                      const Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            'iTour',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),

                      // ===== FORM: chỉ khối này nhấc theo bàn phím =====
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          padding: EdgeInsets.only(bottom: kb + 16), // chỉnh 16 -> 8/0 tùy ý
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 640,
                              maxHeight: cardMaxH, // ✅ chặn overflow
                            ),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.90),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              // ✅ nội dung cuộn nếu dài
                              child: SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                padding: const EdgeInsets.all(20),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: _emailController,
                                        decoration: const InputDecoration(
                                          labelText: 'Tên đăng nhập (Email)',
                                          prefixIcon: Icon(Icons.person),
                                        ),
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (v) =>
                                        (v == null || v.trim().isEmpty)
                                            ? 'Nhập email của bạn'
                                            : null,
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: _passwordController,
                                        decoration: const InputDecoration(
                                          labelText: 'Mật khẩu',
                                          prefixIcon: Icon(Icons.lock),
                                        ),
                                        obscureText: true,
                                        validator: (v) =>
                                        (v == null || v.length < 6)
                                            ? 'Mật khẩu ít nhất 6 ký tự'
                                            : null,
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: _confirmPasswordController,
                                        decoration: const InputDecoration(
                                          labelText: 'Nhập lại mật khẩu',
                                          prefixIcon: Icon(Icons.lock_outline),
                                        ),
                                        obscureText: true,
                                        validator: (v) =>
                                        v != _passwordController.text
                                            ? 'Mật khẩu không khớp'
                                            : null,
                                      ),
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        controller: _phoneController,
                                        decoration: const InputDecoration(
                                          labelText: 'Số điện thoại',
                                          prefixIcon: Icon(Icons.phone),
                                        ),
                                        keyboardType: TextInputType.phone,
                                      ),
                                      const SizedBox(height: 10),

                                      Row(
                                        children: [
                                          Checkbox(
                                            value: _agreeTerms,
                                            onChanged: (val) =>
                                                setState(() => _agreeTerms = val ?? false),
                                          ),
                                          const Expanded(
                                            child: Text.rich(
                                              TextSpan(
                                                text: 'Tôi đồng ý với ',
                                                children: [
                                                  TextSpan(
                                                    text: 'Điều khoản',
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(text: ' và '),
                                                  TextSpan(
                                                    text: 'Chính sách bảo mật',
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),

                                      SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: _isLoading ? null : _register,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.lightBlueAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: _isLoading
                                              ? const SizedBox(
                                            width: 22, height: 22,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                              : const Text(
                                            'Đăng ký',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // (ĐÃ XÓA) "Hoặc đăng nhập với" + Google/Apple

                                      const SizedBox(height: 12),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Đã có tài khoản? Đăng nhập'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

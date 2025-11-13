import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'register_page.dart';
import '../data/auth_service.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  const LoginPage({super.key, this.onLoggedInRoute = '/home'});

  final String onLoggedInRoute;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _auth      = AuthService();

  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _doEmailLogin() async {
    final email = _emailCtrl.text.trim();
    final pass  = _passCtrl.text;

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email và mật khẩu')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      final user = await _auth.signInWithEmail(email: email, password: pass);
      if (user != null && mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          widget.onLoggedInRoute, (r) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Đăng nhập thất bại')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _doGoogleLogin() async {
    setState(() => _loading = true);
    try {
      final user = await _auth.signInWithGoogle();
      if (user != null && mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          widget.onLoggedInRoute, (r) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Google Sign-In thất bại')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ❌ Không cho Scaffold tự đẩy toàn bộ nội dung
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Ảnh nền (luôn đứng yên)
          Image.asset('assets/images/auth/itour_login_bg.jpg', fit: BoxFit.cover),

          // Lớp mờ
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Color(0x66000000), Color(0x33000000), Color(0x66000000)],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: LayoutBuilder(
                builder: (context, _) {
                  final kb = MediaQuery.of(context).viewInsets.bottom;

                  return Stack(
                    children: [
                      // ===== HEADER: giữ nguyên vị trí, căn phải =====
                      Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            SizedBox(height: 30),
                            Text(
                              'iTour',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(height: 140),
                            Text(
                              'Hãy cùng chúng tôi\nKhám phá',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.4,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'VIỆT NAM',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ===== FORM: chỉ khối này nhấc theo bàn phím =====
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AnimatedPadding(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          padding: EdgeInsets.only(bottom: kb + 8),
                          child: _LoginForm(
                            emailCtrl: _emailCtrl,
                            passCtrl: _passCtrl,
                            loading: _loading,
                            obscure: _obscure,
                            toggleObscure: () => setState(() => _obscure = !_obscure),
                            onEmailLogin: _doEmailLogin,
                            onGoogleLogin: _doGoogleLogin,
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

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.emailCtrl,
    required this.passCtrl,
    required this.loading,
    required this.obscure,
    required this.toggleObscure,
    required this.onEmailLogin,
    required this.onGoogleLogin,
  });

  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final bool loading;
  final bool obscure;
  final VoidCallback toggleObscure;
  final VoidCallback onEmailLogin;
  final VoidCallback onGoogleLogin;

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6B4EFF);
    const fieldBG = Colors.white;
    const fieldBorder = Color(0xFFDDDDDD);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _RoundedTextField(
            controller: emailCtrl,
            hint: 'Tên đăng nhập',
            prefix: const Icon(Icons.person_outline),
            background: fieldBG,
            borderColor: fieldBorder,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          _RoundedTextField(
            controller: passCtrl,
            hint: 'Mật khẩu',
            prefix: const Icon(Icons.lock_outline),
            background: fieldBG,
            borderColor: fieldBorder,
            obscure: obscure,
            suffix: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[600]),
              onPressed: toggleObscure,
            ),
          ),
          const SizedBox(height: 16),

          // Nút Đăng nhập
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 0,
              ),
              onPressed: loading ? null : onEmailLogin,
              child: loading
                  ? const SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
                  : const Text(
                'Đăng nhập',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // or
          Row(
            children: const [
              Expanded(child: Divider()),
              Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Text('or')),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 10),

          // Google + Apple
          Row(
            children: [
              Expanded(
                child: _SocialButton(
                  label: 'Google',
                  asset: 'assets/images/auth/google.png',
                  onTap: loading ? null : onGoogleLogin,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SocialButton(
                  label: 'Apple',
                  asset: 'assets/images/auth/apple.png',
                  onTap: loading
                      ? null
                      : () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Apple Sign-In chỉ để trưng')),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: loading
                ? null
                : () => Navigator.of(context).pushNamed(RegisterPage.routeName),
            child: const Text('Tạo tài khoản mới', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _RoundedTextField extends StatelessWidget {
  const _RoundedTextField({
    required this.controller,
    required this.hint,
    this.prefix,
    this.suffix,
    required this.background,
    required this.borderColor,
    this.obscure = false,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final Widget? prefix;
  final Widget? suffix;
  final Color background;
  final Color borderColor;
  final bool obscure;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          if (prefix != null) ...[prefix!, const SizedBox(width: 8)],
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              style: const TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                isDense: true,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black54),
                border: InputBorder.none,
              ),
            ),
          ),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.asset,
    required this.onTap,
    super.key,
  });

  final String label;
  final String asset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withOpacity(0.06),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              asset, height: 20, width: 20,
              errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 18),
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

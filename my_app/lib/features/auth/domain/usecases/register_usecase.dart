import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth_bloc.dart';
import '../../../../core/constants/color_palette.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                "Tạo tài khoản mới ✨",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorPalette.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Hãy điền thông tin bên dưới để bắt đầu",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),

              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AuthTextField(
                      controller: _nameCtrl,
                      label: "Họ và tên",
                      hint: "Nhập họ tên",
                      icon: Icons.person_outline,
                      validator: (value) =>
                          value!.isEmpty ? "Vui lòng nhập tên" : null,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      controller: _emailCtrl,
                      label: "Email",
                      hint: "example@gmail.com",
                      icon: Icons.email_outlined,
                      validator: (value) =>
                          value!.isEmpty ? "Vui lòng nhập email" : null,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      controller: _passwordCtrl,
                      label: "Mật khẩu",
                      hint: "********",
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) =>
                          value!.length < 6 ? "Tối thiểu 6 ký tự" : null,
                    ),
                    const SizedBox(height: 20),
                    AuthTextField(
                      controller: _confirmCtrl,
                      label: "Xác nhận mật khẩu",
                      hint: "********",
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) => value != _passwordCtrl.text
                          ? "Mật khẩu không khớp"
                          : null,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Đăng ký thành công!")),
                    );
                    Navigator.pushReplacementNamed(context, '/home');
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  return AuthButton(
                    text: state is AuthLoading ? "Đang xử lý..." : "Đăng ký",
                    onPressed: state is AuthLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                RegisterEvent(
                                  name: _nameCtrl.text,
                                  email: _emailCtrl.text,
                                  password: _passwordCtrl.text,
                                ),
                              );
                            }
                          },
                  );
                },
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Đã có tài khoản?"),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text("Đăng nhập"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

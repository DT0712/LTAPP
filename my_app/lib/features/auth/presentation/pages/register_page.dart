import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../widgets/auth_text_field.dart';

class RegisterPage extends StatelessWidget {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          } else if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Đăng ký",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  AuthTextField(controller: nameCtrl, hint: "Tên người dùng"),
                  AuthTextField(controller: emailCtrl, hint: "Email"),
                  AuthTextField(
                    controller: passCtrl,
                    hint: "Mật khẩu",
                    obscure: true,
                  ),
                  const SizedBox(height: 20),
                  state is AuthLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(RegisterEvent(
                                  nameCtrl.text,
                                  emailCtrl.text,
                                  passCtrl.text,
                                ));
                          },
                          child: Text("Đăng ký"),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

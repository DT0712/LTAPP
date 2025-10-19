import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';

void main() {
  // Dependencies
  final authRepository = AuthRepositoryImpl(...);
  final registerUseCase = RegisterUseCase(authRepository);
  final loginUseCase = LoginUseCase(authRepository);
  final authBloc = AuthBloc(
    registerUseCase: registerUseCase,
    loginUseCase: loginUseCase,
  );

  runApp(
    BlocProvider(
      create: (context) => authBloc,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Providers
    final client = http.Client();
    final remoteDataSource = AuthRemoteDataSourceImpl(client: client);
    final repository = AuthRepositoryImpl(remoteDataSource);
    final registerUseCase = RegisterUseCase(repository);
    final authBloc = AuthBloc(registerUseCase: registerUseCase);

    // Wrap MaterialApp with BlocProvider
    return BlocProvider(
      create: (context) => authBloc,
      child: MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage()),
    );
  }
}

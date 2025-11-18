import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/auth/presentation/register_page.dart';
import 'firebase_options.dart'; // File tự động sinh ra sau khi chạy lệnh flutterfire configure

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Đăng xuất để luôn quay lại trang đăng nhập khi khởi động lại app
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut(); // 👈 Thêm dòng này để xóa session Google

  // ✅ Kiểm tra kết nối Firestore (chỉ để debug)
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('danh_muc').get();
    debugPrint(
        '🔥 Kết nối Firebase thành công! Số danh mục: ${snapshot.docs.length}');
  } catch (e) {
    debugPrint('❌ Lỗi khi kết nối Firebase: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Travel App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),

      // ✅ Theo dõi trạng thái đăng nhập Firebase
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (_) => const LoginPage(),
        RegisterPage.routeName: (_) => const RegisterPage(),
        '/home': (_) => const HomePage(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
          if (snap.hasData) return const HomePage();
          return const LoginPage(onLoggedInRoute: '/home');
        },
      ),
    );
  }
}

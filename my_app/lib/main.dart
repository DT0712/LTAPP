import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/auth/presentation/login_page.dart';
import 'firebase_options.dart'; // file này được tạo khi bạn chạy lệnh flutterfire configure

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Kiểm tra kết nối Firestore
  try {
    final snapshot =
        await FirebaseFirestore.instance.collection('danh_muc').get();
    print(
        '🔥 Kết nối Firebase thành công! Số danh mục: ${snapshot.docs.length}');
  } catch (e) {
    print('❌ Lỗi khi kết nối Firebase: $e');
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

      // ✅ Kiểm tra trạng thái đăng nhập Firebase
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Nếu đang kiểm tra trạng thái đăng nhập
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Nếu đã đăng nhập
          if (snapshot.hasData) {
            return const HomePage();
          }

          // Nếu chưa đăng nhập
          return const LoginPage();
        },
      ),
    );
  }
}

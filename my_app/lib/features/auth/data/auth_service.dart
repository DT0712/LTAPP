import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 🔹 Đăng nhập bằng Email & Mật khẩu
  Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Đăng nhập thất bại";
    }
  }

  /// 🔹 Đăng ký tài khoản Email
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Đăng ký thất bại";
    }
  }

  /// 🔹 Đăng nhập bằng Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Bắt đầu quá trình đăng nhập Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Người dùng đã huỷ đăng nhập Google');
      }

      // Lấy token xác thực từ Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Tạo credential để đăng nhập Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập Firebase bằng credential của Google
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Đăng nhập Google thất bại";
    } catch (e) {
      throw "Lỗi đăng nhập Google: $e";
    }
  }

  /// 🔹 Đăng xuất
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
    } catch (e) {
      throw "Đăng xuất thất bại: $e";
    }
  }

  /// 🔹 Lấy thông tin người dùng hiện tại
  User? get currentUser => _auth.currentUser;
}

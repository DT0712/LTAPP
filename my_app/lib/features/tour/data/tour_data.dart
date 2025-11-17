import 'package:cloud_firestore/cloud_firestore.dart';

class TourRepository {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lấy danh sách quận huyện từ Firestore (bảng quan_huyen)
  static Stream<List<Map<String, dynamic>>> getDistricts() {
    return _db.collection('quan_huyen').snapshots().map(
          (snap) => snap.docs.map((d) => d.data()).toList(),
        );
  }

  // Lấy lịch trình random theo thời gian (1 ngày, 2n1d, 3n2d)
  static Stream<Map<String, dynamic>?> getRandomTour(String timeKey) {
    return _db
        .collection('tour')
        .doc("random_$timeKey")
        .snapshots()
        .map((doc) => doc.data());
  }
}

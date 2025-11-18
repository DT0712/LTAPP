import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../home/data/home_references.dart';

class FoodRepository {
  Stream<QuerySnapshot> getFoods({
    required String tab,
    String? quan,
  }) {
    Query query =
        HomeReferences.placesRef.where('danh_muc_id', isEqualTo: 'quan_an');

    // Lọc theo quận
    if (quan != null && quan.isNotEmpty) {
      query = query.where('quan', isEqualTo: HomeReferences.cleanText(quan));
    }

    switch (tab) {
      case 'Gợi ý':
        return query.orderBy('danh_gia', descending: true).snapshots();
      case 'Mới nhất':
        return query.orderBy('ngay_tao', descending: true).snapshots();
      case 'Giảm nhiều':
        return query
            .where('giam_gia', isGreaterThan: 0)
            .orderBy('giam_gia', descending: true)
            .snapshots();
      case 'Gần tôi':
        return query.snapshots();
      default:
        return query.snapshots();
    }
  }
}

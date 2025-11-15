import 'package:cloud_firestore/cloud_firestore.dart';
import 'destination_model.dart'; // Đảm bảo import đúng mô hình

class DestinationRepository {
  final FirebaseFirestore _db;
  DestinationRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  /// Lấy danh sách địa điểm đề xuất, lọc theo quận (quan_huyen_id) + sắp xếp theo danh_gia
  Stream<List<DestinationModel>> streamDestinations({
    String? district, // quan_huyen_id (vd: "quan_1")
  }) {
    // Bắt đầu truy vấn trực tiếp vào collection 'dia_diem_de_xuat'
    Query<Map<String, dynamic>> q = _db.collection('dia_diem_de_xuat');

    // Nếu có district được cung cấp, thêm điều kiện lọc theo 'quan_huyen_id'
    if (district != null && district.isNotEmpty) {
      q = q.where('quan_huyen_id', isEqualTo: district);
    }

    // Sắp xếp theo đánh giá (number), giảm dần
    q = q.orderBy('danh_gia', descending: true);

    return q.snapshots().map(
          (snap) => snap.docs
              .map((d) => DestinationModel.fromSnapshot(d)) // SỬA LỖI Ở ĐÂY
              .toList(),
        );
  }
}

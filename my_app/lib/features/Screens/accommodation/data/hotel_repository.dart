import 'package:cloud_firestore/cloud_firestore.dart';
import 'hotel_model.dart';

class HotelRepository {
  final FirebaseFirestore _db;
  HotelRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  String _toTypeId(String? typeLabel) {
    switch ((typeLabel ?? '').trim()) {
      case 'Khách sạn':
        return 'khach_san';
      case 'Homestay':
        return 'home_stay';
      case 'Resort':
        return 'resort';
      default:
        return 'khach_san';
    }
  }


  CollectionReference<Map<String, dynamic>> _colFor(String typeId) {
    return _db.collection('luu_tru').doc(typeId).collection('1');
  }


  Stream<List<Hotel>> streamHotels({
    String? type,
    String? district,
  }) {
    final typeId = _toTypeId(type);
    Query<Map<String, dynamic>> q = _colFor(typeId);

    if (district != null && district.isNotEmpty) {
      q = q.where('quan_huyen_id', isEqualTo: district);
    }

    // Sắp xếp theo đánh giá
    q = q.orderBy('danh_gia', descending: true);

    return q.snapshots().map(
          (snap) => snap.docs.map((d) => Hotel.fromDoc(d)).toList(),
    );
  }
}

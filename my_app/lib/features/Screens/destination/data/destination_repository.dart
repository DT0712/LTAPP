import 'package:cloud_firestore/cloud_firestore.dart';
import 'destination_model.dart';

class DestinationRepository {
  final FirebaseFirestore _db;
  DestinationRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  Stream<List<DestinationModel>> streamDestinations({
    String? district,
  }) {
    Query<Map<String, dynamic>> q = _db.collection('dia_diem_de_xuat');

    if (district != null && district.isNotEmpty) {
      q = q.where('quan_huyen_id', isEqualTo: district);
    }

    q = q.orderBy('danh_gia', descending: true);

    return q.snapshots().map(
          (snap) =>
              snap.docs.map((d) => DestinationModel.fromSnapshot(d)).toList(),
        );
  }
}

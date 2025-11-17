// lib/features/attraction/data/attraction_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'attraction_model.dart';
import 'attraction_references.dart';

class AttractionRepository {
  Stream<List<Attraction>> streamAttractions({String? districtId}) {
    Query<Map<String, dynamic>> q = AttractionReferences.attractionsRef;

    if (districtId != null && districtId.isNotEmpty) {
      // Khi có lọc quận: chỉ where, KHÔNG orderBy để tránh cần composite index
      q = q.where('quan_huyen_id', isEqualTo: districtId);
      return q.snapshots().map((snap) {
        final list = snap.docs.map((d) => Attraction.fromDoc(d)).toList();
        // Muốn vẫn sắp xếp theo rating thì sort ở client:
        list.sort((a, b) => (b.rating).compareTo(a.rating));
        return list;
      });
    } else {
      // Không lọc: thoải mái orderBy
      q = q.orderBy('danh_gia', descending: true);
      return q.snapshots().map((snap) =>
          snap.docs.map((d) => Attraction.fromDoc(d)).toList());
    }
  }
}

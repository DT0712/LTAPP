import 'package:cloud_firestore/cloud_firestore.dart';
import 'attraction_model.dart';
import 'attraction_references.dart';

class AttractionRepository {
  Stream<List<Attraction>> streamAttractions({String? districtId}) {
    Query<Map<String, dynamic>> q = AttractionReferences.attractionsRef;
    if (districtId != null && districtId.isNotEmpty) {
      q = q.where('quan_huyen_id', isEqualTo: districtId);
      return q.snapshots().map((snap) {
        final list = snap.docs.map((d) => Attraction.fromDoc(d)).toList();
        list.sort((a, b) => (b.rating).compareTo(a.rating));
        return list;
      });
    } else {
      q = q.orderBy('danh_gia', descending: true);
      return q.snapshots().map((snap) =>
          snap.docs.map((d) => Attraction.fromDoc(d)).toList());
    }
  }
}

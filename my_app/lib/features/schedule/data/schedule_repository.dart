import 'package:cloud_firestore/cloud_firestore.dart';
import 'schedule_model.dart';

class ScheduleRepository {
  final FirebaseFirestore _db;

  ScheduleRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  /// Stream all schedule items. Optionally filter by `tripId` if your documents have that field.
  Stream<List<ScheduleItem>> streamSchedules({String? tripId}) {
    CollectionReference<Map<String, dynamic>> col = _db.collection('schedules');
    Query<Map<String, dynamic>> q = col;
    if (tripId != null && tripId.isNotEmpty)
      q = q.where('tripId', isEqualTo: tripId);
    return q
        .snapshots()
        .map((snap) => snap.docs.map((d) => ScheduleItem.fromDoc(d)).toList());
  }

  /// One-shot fetch
  Future<List<ScheduleItem>> fetchSchedules({String? tripId}) async {
    Query<Map<String, dynamic>> q = _db.collection('schedules');
    if (tripId != null && tripId.isNotEmpty)
      q = q.where('tripId', isEqualTo: tripId);
    final snap = await q.get();
    return snap.docs.map((d) => ScheduleItem.fromDoc(d)).toList();
  }
}

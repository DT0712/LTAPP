import 'package:cloud_firestore/cloud_firestore.dart';
import 'schedule_model.dart';

class ScheduleRepository {
  final FirebaseFirestore _db;

  ScheduleRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  FirebaseFirestore get db => _db;

  CollectionReference<Map<String, dynamic>> _colFor(String typeId) {
    return _db.collection('lich_trinh').doc(typeId).collection('1');
  }

  Stream<List<ScheduleItem>> streamSchedules({String typeId = 'default'}) {
    return _colFor(typeId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ScheduleItem.fromDoc(doc)).toList();
    });
  }
}

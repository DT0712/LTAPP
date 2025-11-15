// lib/data/transport_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class TransportRepository {
  static final CollectionReference<Map<String, dynamic>> ref =
      FirebaseFirestore.instance.collection('phuong_tien');

  // Luôn return tất cả để filter client-side
  static Stream<QuerySnapshot> getAllTransportStream() {
    return ref.snapshots();
  }
}

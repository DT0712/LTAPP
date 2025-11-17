import 'package:cloud_firestore/cloud_firestore.dart';

class AttractionReferences {
  static final _db = FirebaseFirestore.instance;

  /// Collection quận/huyện
  static CollectionReference<Map<String, dynamic>> get quanHuyenRef =>
      _db.collection('quan_huyen');

  /// Collection khu vui chơi
  static CollectionReference<Map<String, dynamic>> get attractionsRef =>
      _db.collection('khu_vui_choi');
}

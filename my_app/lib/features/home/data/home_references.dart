import 'package:cloud_firestore/cloud_firestore.dart';

class HomeReferences {
  static final CollectionReference<Map<String, dynamic>> danhMucRef =
      FirebaseFirestore.instance.collection('danh_muc');
  static final CollectionReference<Map<String, dynamic>> diaDiemDeXuatRef =
      FirebaseFirestore.instance.collection('dia_diem_de_xuat');
  static final CollectionReference<Map<String, dynamic>> placesRef =
      FirebaseFirestore.instance.collection('places');
  static final CollectionReference<Map<String, dynamic>> quanHuyenRef =
      FirebaseFirestore.instance.collection('quan_huyen');

  static String cleanText(String s) {
    return s.replaceAll('\u00A0', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}

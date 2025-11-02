// lib/features/home/data/home_references.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeReferences {
  static final CollectionReference danhMucRef =
      FirebaseFirestore.instance.collection('danh_muc');
  static final CollectionReference diaDiemDeXuatRef =
      FirebaseFirestore.instance.collection('dia_diem_de_xuat');
  static final CollectionReference placesRef =
      FirebaseFirestore.instance.collection('places');
  static final CollectionReference quanHuyenRef =
      FirebaseFirestore.instance.collection('quan_huyen');

  static String cleanText(String s) {
    return s.replaceAll('\u00A0', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}

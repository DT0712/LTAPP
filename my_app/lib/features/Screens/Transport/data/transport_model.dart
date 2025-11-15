// lib/data/transport_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class TransportModel {
  final String id;
  final String ten;
  final String moTa;
  final String loai;
  final String icon; // Sử dụng icon từ dữ liệu Firebase
  final String giaTrungBinh;
  final double danhGia;
  final List<String> the;
  final List<DichVu> dichVu;

  TransportModel({
    required this.id,
    required this.ten,
    required this.moTa,
    required this.loai,
    required this.icon,
    required this.giaTrungBinh,
    required this.danhGia,
    required this.the,
    required this.dichVu,
  });

  factory TransportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Xử lý dich_vu: list of maps -> list of DichVu
    List<DichVu> dichVuList = [];
    if (data['dich_vu'] != null) {
      for (var service in data['dich_vu']) {
        dichVuList.add(DichVu.fromMap(service as Map<String, dynamic>));
      }
    }

    return TransportModel(
      id: doc.id,
      ten: data['ten'] ?? '',
      moTa: data['mo_ta'] ?? '',
      loai: data['loai'] ?? '',
      icon: data['icon'] ?? 'assets/images/default.png',
      giaTrungBinh: data['gia_trung_binh'] ?? '',
      danhGia: (data['danh_gia'] ?? 0.0).toDouble(),
      the: List<String>.from(data['the'] ?? []),
      dichVu: dichVuList,
    );
  }
}

class DichVu {
  final String ten;

  DichVu({required this.ten});

  factory DichVu.fromMap(Map<String, dynamic> map) {
    return DichVu(
      ten: map['ten'] ?? '',
    );
  }
}

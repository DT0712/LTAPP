import 'package:cloud_firestore/cloud_firestore.dart';

class DestinationModel {
  final String id;
  final String ten;
  final String diaChiBo;
  final String hinhAnh;
  final double danhGia;
  final String moTa;
  final String gioMoHang;
  final String giaVe;

  DestinationModel({
    required this.id,
    required this.ten,
    required this.diaChiBo,
    required this.hinhAnh,
    required this.danhGia,
    required this.moTa,
    required this.gioMoHang,
    required this.giaVe,
  });

  factory DestinationModel.fromMap(Map<String, dynamic> map, String docId) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return DestinationModel(
      id: docId,
      ten: map['ten'] ?? 'Chưa rõ',
      diaChiBo: map['dia_chi'] ?? '',
      hinhAnh: map['hinh_anh'] ?? '',
      danhGia: parseDouble(map['danh_gia']),
      moTa: map['mo_ta_ngan'] ?? map['mo_ta'] ?? '',
      gioMoHang: map['gio_mo_hang'] ?? 'Không rõ',
      giaVe: map['gia_ve'] ?? 'Liên hệ',
    );
  }

  factory DestinationModel.fromSnapshot(DocumentSnapshot snapshot) {
    return DestinationModel.fromMap(
      snapshot.data() as Map<String, dynamic>,
      snapshot.id,
    );
  }
}

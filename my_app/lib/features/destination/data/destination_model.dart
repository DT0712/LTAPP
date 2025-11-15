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
  final double latitude;
  final double longitude;

  DestinationModel({
    required this.id,
    required this.ten,
    required this.diaChiBo,
    required this.hinhAnh,
    required this.danhGia,
    required this.moTa,
    required this.gioMoHang,
    required this.giaVe,
    required this.latitude,
    required this.longitude,
  });

  factory DestinationModel.fromMap(Map<String, dynamic> map, String docId) {
    return DestinationModel(
      id: docId,
      ten: map['ten'] ?? 'Chưa rõ',
      diaChiBo: map['dia_chi'] ?? '',
      hinhAnh: map['hinh_anh'] ?? '',
      danhGia: (map['danh_gia'] as num?)?.toDouble() ?? 0.0,
      moTa: map['mo_ta'] ?? '',
      gioMoHang: map['gio_mo_hang'] ?? 'Không rõ',
      giaVe: map['gia_ve'] ?? 'Liên hệ',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory DestinationModel.fromSnapshot(DocumentSnapshot snapshot) {
    return DestinationModel.fromMap(
      snapshot.data() as Map<String, dynamic>,
      snapshot.id,
    );
  }
}

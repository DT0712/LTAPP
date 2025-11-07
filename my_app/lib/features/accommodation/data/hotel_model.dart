import 'package:cloud_firestore/cloud_firestore.dart';

class Hotel {
  final String id;
  final String name;
  final String address;
  final String district;     // quan_huyen_id
  final String type;
  final List<String> images; // luôn là List sau khi parse
  final double rating;
  final int? priceFrom;

  Hotel({
    required this.id,
    required this.name,
    required this.address,
    required this.district,
    required this.type,
    required this.images,
    required this.rating,
    this.priceFrom,
  });

  static List<String> _parseImages(dynamic v) {
    if (v == null) return [];
    if (v is String && v.trim().isNotEmpty) return [v.trim()];
    if (v is List) return v.map((e) => e.toString()).toList();
    return [];
  }

  static double _parseDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    final s = v.toString().replaceAll('.', '').replaceAll(',', '.').trim();
    final p = double.tryParse(s);
    return p ?? 0.0;
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toInt();
    return int.tryParse(
      v.toString().replaceAll('.', '').replaceAll(',', ''),
    );
  }

  factory Hotel.fromDoc(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};
    return Hotel(
      id: doc.id,
      name: (data['ten'] ?? data['name'] ?? '').toString(),
      address: (data['dia_chi'] ?? data['address'] ?? '').toString(),
      district: (data['quan_huyen_id'] ?? data['district'] ?? '').toString(),
      type: (data['type'] ?? 'khach_san').toString(),
      images: _parseImages(data['images']),
      rating: _parseDouble(data['danh_gia'] ?? data['rating']),
      priceFrom: _parseInt(data['priceFrom']),
    );
  }
}

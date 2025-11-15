import 'package:cloud_firestore/cloud_firestore.dart';

class Attraction {
  final String id;
  final String name;
  final String address;
  final List<String> images;
  final double rating;
  final num? priceFrom;
  final String? districtId;
  final String? districtName;

  Attraction({
    required this.id,
    required this.name,
    required this.address,
    required this.images,
    required this.rating,
    this.priceFrom,
    this.districtId,
    this.districtName,
  });

  factory Attraction.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? {};

    final rawImgs = m['images'];
    final List<String> imgs =
    rawImgs is List ? rawImgs.map((e) => e.toString()).toList()
        : (rawImgs is String && rawImgs.isNotEmpty) ? [rawImgs]
        : <String>[];

    return Attraction(
      id: d.id,
      name: (m['ten'] ?? '').toString(),
      address: (m['dia_chi'] ?? '').toString(),
      images: imgs,
      rating: (m['danh_gia'] is num) ? (m['danh_gia'] as num).toDouble() : 0.0,
      priceFrom: m['priceFrom'],
      districtId: (m['quan_huyen_id'] ?? '').toString().isEmpty ? null : m['quan_huyen_id'],
      districtName: (m['quan_huyen_ten'] ?? '').toString().isEmpty ? null : m['quan_huyen_ten'],
    );
  }
}

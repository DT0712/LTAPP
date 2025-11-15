import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class DestinationModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String location;
  final double rating;
  final int reviewCount;
  final String category; // "Danh lam thắng cảnh", "Bãi biển", "Núi", etc.
  final List<String> amenities; // Tiện ích
  final String openingHours;
  final String ticketPrice;
  final double latitude;
  final double longitude;
  final DateTime createdAt;

  const DestinationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.amenities,
    required this.openingHours,
    required this.ticketPrice,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });

  /// Chuyển đổi từ Firestore Document sang Model
  factory DestinationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return DestinationModel(
      id: doc.id,
      name: data['name'] as String? ?? 'Chưa rõ',
      description: data['description'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      location: data['location'] as String? ?? '',
      rating: (data['rating'] as num? ?? 0).toDouble(),
      reviewCount: data['reviewCount'] as int? ?? 0,
      category: data['category'] as String? ?? 'Khác',
      amenities: List<String>.from(data['amenities'] as List<dynamic>? ?? []),
      openingHours: data['openingHours'] as String? ?? 'Không rõ',
      ticketPrice: data['ticketPrice'] as String? ?? 'Liên hệ',
      latitude: (data['latitude'] as num? ?? 0).toDouble(),
      longitude: (data['longitude'] as num? ?? 0).toDouble(),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  /// Chuyển đổi Model thành Map để lưu vào Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'rating': rating,
      'reviewCount': reviewCount,
      'category': category,
      'amenities': amenities,
      'openingHours': openingHours,
      'ticketPrice': ticketPrice,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        location,
        rating,
        reviewCount,
        category,
        amenities,
        openingHours,
        ticketPrice,
        latitude,
        longitude,
        createdAt,
      ];
}

import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleItem {
  final String id;
  final String name;
  final String day;
  final String place;
  final String description;
  final String district;
  final String? image;
  final String? duration;
  final String? category;

  ScheduleItem({
    required this.id,
    required this.day,
    required this.place,
    required this.name,
    required this.description,
    required this.district,
    this.image,
    this.duration,
    this.category,
  });

  factory ScheduleItem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ScheduleItem(
      id: doc.id,
      name: (data['ten'] ?? data['name'] ?? '').toString(),
      day: (data['so_ngay'] ?? data['day'] ?? '').toString(),
      district: (data['quan_huyen_id'] ?? data['district'] ?? '').toString(),
      description: (data['cu_the'] ?? data['description'] ?? '').toString(),
      place: data['place']?.toString() ?? '',
      image: data['image']?.toString(),
      duration: data['duration']?.toString(),
      category: data['category']?.toString(),
    );
  }
}

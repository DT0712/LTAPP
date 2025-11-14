import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleItem {
  final String id;
  final String day;
  final String time;
  final String place;
  final String? description;
  final String? imageUrl;
  final String? duration;
  final String? district;
  final String? category; // e.g., 'Lịch trình nhẻ buạt', 'Tất cả tất cả tất cả'

  ScheduleItem({
    required this.id,
    required this.day,
    required this.time,
    required this.place,
    this.description,
    this.imageUrl,
    this.duration,
    this.district,
    this.category,
  });

  factory ScheduleItem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ScheduleItem(
      id: doc.id,
      day: data['day']?.toString() ?? '',
      time: data['time']?.toString() ?? '',
      place: data['place']?.toString() ?? '',
      description: data['description']?.toString(),
      imageUrl: data['imageUrl']?.toString(),
      duration: data['duration']?.toString(),
      district: data['district']?.toString(),
      category: data['category']?.toString(),
    );
  }
}

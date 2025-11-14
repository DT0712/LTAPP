import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleItem {
  final String id;
  final String day;
  final String time;
  final String place;
  final String? description;

  ScheduleItem({
    required this.id,
    required this.day,
    required this.time,
    required this.place,
    this.description,
  });

  factory ScheduleItem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ScheduleItem(
      id: doc.id,
      day: data['day']?.toString() ?? '',
      time: data['time']?.toString() ?? '',
      place: data['place']?.toString() ?? '',
      description: data['description']?.toString(),
    );
  }
}

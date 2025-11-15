// lib/features/schedule/data/schedule_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleItem {
  final String id;
  final String name; // Từ trường 'ten'
  final String day; // Từ trường 'so_ngay'
  final String describetion; // Từ trường 'mo_ta'
  final String description; // Từ trường 'cu_the' (đã nối)
  final String? image; // Từ trường 'hinh_anh'
  final String? duration; // Từ trường 'thoi_gian'

  ScheduleItem({
    required this.id,
    required this.name,
    required this.day,
    required this.describetion, // 'mo_ta'
    required this.description, // 'cu_the'
    this.image,
    this.duration,
  });

  factory ScheduleItem.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // SỬA LỖI: Chuyển đổi List<dynamic> (cu_the) thành String
    String desc = '';
    if (data['cu_the'] is List) {
      // Nối mảng lại, ví dụ: "1. ... \n2. ..."
      desc =
          (data['cu_the'] as List<dynamic>).map((e) => e.toString()).join('\n');
    } else {
      desc = (data['cu_the'] ?? '').toString();
    }

    return ScheduleItem(
      id: doc.id,
      name: (data['ten'] ?? '').toString(),
      day: (data['so_ngay'] ?? '').toString(),
      describetion: (data['mo_ta'] ?? '').toString(),
      description: desc, // Sử dụng chuỗi 'cu_the' đã xử lý
      image: (data['hinh_anh'] ?? '').toString(), // Giả sử có trường hinh_anh
      duration: (data['thoi_gian'] ?? '').toString(),
    );
  }
}

// lib/features/schedule/data/schedule_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'schedule_model.dart';

class ScheduleRepository {
  final FirebaseFirestore _db;

  ScheduleRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  FirebaseFirestore get db => _db;

  Stream<List<ScheduleItem>> streamSchedules({
    String? duration,
  }) {
    Query<Map<String, dynamic>> q = _db.collection('lich_trinh');

    if (duration != null && duration.isNotEmpty && duration != 'Tất cả') {
      q = q.where('thoi_gian', isEqualTo: duration);
    }

    return q.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => ScheduleItem.fromDoc(doc)).toList();
    });
  }

  //Thêm hàm mới để lấy 'thoi_gian' duy nhất
  Future<List<String>> getUniqueDurations() async {
    try {
      // 1. Truy vấn collection 'lich_trinh' một lần
      final snapshot = await _db.collection('lich_trinh').get();

      // 2. Dùng Set để tự động loại bỏ các giá trị trùng lặp
      // Luôn bắt đầu với 'Tất cả'
      final Set<String> durations = {'Tất cả'};

      // 3. Lặp qua từng tài liệu
      for (final doc in snapshot.docs) {
        final data = doc.data();
        if (data.containsKey('thoi_gian')) {
          final duration = data['thoi_gian'] as String?;
          // Thêm vào Set nếu nó không rỗng
          if (duration != null && duration.isNotEmpty) {
            durations.add(duration);
          }
        }
      }

      // 4. Chuyển Set thành List và trả về
      return durations.toList();
    } catch (e) {
      print("Lỗi khi lấy durations: $e");
      // Trả về danh sách cơ bản nếu có lỗi
      return ['Tất cả', '1 ngày'];
    }
  }
}

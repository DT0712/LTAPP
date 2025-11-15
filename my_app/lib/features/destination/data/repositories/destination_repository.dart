import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/destination_model.dart';

class DestinationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy tất cả điểm đến từ Firestore
  Future<List<DestinationModel>> getAllDestinations() async {
    try {
      final snapshot = await _firestore.collection('destinations').get();
      return snapshot.docs
          .map((doc) => DestinationModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy dữ liệu điểm đến: $e');
    }
  }

  /// Lấy điểm đến theo danh mục
  Future<List<DestinationModel>> getDestinationsByCategory(
      String category) async {
    try {
      final snapshot = await _firestore
          .collection('destinations')
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs
          .map((doc) => DestinationModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy điểm đến theo danh mục: $e');
    }
  }

  /// Lấy điểm đến theo ID
  Future<DestinationModel> getDestinationById(String id) async {
    try {
      final doc = await _firestore.collection('destinations').doc(id).get();
      if (!doc.exists) {
        throw Exception('Điểm đến không tồn tại');
      }
      return DestinationModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Lỗi khi lấy chi tiết điểm đến: $e');
    }
  }

  /// Tìm kiếm điểm đến theo tên
  Future<List<DestinationModel>> searchDestinations(String query) async {
    try {
      final snapshot = await _firestore
          .collection('destinations')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .get();
      return snapshot.docs
          .map((doc) => DestinationModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi tìm kiếm: $e');
    }
  }

  /// Lấy các điểm đến được đánh giá cao nhất
  Future<List<DestinationModel>> getTopRatedDestinations(
      {int limit = 10}) async {
    try {
      final snapshot = await _firestore
          .collection('destinations')
          .orderBy('rating', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => DestinationModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy điểm đến được đánh giá cao: $e');
    }
  }

  /// Lấy danh sách các danh mục có sẵn
  Future<List<String>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('destinations').get();
      final categories = <String>{};
      for (var doc in snapshot.docs) {
        final category = doc['category'] as String?;
        if (category != null) {
          categories.add(category);
        }
      }
      return categories.toList();
    } catch (e) {
      throw Exception('Lỗi khi lấy danh mục: $e');
    }
  }
}

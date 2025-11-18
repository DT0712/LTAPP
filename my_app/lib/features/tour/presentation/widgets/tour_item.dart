import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // Nếu chưa có: thêm vào pubspec.yaml

class TourItem extends StatelessWidget {
  final String ten;
  final String thoiDiem;
  final String moTa;

  const TourItem({
    super.key,
    required this.ten,
    required this.thoiDiem,
    required this.moTa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon trái cực đẹp
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              LucideIcons.mapPin,
              size: 22,
              color: Colors.orange,
            ),
          ),

          const SizedBox(width: 14),

          // Nội dung bên phải
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TÊN ĐỊA ĐIỂM
                Text(
                  ten,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                // THỜI ĐIỂM (nổi bật)
                Row(
                  children: [
                    const Icon(LucideIcons.clock, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      thoiDiem,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // MÔ TẢ
                Text(
                  moTa,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

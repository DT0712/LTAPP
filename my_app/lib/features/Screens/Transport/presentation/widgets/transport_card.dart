// lib/widgets/transport_card.dart
import 'package:flutter/material.dart';
import '../../data/transport_model.dart';

class TransportCard extends StatelessWidget {
  final TransportModel item;

  const TransportCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh/icon bên trái
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              image: DecorationImage(
                image: AssetImage(item.icon),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Nội dung bên phải
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên
                  Text(
                    item.ten,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32), // Xanh lá đậm
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Mô tả
                  Text(
                    item.moTa,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  // Loại
                  Row(
                    children: [
                      const Icon(Icons.category,
                          size: 16, color: Color(0xFF4CAF50)),
                      const SizedBox(width: 4),
                      Text(
                        "Loại: ${item.loai}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Đánh giá và giá
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "${item.danhGia.toStringAsFixed(1)}",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF81C784),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          item.giaTrungBinh,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Tags (thẻ)
                  if (item.the.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: item.the
                          .map((tag) => Chip(
                                label: Text(tag,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                backgroundColor: const Color(
                                    0xFF81C784), // Xanh lá nhạt cho chip
                                visualDensity: VisualDensity.compact,
                              ))
                          .toList(),
                    ),
                  const SizedBox(height: 8),
                  // Dịch vụ
                  if (item.dichVu.isNotEmpty) ...[
                    const Text(
                      "Dịch vụ:",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32)),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      children: item.dichVu
                          .map((dv) => Chip(
                                label: Text(dv.ten,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white)),
                                backgroundColor: const Color(0xFF4CAF50),
                                visualDensity: VisualDensity.compact,
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../data/destination_model.dart';

class DestinationDetailDialog extends StatelessWidget {
  final DestinationModel destination;

  const DestinationDetailDialog({
    super.key,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header và nút đóng
          Stack(
            children: [
              Hero(
                tag: destination.id,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Image.asset(
                      destination.hinhAnh.isEmpty
                          ? 'assets/images/DiaDiem/default.png'
                          : destination.hinhAnh,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image,
                            size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              // Badge Rating
              Positioned(
                bottom: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star,
                          color: Color(0xFFFFB000), size: 16),
                      const SizedBox(width: 4),
                      Text(
                        destination.danhGia.toStringAsFixed(1),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),

          // Nội dung chi tiết
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên địa điểm
                  Text(
                    destination.ten,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // --- THÔNG TIN HÀNH CHÍNH (Địa chỉ, Giờ, Giá) ---

                  // Địa chỉ
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          destination.diaChiBo,
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                              height: 1.3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Giờ mở cửa
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.access_time_filled,
                          color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Giờ mở cửa: ${destination.gioMoHang}',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                              height: 1.3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Giá vé
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                          Icons
                              .confirmation_number, // Hoặc dùng Icons.local_activity
                          color: Colors.green,
                          size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Giá vé: ${destination.giaVe}',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[800],
                              height: 1.3),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Tiêu đề mô tả
                  const Text(
                    "Giới thiệu",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),

                  // Nội dung mô tả
                  Text(
                    destination.moTa.isNotEmpty
                        ? destination.moTa
                        : "Chưa có mô tả chi tiết cho địa điểm này.",
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black54, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ),

          // Nút Đóng
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6CA8FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Đóng",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

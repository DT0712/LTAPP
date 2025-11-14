import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../accommodation/data/hotel_model.dart';

class HotelCard extends StatelessWidget {
  const HotelCard({
    super.key,
    required this.hotel,
    this.onBookPressed,
  });

  final Hotel hotel;
  final VoidCallback? onBookPressed;

  /// Định dạng số VND có dấu chấm + hậu tố " VND/đêm"
  String _formatVndPerNight(dynamic value) {
    num n;
    if (value is num) {
      n = value;
    } else {
      n = num.tryParse(value?.toString() ?? '') ?? 0;
    }
    final digits = NumberFormat.decimalPattern('vi_VN').format(n);
    return '$digits VND/đêm';
  }

  @override
  Widget build(BuildContext context) {
    final img = (hotel.images.isNotEmpty) ? hotel.images.first : null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh bo tròn như mockup
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 110,
              height: 78,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF6CA8FF), width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: img == null
                  ? Image.asset(
                'assets/images/DanhMuc/default.png',
                fit: BoxFit.cover,
              )
                  : (img.startsWith('http')
                  ? Image.network(img, fit: BoxFit.cover)
                  : Image.asset(img, fit: BoxFit.cover)),
            ),
          ),
          const SizedBox(width: 12),

          // Thông tin
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hotel.address,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber[700]),
                    const SizedBox(width: 4),
                    Text(
                      // nếu rating null thì hiển thị 0.0
                      (hotel.rating ?? 0).toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Spacer(),
                    if (hotel.priceFrom != null)
                      Text(
                        _formatVndPerNight(hotel.priceFrom),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

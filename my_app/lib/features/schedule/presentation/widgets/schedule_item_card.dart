// lib/features/schedule/presentation/widgets/schedule_item_card.dart
import 'package:flutter/material.dart';
import '../../data/schedule_model.dart';

class ScheduleItemCard extends StatelessWidget {
  final ScheduleItem item;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDetailPressed;

  const ScheduleItemCard({
    super.key,
    required this.item,
    this.selected = false,
    this.onTap,
    this.onDetailPressed,
  });

  @override
  Widget build(BuildContext context) {
    final img = item.image;

    // Style giống hệt HotelCard
    const Color kCardBorder = Color(0x14000000);
    const double kElevationBlur = 10;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kCardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: kElevationBlur,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ảnh (SỬA ĐỔI: Tăng kích thước ảnh)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 160,
                    height: 120,
                    child: (img != null && img.isNotEmpty)
                        ? (img.startsWith('http')
                            ? Image.network(
                                img,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image_outlined),
                              )
                            : Image.asset(
                                img,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image_outlined),
                              ))
                        : Image.asset('assets/images/DanhMuc/default.png',
                            fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 12),

                // Thông tin
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên lịch trình ('ten')
                      Text(
                        item.name,
                        maxLines: 2, // Tên sẽ vừa trong 1 dòng
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Mô tả ('mo_ta')
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2.0),
                            child: Icon(Icons.description_outlined,
                                size: 14, color: Colors.black54),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.describetion, // Sử dụng 'mo_ta'
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                height: 1.25,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Hiển thị Số ngày ('so_ngay')
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD6F5FF), // Màu khác
                              borderRadius: BorderRadius.circular(999),
                              border:
                                  Border.all(color: const Color(0xFFA1DFFF)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today,
                                    size: 14, color: Color(0xFF007BFF)),
                                const SizedBox(width: 4),
                                Text(
                                  // Hiển thị số ngày ('so_ngay')
                                  '${item.day} ngày',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Nút "Xem chi tiết"
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: selected
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: AnimatedOpacity(
                          opacity: selected ? 1 : 0,
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6CA8FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            onPressed: onDetailPressed,
                            child: const Text('Xem chi tiết',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

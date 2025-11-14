import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../accommodation/data/hotel_model.dart';

class HotelCard extends StatelessWidget {
  const HotelCard({
    super.key,
    required this.hotel,
    required this.selected,
    this.onTap,
    this.onBookPressed,
  });

  final Hotel hotel;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onBookPressed;

  // Format VND: 1.234.567
  String _fmtVND(num value) {
    final s = value.toStringAsFixed(0);
    final re = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(re, (m) => '.');
  }

  @override
  Widget build(BuildContext context) {
    final img = (hotel.images.isNotEmpty) ? hotel.images.first : null;

    // ✅ Không đổi viền khi selected (xoá highlight xanh)
    const Color kCardBorder = Color(0x14000000); // viền xám nhạt luôn cố định
    const double kElevationBlur = 10;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,                       // box trắng
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kCardBorder),    // ❌ không đổi sang xanh nữa
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
                // Ảnh (❌ bỏ viền xanh overlay)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 120,
                    height: 90,
                    child: img == null
                        ? Image.asset('assets/images/DanhMuc/default.png', fit: BoxFit.cover)
                        : (img.startsWith('http')
                        ? CachedNetworkImage(
                      imageUrl: img,
                      fit: BoxFit.cover,
                      fadeInDuration: Duration.zero,
                      fadeOutDuration: Duration.zero,
                      placeholderFadeInDuration: Duration.zero,
                      placeholder: (_, __) => Container(color: const Color(0xFFEFF5FF)),
                      errorWidget: (_, __, ___) => const Icon(Icons.broken_image_outlined),
                    )
                        : Image.asset(img, fit: BoxFit.cover)),
                  ),
                ),
                const SizedBox(width: 12),

                // Thông tin
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên
                      Text(
                        hotel.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Địa chỉ
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: Icon(Icons.location_on_outlined, size: 14, color: Colors.black54),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              hotel.address,
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

                      // Rating + Giá
                      Row(
                        children: [
                          // Badge rating
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4D6),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: const Color(0xFFFFE3A1)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, size: 14, color: Color(0xFFFFB000)),
                                const SizedBox(width: 4),
                                Text(
                                  (hotel.rating ?? 0).toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          if (hotel.priceFrom != null)
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${_fmtVND(hotel.priceFrom!)} ',
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: 'VND/đêm',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Nút "Đặt ngay" (giữ animation nhưng không đổi border khi selected)
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
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCA8A65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: onBookPressed,
                      icon: const Icon(Icons.calendar_month, size: 16),
                      label: const Text('Đặt ngay'),
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

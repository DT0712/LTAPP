import 'package:flutter/material.dart';
import '../../data/destination_model.dart';

class DestinationCard extends StatelessWidget {
  final DestinationModel destination;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDetailPressed;

  const DestinationCard({
    super.key,
    required this.destination,
    this.selected = false,
    this.onTap,
    this.onDetailPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Lấy ảnh từ model
    final img = destination.hinhAnh;

    //style Card
    const Color kCardBorder = Color(0x14000000); // viền xám nhạt
    const double kElevationBlur = 10;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        //animation, margin, padding của Card
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kCardBorder),
          //Shadow của Card
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
                // Ảnh
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 120,
                    height: 90,
                    child: Image.asset(
                      img.isEmpty ? 'assets/images/DanhMuc/default.png' : img,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image_outlined),
                    ),
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
                        destination.ten,
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
                            child: Icon(Icons.location_on_outlined,
                                size: 14, color: Colors.black54),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              destination.diaChiBo,
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

                      // Rating
                      Row(
                        children: [
                          // Badge rating
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4D6),
                              borderRadius: BorderRadius.circular(999),
                              border:
                                  Border.all(color: const Color(0xFFFFE3A1)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 14, color: Color(0xFFFFB000)),
                                const SizedBox(width: 4),
                                Text(
                                  destination.danhGia.toStringAsFixed(1),
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
                          //nút "Xem chi tiết"
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              //màu của "Xem chi tiết"
                              backgroundColor: const Color(0xFF6CA8FF),
                              //style (shape, padding) của Card
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            onPressed: onDetailPressed,
                            //text của "Xem chi tiết"
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

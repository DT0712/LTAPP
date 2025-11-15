// lib/features/shared/widgets/page_header_with_filters.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PageHeaderWithFilters extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onBack;
  final Widget filterWidget;
  final double headerHeight;

  const PageHeaderWithFilters({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onBack,
    required this.filterWidget,
    this.headerHeight = 180.0,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    // SỬA ĐỔI: Xác định góc bo
    const bottomRadius = Radius.circular(20.0);
    const borderRadius = BorderRadius.only(
      bottomLeft: bottomRadius,
      bottomRight: bottomRadius,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        height: headerHeight + topPadding,
        width: double.infinity,
        padding: EdgeInsets.only(top: topPadding),
        decoration: BoxDecoration(
          // SỬA ĐỔI: Thêm borderRadius vào đây
          borderRadius: borderRadius,
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        // SỬA ĐỔI: Thêm ClipRRect để bo tròn nội dung bên trong (Stack)
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            children: [
              // Nút Back
              Positioned(
                top: 55, // Dịch xuống một chút để cân đối
                left: 10, // Dịch vào một chút
                child: Container(
                  width: 44, // Kích thước vòng tròn
                  height: 44, // Kích thước vòng tròn
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.85), // Màu trắng đục
                    boxShadow: [
                      // Thêm bóng nhẹ cho nút
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.black87,
                        size: 24), // Đổi màu icon thành đen
                    onPressed: onBack,
                    tooltip: 'Quay lại',
                  ),
                ),
              ),

              // Tiêu đề
              Positioned(
                top: 65, // Điều chỉnh vị trí tiêu đề để không bị che
                left: 65, // Dịch vào sau nút back
                right: 20, // Dịch vào để đối xứng
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          blurRadius: 4,
                          color: Colors.black54,
                          offset: Offset(1, 1)),
                    ],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Widget Lọc (Chips)
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: filterWidget,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

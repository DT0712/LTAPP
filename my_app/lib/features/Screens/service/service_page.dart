import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../home/data/home_references.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background gradient đẹp hơn: Từ tím nhạt đến trắng
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF3E5F5), // Tím nhạt ở trên
              Color(0xFFE1BEE7), // Tím nhạt hơn ở dưới
              Colors.white, // Chuyển sang trắng ở dưới cùng
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar với 2 hình tam giác tím
              _buildCustomAppBar(context),
              // Body chính
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2, // 2 cột
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      // Chức năng 1: Chăm sóc khách hàng
                      _buildServiceItem(
                        icon: Icons.support_agent,
                        title: "Chăm sóc khách hàng",
                        onTap: () {
                          // Xử lý tap: Chuyển đến trang chi tiết chăm sóc (nếu có)
                          // Ví dụ: Navigator.push(context, MaterialPageRoute(builder: (context) => ChamSocPage()));
                        },
                      ),
                      // Chức năng 2: Bản đồ và định vị
                      _buildServiceItem(
                        icon: Icons.map,
                        title: "Bản đồ và định vị",
                        onTap: () {
                          // Xử lý tap: Chuyển đến trang bản đồ (nếu có Google Maps)
                          // Ví dụ: Navigator.push(context, MaterialPageRoute(builder: (context) => BanDoPage()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      height: 120, // Chiều cao AppBar cao hơn để chứa tam giác
      width: double.infinity,
      child: Stack(
        children: [
          // Hình tam giác 1 (trái, tím đậm)
          Positioned(
            left: -50,
            top: 40,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                width: 100,
                height: 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                  ),
                ),
              ),
            ),
          ),
          // Hình tam giác 2 (phải, tím nhạt hơn)
          Positioned(
            right: -30,
            top: 20,
            child: ClipPath(
              clipper: InvertedTriangleClipper(),
              child: Container(
                width: 80,
                height: 60,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE1BEE7), Color(0xFFCE93D8)],
                  ),
                ),
              ),
            ),
          ),
          // Nền AppBar trong suốt với bo góc
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF9C27B0).withOpacity(0.8),
                  Color(0xFFBA68C8).withOpacity(0.6),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    // Nút back
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Quay về trang trước
                      },
                    ),
                    // Title căn giữa
                    Expanded(
                      child: Text(
                        "Dịch vụ & tiện ích",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    // Placeholder cho symmetric (có thể thêm nút khác nếu cần)
                    const SizedBox(width: 48), // Để cân bằng với nút back
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ảnh tròn (Container với Icon) - Thay màu xanh bằng tím để khớp theme
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF9C27B0).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF9C27B0).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                icon,
                size: 40,
                color: const Color(0xFF9C27B0),
              ),
            ),
            const SizedBox(height: 12),
            // Tên chức năng ở dưới
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CustomClipper cho tam giác (hướng xuống dưới)
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// CustomClipper cho tam giác ngược (hướng lên trên)
class InvertedTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/home_references.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String? selectedQuan;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> _getQuery(String tab) {
    Query query =
        HomeReferences.placesRef.where('danh_muc_id', isEqualTo: 'quan_an');

    if (selectedQuan != null && selectedQuan!.isNotEmpty) {
      query = query.where('quan',
          isEqualTo: HomeReferences.cleanText(selectedQuan!));
    }

    switch (tab) {
      case 'Gợi ý':
        query = query.orderBy('danh_gia', descending: true);
        break;
      case 'Mới nhất':
        query = query.orderBy('ngay_tao', descending: true);
        break;
      case 'Giảm nhiều':
        query = query
            .where('giam_gia', isGreaterThan: 0)
            .orderBy('giam_gia', descending: true);
        break;
      case 'Gần tôi':
        break;
    }
    return query.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(170),
        child: Stack(
          children: [
            // Nền tam giác lớn
            ClipPath(
              clipper: BigTriangleClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFB300), Color(0xFFFFA000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            // Tam giác nhỏ
            ClipPath(
              clipper: SmallTriangleClipper(),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFE082), Color(0xFFFFB300)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
            ),
            // Nội dung AppBar
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          "Quán ăn",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.filter_list_alt,
                              color: Colors.white),
                          onPressed: () => _showFilterDialog(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // TabBar căn giữa
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        labelPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        labelColor: Colors.orange.shade900,
                        unselectedLabelColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.shade200.withOpacity(0.5),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        tabs: const [
                          Tab(text: "Gợi ý"),
                          Tab(text: "Gần tôi"),
                          Tab(text: "Giảm nhiều"),
                          Tab(text: "Mới nhất"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Nội dung chính
      body: Stack(
        children: [
          // Gradient nền + hình tròn trang trí
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFDFCFB), Color(0xFFFFFFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: -40,
            child: _buildCircle(80, Colors.orange.withOpacity(0.1)),
          ),
          Positioned(
            top: 300,
            right: -50,
            child: _buildCircle(100, Colors.orangeAccent.withOpacity(0.1)),
          ),
          Positioned(
            bottom: 80,
            left: 50,
            child: _buildCircle(60, Colors.amber.withOpacity(0.1)),
          ),
          // Nội dung TabView
          Padding(
            padding: const EdgeInsets.only(top: 190), // đẩy nhẹ xuống
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFoodList("Gợi ý"),
                _buildFoodList("Gần tôi"),
                _buildFoodList("Giảm nhiều"),
                _buildFoodList("Mới nhất"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration:
          BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.2),
          blurRadius: 8,
          spreadRadius: 2,
        )
      ]),
    );
  }

  Widget _buildFoodList(String tab) {
    return StreamBuilder<QuerySnapshot>(
      stream: _getQuery(tab),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text("Lỗi tải dữ liệu: ${snapshot.error}",
                  style: const TextStyle(color: Colors.redAccent)));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text("Không có dữ liệu",
                  style: TextStyle(color: Colors.grey)));
        }

        final foods = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final data = foods[index].data() as Map<String, dynamic>;
            return FoodCard(data: data);
          },
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SizedBox(
          height: 350,
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text("Chọn quận",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Divider(),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                      HomeReferences.quanHuyenRef.orderBy('ten').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final docs = snapshot.data!.docs;
                    return ListView.separated(
                      itemCount: docs.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final data = docs[index].data() as Map<String, dynamic>;
                        final ten = HomeReferences.cleanText(
                            data['ten'] ?? docs[index].id);
                        final selected = ten == selectedQuan;
                        return ListTile(
                          title: Text(ten),
                          trailing: selected
                              ? const Icon(Icons.check,
                                  color: Colors.blueAccent)
                              : null,
                          onTap: () {
                            setState(() => selectedQuan = ten);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() => selectedQuan = null);
                  Navigator.pop(context);
                },
                child: const Text("Bỏ lọc",
                    style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Các clipper giữ nguyên
class BigTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SmallTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height - 10, size.width, size.height - 90);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class FoodCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const FoodCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final giamGia = data['giam_gia'] ?? 0;
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 110,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildImage(data['hinh_anh']),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['ten'] ?? 'Tên quán ăn',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' ${data['danh_gia'] ?? 0}'),
                      const SizedBox(width: 6),
                      const Icon(Icons.location_on_outlined,
                          color: Colors.grey, size: 16),
                      Expanded(
                        child: Text(
                          data['quan'] ?? '',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    data['dia_chi'] ?? '',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      if (giamGia is num && giamGia > 0)
                        _buildTag(Icons.local_offer, "Giảm $giamGia%",
                            Colors.redAccent),
                      if (data['freeship'] == true)
                        _buildTag(Icons.local_shipping, "FREESHIP",
                            Colors.green.shade600),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(dynamic path) {
    if (path == null || path.toString().isEmpty) {
      return _buildImageFallback();
    }
    if (path.toString().startsWith('http')) {
      return Image.network(
        path,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildImageFallback(),
      );
    }
    return Image.asset(
      path,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildImageFallback(),
    );
  }

  Widget _buildImageFallback() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey.shade300,
      child: const Icon(Icons.fastfood, color: Colors.grey),
    );
  }

  Widget _buildTag(IconData icon, String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6, top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 2),
          Text(
            text,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

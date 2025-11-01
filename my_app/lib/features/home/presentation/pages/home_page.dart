import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color primaryBlue = Color(0xFFAED2FF);
  static const Color backgroundColor = Color(0xFFF7F9FC);

  final CollectionReference danhMucRef =
      FirebaseFirestore.instance.collection('danh_muc');
  final CollectionReference diaDiemRef =
      FirebaseFirestore.instance.collection('dia_diem_de_xuat');

  int _currentIndex = 2; // Trang Home ở giữa

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _currentIndex,
          children: [
            const Center(child: Text('Calendar Page')),
            const Center(child: Text('Chat Page')),
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildAppBar(),
                  _buildBanner(),
                  _buildCategoriesSection(),
                  _buildSuggestedPlacesSection(),
                ],
              ),
            ),
            const Center(child: Text('Notifications Page')),
            const Center(child: Text('Profile Page')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _currentIndex = 2),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.black,
        elevation: 6,
        shape: const CircleBorder(),
        child: Icon(
          _currentIndex == 2 ? Icons.home : Icons.home_outlined,
          color: Colors.black,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: primaryBlue,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        elevation: 8,
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(
                _currentIndex == 0
                    ? Icons.calendar_today
                    : Icons.calendar_today_outlined,
                color: Colors.white,
                size: 26,
              ),
              onPressed: () => setState(() => _currentIndex = 0),
            ),
            IconButton(
              icon: Icon(
                _currentIndex == 1
                    ? Icons.chat_bubble
                    : Icons.chat_bubble_outline,
                color: Colors.white,
                size: 26,
              ),
              onPressed: () => setState(() => _currentIndex = 1),
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: Icon(
                _currentIndex == 3
                    ? Icons.notifications
                    : Icons.notifications_outlined,
                color: Colors.white,
                size: 26,
              ),
              onPressed: () => setState(() => _currentIndex = 3),
            ),
            IconButton(
              icon: Icon(
                _currentIndex == 4 ? Icons.person : Icons.person_outline,
                color: Colors.white,
                size: 26,
              ),
              onPressed: () => setState(() => _currentIndex = 4),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 AppBar
  Widget _buildAppBar() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45, // chiều cao đồng bộ
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 45, // cùng chiều cao với ô tìm kiếm
            width: 45,
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              FontAwesomeIcons.sliders,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Banner
  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(
            'assets/images/Banner.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  // 🔹 Danh mục
  Widget _buildCategoriesSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: danhMucRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: primaryBlue),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Chưa có danh mục nào."),
          );
        }

        const order = [
          'quan_an',
          'luu_tru',
          'diem_den',
          'khu_vui_choi',
          'phuong_tien',
          'tien_ich'
        ];

        final danhMucDocs = snapshot.data!.docs
            .where((doc) => order.contains(doc.id))
            .toList()
          ..sort((a, b) => order.indexOf(a.id).compareTo(order.indexOf(b.id)));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: danhMucDocs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final data = danhMucDocs[index].data() as Map<String, dynamic>;
              final ten = data['ten'] ?? '';
              final hinhAnh = data['hinh_anh'] ?? '';

              return Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        hinhAnh,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ten,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // 🔹 Địa điểm đề xuất
  Widget _buildSuggestedPlacesSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: diaDiemRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(color: primaryBlue),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Chưa có địa điểm đề xuất."),
          );
        }

        final docs = snapshot.data!.docs;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Text(
                'Địa điểm đề xuất',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(
              height: 220,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                scrollDirection: Axis.horizontal,
                itemCount: docs.length,
                separatorBuilder: (context, index) => const SizedBox(width: 20),
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final ten = data['ten'] ?? '';
                  final diaChi = data['dia_chi'] ?? '';
                  final hinhAnh = data['hinh_anh'] ?? '';
                  final danhGia = data['danh_gia'] ?? '0';

                  return Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16)),
                          child: Image.asset(
                            hinhAnh,
                            width: 160,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ten,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                diaChi,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    danhGia.toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}

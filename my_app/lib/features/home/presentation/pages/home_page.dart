import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                  _buildSearchBar(),
                  _buildBanner(),
                  _buildCategoriesSection(),
                  _buildFeaturedPlacesSection(),
                ],
              ),
            ),
            const Center(child: Text('Notifications Page')),
            const Center(child: Text('Profile Page')),
          ],
        ),
      ),

      // ✅ Nút nổi giữa (màu xanh + icon trắng)
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _currentIndex = 2),
        backgroundColor: primaryBlue,
        foregroundColor: const Color.fromARGB(255, 10, 0, 0),
        elevation: 6,
        shape: const CircleBorder(),
        child: Icon(
          _currentIndex == 2 ? Icons.home : Icons.home_outlined,
          color: Colors.black,
          size: 30,
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ✅ Thanh menu dưới (màu xanh + icon trắng)
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
            const SizedBox(width: 40), // khoảng trống cho nút Home
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

  Widget _buildSearchBar() {
    return Container(
      color: primaryBlue,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
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
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.filter_alt, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25), // Bo góc mềm
        child: AspectRatio(
          aspectRatio: 16 / 9, // Tỷ lệ giống hình bạn gửi
          child: Image.asset(
            'assets/images/Banner.jpg',
            fit: BoxFit.cover, // Ảnh phủ kín mà không méo
          ),
        ),
      ),
    );
  }

  // ✅ Danh mục không có khung trắng, chỉ hiển thị hình ảnh
  Widget _buildCategoriesSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: danhMucRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: primaryBlue),
            ),
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

              return GestureDetector(
                onTap: () {
                  // TODO: Navigate to category details
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50), // hình tròn
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFeaturedPlacesSection() {
    const featuredPlaces = [
      'assets/images/place1.jpg',
      'assets/images/place2.jpg',
      'assets/images/place3.jpg',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Text(
            'Địa điểm nổi bật',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 158,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            scrollDirection: Axis.horizontal,
            itemCount: featuredPlaces.length,
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  featuredPlaces[index],
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

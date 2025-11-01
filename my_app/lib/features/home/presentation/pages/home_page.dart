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
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Khám phá TP. Hồ Chí Minh",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_none, color: Colors.black87),
          ),
        ],
      ),

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

      // ✅ Nút nổi giữa (Home)
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

      // ✅ Thanh menu dưới
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

  // ✅ Banner trên cùng
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

  // ✅ Danh mục (Firestore)
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

        // ✅ Thứ tự đúng như mẫu
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // ✅ Địa điểm đề xuất (Firestore)
  Widget _buildFeaturedPlacesSection() {
    final diaDiemRef =
        FirebaseFirestore.instance.collection('dia_diem_de_xuat');

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
        StreamBuilder<QuerySnapshot>(
          stream: diaDiemRef.snapshots(),
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
                child: Text("Chưa có địa điểm đề xuất nào."),
              );
            }

            final diaDiemDocs = snapshot.data!.docs;

            return SizedBox(
              height: 220,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                scrollDirection: Axis.horizontal,
                itemCount: diaDiemDocs.length,
                separatorBuilder: (context, index) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final data =
                      diaDiemDocs[index].data() as Map<String, dynamic>;
                  final ten = data['ten'] ?? '';
                  final hinhAnh = data['hinh_anh'] ?? '';
                  final diaChi = data['dia_chi'] ?? '';
                  final danhGia = data['danh_gia'] ?? 0.0;

                  return Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.asset(
                            hinhAnh,
                            height: 120,
                            width: double.infinity,
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
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                diaChi,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    danhGia.toString(),
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
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
                },
              ),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

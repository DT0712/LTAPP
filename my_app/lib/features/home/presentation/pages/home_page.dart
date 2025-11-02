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

  // Firestore collections
  final CollectionReference danhMucRef =
      FirebaseFirestore.instance.collection('danh_muc');
  final CollectionReference diaDiemDeXuatRef =
      FirebaseFirestore.instance.collection('dia_diem_de_xuat');
  final CollectionReference placesRef =
      FirebaseFirestore.instance.collection('places');
  final CollectionReference quanHuyenRef =
      FirebaseFirestore.instance.collection('quan_huyen');

  // state
  int _currentIndex = 2;
  String? selectedQuan;
  bool showFilterPanel = false;

  // Làm sạch chuỗi: loại bỏ non-breaking space, khoảng trắng thừa
  String cleanText(String s) {
    return s.replaceAll('\u00A0', ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

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
                  if (showFilterPanel) _buildFilterPanel(),
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
              ),
              onPressed: () => setState(() => _currentIndex = 0),
            ),
            IconButton(
              icon: Icon(
                _currentIndex == 1
                    ? Icons.chat_bubble
                    : Icons.chat_bubble_outline,
                color: Colors.white,
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
              ),
              onPressed: () => setState(() => _currentIndex = 3),
            ),
            IconButton(
              icon: Icon(
                _currentIndex == 4 ? Icons.person : Icons.person_outline,
                color: Colors.white,
              ),
              onPressed: () => setState(() => _currentIndex = 4),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- AppBar ----------------
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
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
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
                        hintText: "Tìm kiếm địa điểm",
                        border: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () {
              setState(() {
                showFilterPanel = !showFilterPanel;
              });
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              height: 48,
              width: 48,
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
          ),
        ],
      ),
    );
  }

  // ---------------- Panel lọc ----------------
  Widget _buildFilterPanel() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Chọn quận để lọc",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              if (selectedQuan != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedQuan = null;
                      showFilterPanel = false;
                    });
                  },
                  child: const Text("Bỏ lọc"),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: StreamBuilder<QuerySnapshot>(
              stream: quanHuyenRef.orderBy('ten').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: docs.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final rawTen =
                        (doc.data() as Map<String, dynamic>)['ten'] as String?;
                    final ten = cleanText(rawTen ?? doc.id);

                    print("QUAN_HUYEN: '$ten' | len: ${ten.length}");

                    final bool isSelected = ten == selectedQuan;

                    return _FilterChipDistrict(
                      label: ten,
                      selected: isSelected,
                      onTap: () {
                        setState(() {
                          selectedQuan = ten;
                          showFilterPanel = false;
                        });
                        print("SELECTED QUAN: '$ten'");
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Banner ----------------
  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
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

  // ---------------- Danh mục ----------------
  Widget _buildCategoriesSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: danhMucRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final docs = snapshot.data!.docs;
        const order = [
          'quan_an',
          'luu_tru',
          'diem_den',
          'khu_vui_choi',
          'phuong_tien',
          'tien_ich'
        ];

        final danhMucDocs = docs.where((d) => order.contains(d.id)).toList()
          ..sort((a, b) => order.indexOf(a.id).compareTo(order.indexOf(b.id)));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: danhMucDocs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 18,
              crossAxisSpacing: 18,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final data =
                  danhMucDocs[index].data() as Map<String, dynamic>? ?? {};
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
                        width: double.infinity,
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

  // ---------------- Địa điểm (ĐÃ SỬA LOG + BỎ ORDERBY) ----------------
  Widget _buildSuggestedPlacesSection() {
    final Query query = (selectedQuan == null)
        ? diaDiemDeXuatRef.orderBy('danh_gia', descending: true)
        : placesRef.where('quan',
            isEqualTo: cleanText(selectedQuan!)); // BỎ orderBy

    if (selectedQuan != null) {
      print("QUERY: where('quan', isEqualTo: '${cleanText(selectedQuan!)}')");
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final docs = snapshot.data!.docs;
        print("KẾT QUẢ: ${docs.length} documents");

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Text(
                selectedQuan == null
                    ? 'Địa điểm đề xuất'
                    : 'Địa điểm ở $selectedQuan',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            if (docs.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text("Không có địa điểm nào."),
                    const SizedBox(height: 8),
                    Text(
                      "Query: ${selectedQuan ?? 'Tất cả'}",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                height: 220,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: docs.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final data =
                        docs[index].data() as Map<String, dynamic>? ?? {};
                    final quanInPlace = data['quan'] as String?;
                    final ten = data['ten'] ?? 'Không tên';

                    // LOG CHI TIẾT MỖI DOCUMENT
                    print("${docs[index].id}: quan='$quanInPlace', ten='$ten'");

                    final diaChi = data['dia_chi'] ?? '';
                    final hinhAnh = data['hinh_anh'] ?? '';
                    final danhGia = data['danh_gia'] ?? '0';

                    return Container(
                      width: 160,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.18),
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
                                top: Radius.circular(14)),
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
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  diaChi,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        size: 16, color: Colors.amber),
                                    const SizedBox(width: 6),
                                    Text(
                                      danhGia.toString(),
                                      style: const TextStyle(
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
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

// ---------------- Custom chip ----------------
class _FilterChipDistrict extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipDistrict({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_FilterChipDistrict> createState() => _FilterChipDistrictState();
}

class _FilterChipDistrictState extends State<_FilterChipDistrict> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.selected;
    final bg = active
        ? Colors.blue.shade50
        : hovering
            ? Colors.grey.shade200
            : Colors.white;
    final textColor = active ? Colors.blue : Colors.black87;

    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? Colors.blue : Colors.grey.shade300,
              width: active ? 1.2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: textColor,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

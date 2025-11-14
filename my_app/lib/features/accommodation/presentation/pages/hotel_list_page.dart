import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../home/data/home_references.dart'; // quan_huyen
import '../../data/hotel_model.dart';
import '../../data/hotel_repository.dart';
import '../widgets/hotel_card.dart';

class HotelListPage extends StatefulWidget {
  const HotelListPage({super.key, this.defaultType = 'Khách sạn'});

  static const routeName = '/accommodation';
  final String defaultType;

  @override
  State<HotelListPage> createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage> {
  final repo = HotelRepository();

  final List<String> _types = const ['Khách sạn', 'Homestay', 'Resort'];
  late String _selectedType;

  /// docId của collection `quan_huyen` (vd: "quan_1")
  String? _selectedDistrictId;

  String? _selectedHotelId;

  String _search = '';
  final _searchCtrl = TextEditingController();

  /// Giữ vị trí thanh chips để không bị nhảy về đầu
  final ScrollController _districtCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedType = widget.defaultType;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _districtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const dividerColor = Color(0xFFB5E100);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===================== HEADER ẢNH NỀN (AppBar phủ khúc trên) =====================
            _HeaderWithImage(
              title: 'LƯU TRÚ',
              selectedType: _selectedType,
              types: _types,
              onBack: () => Navigator.of(context).maybePop(),
              onTypeChanged: (v) => setState(() => _selectedType = v),
              imagePath: 'assets/images/headers/accommodation_header.jpg', // đổi theo ảnh của bạn
            ),

            // ===================== SEARCH =====================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFADFA1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.search),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchCtrl,
                              decoration: const InputDecoration(
                                hintText: 'Tìm kiếm',
                                border: InputBorder.none,
                              ),
                              onChanged: (v) => setState(() => _search = v.trim()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF424242),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ===================== CHIPS QUẬN/HUYỆN =====================
            SizedBox(
              height: 40,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: HomeReferences.quanHuyenRef.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Lỗi quận/huyện: ${snapshot.error}'));
                  }

                  final docs = snapshot.data?.docs ?? const [];
                  if (docs.isEmpty) {
                    return const Center(child: Text('Chưa có quận/huyện'));
                  }

                  final items = docs
                      .map((d) {
                    final data = d.data();
                    return {
                      'id': d.id, // GIÁ TRỊ LỌC
                      'ten': (data['ten'] ?? d.id).toString(), // HIỂN THỊ
                      'thu_tu': data['thu_tu'] ?? 9999,
                    };
                  })
                      .toList()
                    ..sort((a, b) =>
                        (a['thu_tu'] as num).compareTo(b['thu_tu'] as num));

                  return ListView.separated(
                    key: const PageStorageKey('district_chips'), // giữ vị trí khi rebuild
                    controller: _districtCtrl,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final id = items[i]['id'] as String;
                      final label = items[i]['ten'] as String;
                      final selected = id == _selectedDistrictId;

                      return ChoiceChip(
                        label: Text(label),
                        selected: selected,
                        showCheckmark: false, // ✅ xoá icon dấu tích khi selected
                        onSelected: (v) {
                          setState(() {
                            _selectedDistrictId = v ? id : null;
                          });
                        },
                        selectedColor: const Color(0xFFFFE6B3),
                        backgroundColor: const Color(0xFFF2F2F2),
                        labelStyle: TextStyle(
                          color: selected ? Colors.black : Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: selected ? const Color(0xFFB5E100) : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // ===================== DIVIDER =====================
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(height: 3, color: dividerColor),
            ),

            // ===================== DANH SÁCH =====================
            Expanded(
              child: StreamBuilder<List<Hotel>>(
                stream: repo.streamHotels(
                  type: _selectedType,           // "Khách sạn"/"Homestay"/"Resort"
                  district: _selectedDistrictId, // quan_huyen_id (vd: "quan_1")
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  }
                  var data = snapshot.data ?? const <Hotel>[];

                  // Lọc client theo từ khoá
                  if (_search.isNotEmpty) {
                    final kw = _search.toLowerCase();
                    data = data.where((h) {
                      return h.name.toLowerCase().contains(kw) ||
                          h.address.toLowerCase().contains(kw);
                    }).toList();
                  }

                  if (data.isEmpty) {
                    return const Center(child: Text('Không có địa điểm phù hợp.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final h = data[index];
                      final isSelected = _selectedHotelId == h.id;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              setState(() {
                                _selectedHotelId = isSelected ? null : h.id;
                              });
                            },
                            child: HotelCard(
                              hotel: h,
                              onBookPressed: null,
                            ),
                          ),

                          // ================== Nút "Đặt ngay" ANIMATION ==================
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            switchInCurve: Curves.easeOutBack,
                            switchOutCurve: Curves.easeIn,
                            transitionBuilder: (child, anim) {
                              // Fade + Scale + Slide từ phải sang
                              final slide = Tween<Offset>(
                                begin: const Offset(0.08, 0),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));

                              final scale = Tween<double>(begin: 0.92, end: 1.0)
                                  .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));

                              return FadeTransition(
                                opacity: anim,
                                child: SlideTransition(
                                  position: slide,
                                  child: ScaleTransition(scale: scale, child: child),
                                ),
                              );
                            },
                            child: isSelected
                                ? Padding(
                              key: ValueKey('${h.id}_btn'),
                              padding: const EdgeInsets.only(top: 4, bottom: 12),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFCA8A65),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                  ),
                                  onPressed: () {
                                    // TODO: điều hướng đặt phòng/chi tiết cho h.id
                                  },
                                  icon: const Icon(Icons.calendar_month, size: 16),
                                  label: const Text('Đặt ngay'),
                                ),
                              ),
                            )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// HEADER AppBar bằng ảnh nền phủ toàn bộ khúc trên
class _HeaderWithImage extends StatelessWidget {
  const _HeaderWithImage({
    required this.title,
    required this.selectedType,
    required this.types,
    required this.onBack,
    required this.onTypeChanged,
    required this.imagePath,
  });

  final String title;
  final String selectedType;
  final List<String> types;
  final VoidCallback onBack;
  final ValueChanged<String> onTypeChanged;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // chỉnh theo ý
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ẢNH NỀN
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: const Color(0xFFBFD8FF)),
            ),
          ),
          // LỚP GRADIENT
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66000000),
                  Color(0x22000000),
                  Color(0x66000000),
                ],
              ),
            ),
          ),
          // NỘI DUNG APPBAR
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                // Nút Back tròn
                InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: onBack,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, size: 20),
                  ),
                ),
                const SizedBox(width: 10),
                // Tiêu đề
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: 1,
                    shadows: [Shadow(blurRadius: 6, color: Colors.black54)],
                  ),
                ),
                const Spacer(),
                // Dropdown chọn loại
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedType,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: types
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) onTypeChanged(v);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

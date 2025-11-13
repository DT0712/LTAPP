import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  /// GIÁ TRỊ LỌC = docId của collection `quan_huyen` (vd: "quan_1")
  String? _selectedDistrictId;

  String? _selectedHotelId;

  String _search = '';
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedType = widget.defaultType;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const headerColor = Color(0xFFBFD8FF);
    const dividerColor = Color(0xFFB5E100);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'LƯU TRÚ',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedType,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: _types
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _selectedType = v);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===== SEARCH =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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

            // ===== CHIPS QUẬN/HUYỆN từ Firestore =====
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final id = items[i]['id'] as String;
                      final label = items[i]['ten'] as String;
                      final selected = id == _selectedDistrictId;

                      return ChoiceChip(
                        label: Text(label),
                        selected: selected,
                        onSelected: (v) =>
                            setState(() => _selectedDistrictId = v ? id : null),
                        selectedColor: const Color(0xFFFFE6B3),
                        backgroundColor: const Color(0xFFF2F2F2),
                        labelStyle: TextStyle(
                          color: selected ? Colors.black : Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                        shape: StadiumBorder(
                          side: BorderSide(
                            color: selected
                                ? const Color(0xFFB5E100)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // ===== DIVIDER =====
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(height: 3, color: dividerColor),
            ),

            // ===== DANH SÁCH =====
            Expanded(
              child: StreamBuilder<List<Hotel>>(
                stream: repo.streamHotels(
                  type: _selectedType,               // "Khách sạn"/"Homestay"/"Resort"
                  district: _selectedDistrictId,     // quan_huyen_id (vd: "quan_1")
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
                          // Bấm vào card để chọn/huỷ chọn
                          InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              setState(() {
                                _selectedHotelId = isSelected ? null : h.id;
                              });
                            },
                            child: HotelCard(
                              hotel: h,
                              // KHÔNG truyền onBookPressed ở đây để tránh hiện nút sẵn trong card
                              onBookPressed: null,
                            ),
                          ),

                          // Chỉ hiển thị nút "Đặt ngay" khi item đang được chọn
                          if (isSelected)
                            Padding(
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

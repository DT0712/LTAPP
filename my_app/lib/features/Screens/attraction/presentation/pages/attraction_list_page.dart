import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../data/attraction_references.dart';
import '../../data/attraction_model.dart';
import '../widgets/attraction_card.dart';

class AttractionListPage extends StatefulWidget {
  const AttractionListPage({super.key});
  static const routeName = '/attractions';

  @override
  State<AttractionListPage> createState() => _AttractionListPageState();
}

class _AttractionListPageState extends State<AttractionListPage> {
  final _searchCtrl = TextEditingController();
  String _search = '';
  String? _selectedDistrictId;

  final _districtCtrl = ScrollController();
  final _listCtrl = ScrollController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    _districtCtrl.dispose();
    _listCtrl.dispose();
    super.dispose();
  }

  // ========= Helpers =========
  List<String> _imagesOf(dynamic v) {
    if (v is List) return v.map((e) => e.toString()).toList();
    if (v is String && v.isNotEmpty) return [v];
    return const <String>[];
  }

  Attraction _fromSnap(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? const <String, dynamic>{};
    return Attraction(
      id: d.id,
      name: (m['ten'] ?? '').toString(),
      address: (m['dia_chi'] ?? '').toString(),
      images: _imagesOf(m['images']),
      rating: (m['danh_gia'] is num) ? (m['danh_gia'] as num).toDouble() : 0.0,
      districtId: (m['quan_huyen_id'] ?? '').toString(),
      districtName: (m['quan_huyen_ten'] ?? '').toString(),
      priceFrom: (m['priceFrom'] is num)
          ? (m['priceFrom'] as num)
          : (double.tryParse((m['priceFrom'] ?? '').toString()) ?? 0),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _attractionsStream() {
    Query<Map<String, dynamic>> q = AttractionReferences.attractionsRef;
    if (_selectedDistrictId != null && _selectedDistrictId!.isNotEmpty) {
      q = q.where('quan_huyen_id', isEqualTo: _selectedDistrictId);
    }
    return q.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    const dividerColor = Color(0xFFB5E100);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            const _HeaderWithImage(
              title: 'KHU VUI CHƠI',
              imagePath: 'assets/images/headers/attractions_header.jpg',
            ),

            // ===== SEARCH =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
                          hintText: 'Tìm kiếm điểm vui chơi',
                          border: InputBorder.none,
                        ),
                        onChanged: (v) => setState(() => _search = v.trim()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ===== CHIPS QUẬN/HUYỆN =====
            SizedBox(
              height: 40,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: AttractionReferences.quanHuyenRef.snapshots(),
                builder: (context, qhSnap) {
                  if (qhSnap.hasData && qhSnap.data!.docs.isNotEmpty) {
                    final items = qhSnap.data!.docs
                        .map((d) {
                      final m = d.data();
                      return {
                        'id': d.id,
                        'ten': (m['ten'] ?? d.id).toString(),
                        'thu_tu': (m['thu_tu'] ?? 9999) as num,
                      };
                    })
                        .toList()
                      ..sort((a, b) =>
                          (a['thu_tu'] as num).compareTo(b['thu_tu'] as num));
                    return _DistrictChips(
                      items: items,
                      controller: _districtCtrl,
                      selectedId: _selectedDistrictId,
                      onSelect: (id) => setState(() => _selectedDistrictId = id),
                    );
                  }

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: AttractionReferences.attractionsRef.snapshots(),
                    builder: (context, atSnap) {
                      if (atSnap.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      if (atSnap.hasError) {
                        return Center(child: Text('Lỗi quận/huyện: ${atSnap.error}'));
                      }
                      final docs = atSnap.data?.docs ?? const [];
                      final Map<String, String> map = {};
                      for (final d in docs) {
                        final m = d.data();
                        final id = (m['quan_huyen_id'] ?? '').toString();
                        final ten = (m['quan_huyen_ten'] ?? id).toString();
                        if (id.isNotEmpty) map[id] = ten;
                      }
                      if (map.isEmpty) {
                        return const Center(child: Text('Chưa có quận/huyện'));
                      }
                      final items = map.entries
                          .map((e) => {'id': e.key, 'ten': e.value, 'thu_tu': 9999})
                          .toList()
                        ..sort((a, b) =>
                            (a['ten'] as String).compareTo(b['ten'] as String));
                      return _DistrictChips(
                        items: items,
                        controller: _districtCtrl,
                        selectedId: _selectedDistrictId,
                        onSelect: (id) => setState(() => _selectedDistrictId = id),
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

            // ===== LIST =====
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _attractionsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  }

                  var docs = snapshot.data?.docs ?? const [];

                  // Lọc theo từ khoá
                  if (_search.isNotEmpty) {
                    final kw = _search.toLowerCase();
                    docs = docs.where((d) {
                      final m = d.data();
                      final ten = (m['ten'] ?? '').toString().toLowerCase();
                      final dc = (m['dia_chi'] ?? '').toString().toLowerCase();
                      return ten.contains(kw) || dc.contains(kw);
                    }).toList();
                  }

                  if (docs.isEmpty) {
                    return const Center(child: Text('Không có điểm vui chơi phù hợp.'));
                  }

                  return ListView.separated(
                    key: const PageStorageKey('attraction_list'),
                    controller: _listCtrl,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    itemCount: docs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final a = _fromSnap(docs[index]);
                      return AttractionCard(
                        attraction: a,
                        onTap: () {
                          // TODO: mở chi tiết
                        },
                        onBook: () {
                          // TODO: điều hướng đặt vé với a.id
                        },
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

// ================== Header ảnh phủ ==================
class _HeaderWithImage extends StatelessWidget {
  const _HeaderWithImage({
    required this.title,
    required this.imagePath,
  });

  final String title;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFFBFD8FF)),
            ),
          ),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      // withOpacity() deprecated → dùng withValues()
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, size: 20),
                  ),
                ),
                const SizedBox(width: 10),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DistrictChips extends StatelessWidget {
  const _DistrictChips({
    required this.items,
    required this.selectedId,
    required this.onSelect,
    this.controller,
  });

  final List<Map<String, Object>> items;
  final String? selectedId;
  final ValueChanged<String?> onSelect;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      key: const PageStorageKey('district_chips_attractions'),
      controller: controller,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final id = items[i]['id'] as String;
        final ten = items[i]['ten'] as String;
        final selected = id == selectedId;

        return ChoiceChip(
          label: Text(ten),
          selected: selected,
          showCheckmark: false,
          onSelected: (v) => onSelect(v ? id : null),
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
  }
}

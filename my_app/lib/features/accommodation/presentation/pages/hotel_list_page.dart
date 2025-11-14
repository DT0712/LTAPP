import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../home/data/home_references.dart'; // quan_huyen
import '../../data/hotel_model.dart';
import '../../data/hotel_repository.dart';
import '../widgets/hotel_card.dart';
// Skeletons: bạn vẫn có SkeletonHotelCard & SkeletonChipRow
import '../../../home/presentation/widgets/skeletons.dart';

class HotelListPage extends StatefulWidget {
  const HotelListPage({super.key, this.defaultType = 'Khách sạn'});

  static const routeName = '/accommodation';
  final String defaultType;

  @override
  State<HotelListPage> createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage>
    with SingleTickerProviderStateMixin {
  final repo = HotelRepository();

  // ======= STATE CƠ BẢN =======
  final List<String> _types = const ['Khách sạn', 'Homestay', 'Resort'];
  late String _selectedType;

  String? _selectedDistrictId; // lọc quận (docId)
  String? _selectedHotelId;    // item đang chọn để hiện nút “Đặt ngay”

  final _searchCtrl = TextEditingController();
  String _search = '';

  // Giữ vị trí list chips + list khách sạn
  final ScrollController _districtCtrl = ScrollController();
  final ScrollController _hotelListCtrl = ScrollController();

  // ======= BỘ LỌC =======
  static const double _kPriceMin = 0;
  static const double _kPriceMax = 10000000; // 10 triệu
  RangeValues _priceRange = const RangeValues(_kPriceMin, _kPriceMax);
  double _minRating = 0; // 0..5

  // ======= PAGE ENTER ANIMATION =======
  late final AnimationController _enterCtl;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  // ======= Skeleton giữ tối thiểu (toàn trang) =======
  static const Duration _minSkeleton = Duration(milliseconds: 1200);

  bool _chipsTimerDone = false;
  bool _chipsDataArrived = false;

  bool _listTimerDone = false;
  bool _listDataArrived = false;

  bool get _showChipSkeleton => !(_chipsTimerDone && _chipsDataArrived);
  bool get _showListSkeleton => !(_listTimerDone && _listDataArrived);
  bool get _showPageSkeleton => _showChipSkeleton || _showListSkeleton;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.defaultType;

    _enterCtl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _fadeIn = CurvedAnimation(parent: _enterCtl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(begin: const Offset(0, .02), end: Offset.zero)
        .animate(CurvedAnimation(parent: _enterCtl, curve: Curves.easeOutCubic));
    _enterCtl.forward();

    // Đếm thời gian tối thiểu cho CHIPS + LIST (độc lập)
    Future.delayed(_minSkeleton, () {
      if (!mounted) return;
      setState(() => _chipsTimerDone = true);
    });
    Future.delayed(_minSkeleton, () {
      if (!mounted) return;
      setState(() => _listTimerDone = true);
    });
  }

  @override
  void dispose() {
    _enterCtl.dispose();
    _searchCtrl.dispose();
    _districtCtrl.dispose();
    _hotelListCtrl.dispose();
    super.dispose();
  }

  // ======= FORMAT VNĐ =======
  String _formatVND(num? value) {
    if (value == null) return '0 VND';
    final s = value.toStringAsFixed(0);
    final re = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return '${s.replaceAllMapped(re, (m) => '.')} VND';
  }

  // ======= BOTTOM SHEET BỘ LỌC =======
  Future<void> _openFilterSheet() async {
    var tempRating = _minRating;
    var tempRange = _priceRange;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Bộ lọc',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 18),

                  // Sao tối thiểu
                  Row(
                    children: [
                      const Text('Số sao tối thiểu',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text('${tempRating.toStringAsFixed(1)} ★'),
                    ],
                  ),
                  Slider(
                    value: tempRating,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    label: '${tempRating.toStringAsFixed(1)} ★',
                    onChanged: (v) => setModalState(() => tempRating = v),
                  ),
                  const SizedBox(height: 12),

                  // Khoảng giá
                  Row(
                    children: [
                      const Text('Khoảng giá (VND/đêm)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text(
                        '${_formatVND(tempRange.start.round())} - ${_formatVND(tempRange.end.round())}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: tempRange,
                    min: _kPriceMin,
                    max: _kPriceMax,
                    divisions: 20,
                    labels: RangeLabels(
                      _formatVND(tempRange.start.round()),
                      _formatVND(tempRange.end.round()),
                    ),
                    onChanged: (v) => setModalState(() => tempRange = v),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setModalState(() {
                            tempRating = 0;
                            tempRange = const RangeValues(_kPriceMin, _kPriceMax);
                          }),
                          child: const Text('Đặt lại'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6CA8FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _minRating = tempRating;
                              _priceRange = tempRange;
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text('Áp dụng',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const dividerColor = Color(0xFFB5E100);

    // ======= NỘI DUNG CHÍNH =======
    final content = SafeArea(
      child: FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideUp,
          child: Column(
            children: [
              // ============== HEADER ẢNH PHỦ ==============
              _HeaderWithImage(
                title: 'LƯU TRÚ',
                selectedType: _selectedType,
                types: _types,
                onBack: () => Navigator.of(context).maybePop(),
                onTypeChanged: (v) => setState(() => _selectedType = v),
                imagePath: 'assets/images/headers/accommodation_header.jpg',
              ),

              // ============== SEARCH + FILTER BTN ==============
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
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: _openFilterSheet,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF424242),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.tune, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ============== CHIPS QUẬN/HUYỆN ==============
              SizedBox(
                height: 40,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: HomeReferences.quanHuyenRef.snapshots(),
                  builder: (context, snapshot) {
                    // đánh dấu data quận đã về lần đầu
                    if (snapshot.hasData && !_chipsDataArrived) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) setState(() => _chipsDataArrived = true);
                      });
                    }

                    if (_showChipSkeleton) {
                      return const SkeletonChipRow();
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
                        'id': d.id,
                        'ten': (data['ten'] ?? d.id).toString(),
                        'thu_tu': data['thu_tu'] ?? 9999,
                      };
                    })
                        .toList()
                      ..sort((a, b) =>
                          (a['thu_tu'] as num).compareTo(b['thu_tu'] as num));

                    return ListView.separated(
                      key: const PageStorageKey('district_chips'),
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
                          showCheckmark: false,
                          onSelected: (v) => setState(
                                  () => _selectedDistrictId = v ? id : null),
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

              // ============== DIVIDER ==============
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(height: 3, color: dividerColor),
              ),

              // ============== DANH SÁCH ==============
              Expanded(
                child: StreamBuilder<List<Hotel>>(
                  stream: repo.streamHotels(
                    type: _selectedType,
                    district: _selectedDistrictId,
                  ),
                  builder: (context, snapshot) {
                    // đánh dấu data list đã về lần đầu
                    if (snapshot.hasData && !_listDataArrived) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) setState(() => _listDataArrived = true);
                      });
                    }

                    if (_showListSkeleton) {
                      return ListView.builder(
                        key: const PageStorageKey('hotel_list_loading'),
                        controller: _hotelListCtrl,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        itemCount: 6,
                        itemBuilder: (_, __) => const SkeletonHotelCard(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Lỗi: ${snapshot.error}'));
                    }

                    var data = snapshot.data ?? const <Hotel>[];

                    // Lọc theo từ khoá
                    if (_search.isNotEmpty) {
                      final kw = _search.toLowerCase();
                      data = data
                          .where((h) =>
                      h.name.toLowerCase().contains(kw) ||
                          h.address.toLowerCase().contains(kw))
                          .toList();
                    }
                    // Lọc theo sao tối thiểu
                    data = data
                        .where((h) => (h.rating ?? 0).toDouble() >= _minRating)
                        .toList();
                    // Lọc theo khoảng giá
                    data = data
                        .where((h) {
                      final num? raw = h.priceFrom;
                      final p = raw == null
                          ? 0.0
                          : (raw is num
                          ? raw.toDouble()
                          : double.tryParse(raw.toString()) ?? 0.0);
                      return p >= _priceRange.start && p <= _priceRange.end;
                    })
                        .toList();

                    if (data.isEmpty) {
                      return const Center(child: Text('Không có địa điểm phù hợp.'));
                    }

                    return ListView.separated(
                      key: const PageStorageKey('hotel_list'), // giữ scroll
                      controller: _hotelListCtrl,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      itemCount: data.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 4),
                      itemBuilder: (context, index) {
                        final h = data[index];
                        final isSelected = _selectedHotelId == h.id;

                        return KeyedSubtree(
                          key: ValueKey(h.id),
                          child: HotelCard(
                            hotel: h,
                            selected: isSelected,
                            onTap: () {
                              setState(() =>
                              _selectedHotelId = isSelected ? null : h.id);
                            },
                            onBookPressed: () {
                              // TODO: điều hướng sang màn đặt phòng/chi tiết với h.id
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // ======= SKELETON OVERLAY (PHỦ TOÀN TRANG) =======
    final overlay = IgnorePointer(
      ignoring: !_showPageSkeleton,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        child: _showPageSkeleton
            ? Container(
          key: const ValueKey('page_skeleton'),
          color: Colors.white, // nền trắng như trang
          child: Column(
            children: [
              // Header skeleton
              _SkeletonHeader(height: 150),
              const SizedBox(height: 12),

              // Search skeleton
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // ô tìm kiếm
                    Expanded(
                      child: _SkeletonBox(height: 44, borderRadius: 14),
                    ),
                    const SizedBox(width: 8),
                    // nút filter
                    _SkeletonBox(width: 44, height: 44, borderRadius: 12),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Chip row skeleton
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SkeletonChipRow(),
              ),

              // Divider
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: _SkeletonBox(height: 3, borderRadius: 2),
              ),

              // Danh sách skeleton
              Expanded(
                child: ListView.builder(
                  key: const PageStorageKey('page_skeleton_list'),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  itemCount: 6,
                  itemBuilder: (_, __) => const SkeletonHotelCard(),
                ),
              ),
            ],
          ),
        )
            : const SizedBox.shrink(),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          content,     // nội dung thật
          overlay,     // skeleton phủ toàn trang khi cần
        ],
      ),
    );
  }
}

// ======================== HEADER ẢNH PHỦ ========================
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

/// ====== Các skeleton block đơn giản dùng cho overlay header/search/divider ======
class _SkeletonHeader extends StatelessWidget {
  const _SkeletonHeader({this.height = 150});
  final double height;

  @override
  Widget build(BuildContext context) {
    return _SkeletonBox(height: height);
  }
}

class _SkeletonBox extends StatefulWidget {
  const _SkeletonBox({
    this.width,
    this.height = 16,
    this.borderRadius = 12,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;
  late final Animation<double> _shift;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600), // chạy chậm để dễ thấy
    )..repeat();
    _shift = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _ctl, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.width ?? MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: AnimatedBuilder(
        animation: _shift,
        builder: (_, __) {
          return Container(
            width: w,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(_shift.value, 0),
                end: Alignment(_shift.value - 1, 0),
                colors: const [
                  Color(0xFFEDEDED),
                  Color(0xFFDADADA),
                  Color(0xFFEDEDED),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../home/data/home_references.dart';
import '../../data/destination_model.dart';
import '../../data/destination_repository.dart';
import '../widgets/destination_card.dart';
import '../widgets/page_header_with_filters.dart';
import '../../../../home/presentation/widgets/skeletons.dart';

import '../widgets/destination_detail_dialog.dart';

class DestinationListPage extends StatefulWidget {
  const DestinationListPage({super.key});

  static const routeName = '/destination';

  @override
  State<DestinationListPage> createState() => _DestinationListPageState();
}

class _DestinationListPageState extends State<DestinationListPage>
    with SingleTickerProviderStateMixin {
  final repo = DestinationRepository();

  // ======= STATE CƠ BẢN =======
  String? _selectedDistrictId;
  String? _selectedDestinationId;

  final _searchCtrl = TextEditingController();
  String _search = '';

  final ScrollController _districtCtrl = ScrollController();
  final ScrollController _destinationListCtrl = ScrollController();
  double _minRating = 0;
  late final AnimationController _enterCtl;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;
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
    _enterCtl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _fadeIn = CurvedAnimation(parent: _enterCtl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(begin: const Offset(0, .02), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _enterCtl, curve: Curves.easeOutCubic));
    _enterCtl.forward();
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
    _destinationListCtrl.dispose();
    super.dispose();
  }

  Future<void> _openFilterSheet() async {
    var tempRating = _minRating;
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
                          borderRadius: BorderRadius.circular(999))),
                  const SizedBox(height: 14),
                  const Text('Bộ lọc',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Text('Số sao tối thiểu',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600)),
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
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setModalState(() {
                            tempRating = 0;
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
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            setState(() {
                              _minRating = tempRating;
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
    // Phần districtChips
    final districtChips = SizedBox(
      height: 40,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: HomeReferences.quanHuyenRef.snapshots(),
        builder: (context, snapshot) {
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
          final items = docs.map((d) {
            final data = d.data();
            return {
              'id': d.id,
              'ten': (data['ten'] ?? d.id).toString(),
              'thu_tu': data['thu_tu'] ?? 9999
            };
          }).toList()
            ..sort(
                (a, b) => (a['thu_tu'] as num).compareTo(b['thu_tu'] as num));

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
                onSelected: (v) =>
                    setState(() => _selectedDistrictId = v ? id : null),
                selectedColor: const Color.fromARGB(255, 132, 195, 255),
                backgroundColor: const Color(0xFFF2F2F2),
                labelStyle: TextStyle(
                    color: selected ? Colors.black : Colors.grey[800],
                    fontWeight: FontWeight.w600),
                shape: StadiumBorder(
                    side: BorderSide(
                        color: selected
                            ? const Color(0xFFB5E100)
                            : Colors.transparent,
                        width: 1.5)),
              );
            },
          );
        },
      ),
    );

    final content = FadeTransition(
      opacity: _fadeIn,
      child: SlideTransition(
        position: _slideUp,
        child: Column(
          children: [
            // Header và Search
            PageHeaderWithFilters(
              title: 'ĐIỂM ĐẾN',
              imagePath: 'assets/images/headers/destination_header.jpg',
              onBack: () => Navigator.of(context).maybePop(),
              filterWidget: const SizedBox.shrink(),
              headerHeight: 200,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 132, 195, 255),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2))
                          ]),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.black),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchCtrl,
                              decoration: const InputDecoration(
                                  hintText: 'Tìm kiếm điểm đến',
                                  border: InputBorder.none),
                              onChanged: (v) =>
                                  setState(() => _search = v.trim()),
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
                          borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.tune, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: districtChips,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(height: 3, color: dividerColor),
            ),

            // ============== DANH SÁCH ==============
            Expanded(
              child: StreamBuilder<List<DestinationModel>>(
                stream: repo.streamDestinations(
                  district: _selectedDistrictId,
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData && !_listDataArrived) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _listDataArrived = true);
                    });
                  }
                  if (_showListSkeleton) {
                    return ListView.builder(
                      key: const PageStorageKey('destination_list_loading'),
                      controller: _destinationListCtrl,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      itemCount: 6,
                      itemBuilder: (_, __) => const SkeletonDestinationCard(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  }
                  var data = snapshot.data ?? const <DestinationModel>[];
                  if (_search.isNotEmpty) {
                    final kw = _search.toLowerCase();
                    data = data
                        .where((h) =>
                            h.ten.toLowerCase().contains(kw) ||
                            h.diaChiBo.toLowerCase().contains(kw))
                        .toList();
                  }
                  data = data
                      .where((h) => (h.danhGia).toDouble() >= _minRating)
                      .toList();
                  if (data.isEmpty) {
                    return const Center(
                        child: Text('Không có địa điểm phù hợp.'));
                  }

                  return ListView.builder(
                    key: const PageStorageKey('destination_list'),
                    controller: _destinationListCtrl,
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final h = data[index];
                      final isSelected = _selectedDestinationId == h.id;

                      return KeyedSubtree(
                        key: ValueKey(h.id),
                        child: DestinationCard(
                          destination: h,
                          selected: isSelected,
                          onTap: () {
                            setState(() => _selectedDestinationId =
                                isSelected ? null : h.id);
                          },
                          //
                          //Widget Dialog
                          onDetailPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) =>
                                  DestinationDetailDialog(destination: h),
                            );
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
    );

    // Overlay Skeleton và Scaffold
    final overlay = IgnorePointer(
      ignoring: !_showPageSkeleton,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        child: _showPageSkeleton
            ? Container(
                key: const ValueKey('page_skeleton'),
                color: Colors.white,
                child: Column(
                  children: [
                    _SkeletonBox(
                        height: 140 + MediaQuery.of(context).padding.top,
                        borderRadius: 0),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                              child:
                                  _SkeletonBox(height: 44, borderRadius: 14)),
                          const SizedBox(width: 8),
                          _SkeletonBox(width: 44, height: 44, borderRadius: 12),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SkeletonChipRow()),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: _SkeletonBox(height: 3, borderRadius: 2)),
                    Expanded(
                      child: ListView.builder(
                        key: const PageStorageKey('page_skeleton_list'),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        itemCount: 6,
                        itemBuilder: (_, __) => const SkeletonDestinationCard(),
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
          content,
          overlay,
        ],
      ),
    );
  }
}

// class _SkeletonBox
class _SkeletonBox extends StatefulWidget {
  const _SkeletonBox(
      {super.key, this.width, this.height = 16, this.borderRadius = 12});
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
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat();
    _shift = Tween<double>(begin: -1, end: 2)
        .animate(CurvedAnimation(parent: _ctl, curve: Curves.linear));
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
                  Color(0xFFEDEDED)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

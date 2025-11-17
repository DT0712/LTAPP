// lib/features/schedule/presentation/pages/schedule_page.dart

import 'package:flutter/material.dart';
import '../../data/schedule_repository.dart';
import '../../data/schedule_model.dart';

import '../widgets/schedule_header.dart';
import '../widgets/schedule_item_card.dart';

import '../widgets/schedule_detail_dialog.dart';

import '../../../home/presentation/widgets/skeletons.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  static const routeName = '/schedule';

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final ScheduleRepository _repo = ScheduleRepository();

  String? _selectedDuration;
  String? _selectedScheduleId;
  String _search = '';
  final _searchCtrl = TextEditingController();

  Future<List<String>>? _durationsFuture;

  @override
  void initState() {
    super.initState();
    _durationsFuture = _repo.getUniqueDurations();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ScheduleHeader(),
      backgroundColor: Colors.orange,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF7F9FC),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            FutureBuilder<List<String>>(
              future: _durationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //
                  return Container(
                    height: 60,
                    padding: const EdgeInsets.only(top: 16, bottom: 4),
                    child: const SkeletonChipRow(),
                  );
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  //
                  return const SizedBox.shrink();
                }

                final durations = snapshot.data!;
                return _buildDurationChips(durations);
              },
            ),
            Expanded(
              child: StreamBuilder<List<ScheduleItem>>(
                stream: _repo.streamSchedules(duration: _selectedDuration),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  }

                  final items = snapshot.data ?? [];
                  if (items.isEmpty) {
                    return _buildEmptyState(
                        message: 'Không có lịch trình phù hợp.');
                  }

                  final filteredItems = _search.isEmpty
                      ? items
                      : items.where((item) {
                          final name = item.name.toLowerCase();
                          final desc = item.describetion.toLowerCase();
                          final query = _search.toLowerCase();
                          return name.contains(query) || desc.contains(query);
                        }).toList();

                  if (filteredItems.isEmpty) {
                    return _buildEmptyState(message: 'Không tìm thấy kết quả.');
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final isSelected = _selectedScheduleId == item.id;

                      return ScheduleItemCard(
                        item: item,
                        selected: isSelected,
                        onTap: () {
                          setState(() => _selectedScheduleId =
                              isSelected ? null : item.id);
                        },

                        // ===== ĐÃ SỬA =====
                        onDetailPressed: () {
                          // print('View details for ${item.id}');
                          // Thay thế 'print' bằng 'showDialog'
                          showDialog(
                            context: context,
                            barrierDismissible:
                                true, // Cho phép đóng khi nhấn bên ngoài
                            builder: (BuildContext dialogContext) {
                              // Trả về widget dialog mới
                              return ScheduleDetailDialog(item: item);
                            },
                          );
                        },
                        // ===== KẾT THÚC SỬA =====
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

  // (Hàm _buildDurationChips giữ nguyên)
  Widget _buildDurationChips(List<String> durations) {
    return Container(
      height: 60, //
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: durations.length,
        itemBuilder: (_, i) {
          final duration = durations[i];
          final isSelected =
              (_selectedDuration == null && duration == 'Tất cả') ||
                  _selectedDuration == duration;

          return ChoiceChip(
            label: Text(duration),
            selected: isSelected,
            showCheckmark: false,
            onSelected: (v) {
              setState(() =>
                  _selectedDuration = (duration == 'Tất cả' ? null : duration));
            },
            selectedColor: Colors.orange.shade100,
            backgroundColor: Colors.white,
            labelStyle: TextStyle(
                color: isSelected ? Colors.orange.shade900 : Colors.grey[800],
                fontWeight: FontWeight.w600),
            shape: StadiumBorder(
                side: BorderSide(
                    color: isSelected ? Colors.orange : Colors.grey[300]!,
                    width: 1.5)),
          );
        },
      ),
    );
  }

  // (Hàm _buildEmptyState giữ nguyên)
  Widget _buildEmptyState({String message = 'Chưa có lịch trình nào.'}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.calendar_today, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 18)),
        ],
      ),
    );
  }
}

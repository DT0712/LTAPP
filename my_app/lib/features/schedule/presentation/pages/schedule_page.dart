import 'package:flutter/material.dart';
import '../../data/schedule_repository.dart';
import '../../data/schedule_model.dart';
import '../widgets/schedule_filters_widget.dart';
import '../widgets/category_carousel_widget.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  static const routeName = '/schedule';

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final ScheduleRepository _repo = ScheduleRepository();
  String? _selectedDistrict;
  String? _selectedDuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: const Color(0xFFF7F9FC),
      body: StreamBuilder<List<ScheduleItem>>(
        stream: _repo.streamSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }

          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return _buildEmptyState(); // Giữ lại hàm này vì nó đơn giản
          }

          // Lấy các bộ lọc duy nhất từ dữ liệu
          final districts = <String>{'Tất cả'};
          final durations = <String>{'Tất cả'};
          for (final item in items) {
            if (item.district.isNotEmpty) {
              districts.add(item.district);
            }
            if (item.duration != null && item.duration!.isNotEmpty) {
              durations.add(item.duration!);
            }
          }

          // Lọc danh sách dựa trên các bộ lọc đã chọn
          final filteredItems = items.where((item) {
            final matchesDistrict = _selectedDistrict == null ||
                _selectedDistrict == 'Tất cả' ||
                item.district == _selectedDistrict;
            final matchesDuration = _selectedDuration == null ||
                _selectedDuration == 'Tất cả' ||
                item.duration == _selectedDuration;
            return matchesDistrict && matchesDuration;
          }).toList();

          // Nhóm theo danh mục
          final Map<String, List<ScheduleItem>> grouped = {};
          for (final it in filteredItems) {
            final cat = it.category ?? 'Không xác định';
            grouped.putIfAbsent(cat, () => []).add(it);
          }

          final sortedEntries = grouped.entries.toList();

          // ListView chính
          return ListView.custom(
            padding: const EdgeInsets.all(0),
            childrenDelegate: SliverChildBuilderDelegate(
              (context, index) {
                // Mục 0: Khu vực bộ lọc
                if (index == 0) {
                  return ScheduleFiltersWidget(
                    districts: districts.toList(),
                    durations: durations.toList(),
                    selectedDistrict: _selectedDistrict,
                    selectedDuration: _selectedDuration,
                    onDistrictSelected: (val) =>
                        setState(() => _selectedDistrict = val),
                    onDurationSelected: (val) =>
                        setState(() => _selectedDuration = val),
                    onDistrictReset: () =>
                        setState(() => _selectedDistrict = null),
                    onDurationReset: () =>
                        setState(() => _selectedDuration = null),
                  );
                }

                // Các mục còn lại: Carousel danh mục
                final categoryIndex = index - 1;
                if (categoryIndex < sortedEntries.length) {
                  final entry = sortedEntries[categoryIndex];

                  // Sử dụng widget CategoryCarouselWidget mới
                  return CategoryCarouselWidget(
                    category: entry.key,
                    items: entry.value,
                  );
                }

                return const SizedBox.shrink();
              },
              childCount: sortedEntries.length + 1,
            ),
          );
        },
      ),
    );
  }

  /// AppBar (Giữ lại đây vì nó là một phần của cấu trúc trang)
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.orange,
      elevation: 0,
      title: const Text(
        'iTour',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No schedules yet',
              style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8),
          Text('Create your first schedule',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

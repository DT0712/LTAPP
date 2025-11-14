import 'package:flutter/material.dart';
import '../../data/schedule_repository.dart';
import '../../data/schedule_model.dart';
import '../widgets/schedule_card_widget.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  static const routeName = '/schedule';

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final ScheduleRepository _repo = ScheduleRepository();
  final Map<String, bool> _selected = {};
  String? _selectedDistrict;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            return const Center(child: Text('Chưa có lịch trình'));
          }

          // Get unique districts
          final districts = <String>{'Tất cả'};
          for (final item in items) {
            if (item.district != null && item.district!.isNotEmpty) {
              districts.add(item.district!);
            }
          }

          // Filter items by selected district
          final filteredItems = _selectedDistrict == null ||
                  _selectedDistrict == 'Tất cả'
              ? items
              : items.where((i) => i.district == _selectedDistrict).toList();

          // Group by category
          final Map<String, List<ScheduleItem>> grouped = {};
          for (final it in filteredItems) {
            final cat = it.category ?? 'Không xác định';
            grouped.putIfAbsent(cat, () => []).add(it);
          }

          return CustomScrollView(
            slivers: [
              // Banner
              SliverAppBar(
                expandedHeight: 160,
                floating: false,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFA500), Color(0xFFFFD700)],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 40,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'TRAVEL HCM',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Lịch trình du lịch',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: -30,
                          right: -20,
                          child: Opacity(
                            opacity: 0.1,
                            child: Icon(
                              Icons.location_on,
                              size: 200,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Location filter section
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Địa điểm (Quận)',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _selectedDistrict = null),
                            child: const Text(
                              'Tổ lộc',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4A90E2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: districts.map((district) {
                            final isSelected = _selectedDistrict == district ||
                                (_selectedDistrict == null &&
                                    district == 'Tất cả');
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: GestureDetector(
                                onTap: () => setState(
                                    () => _selectedDistrict = district),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF4A90E2)
                                        : Colors.white,
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFF4A90E2)
                                          : Colors.grey[300]!,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    district,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Schedule items by category
              ...grouped.entries.map((entry) {
                final category = entry.key;
                final categoryItems = entry.value;
                return SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                        child: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      ...categoryItems.map((item) {
                        return ScheduleCardWidget(
                          item: item,
                          value: _selected[item.id] ?? false,
                          onChanged: (v) =>
                              setState(() => _selected[item.id] = v),
                        );
                      }),
                    ],
                  ),
                );
              }),
              // Bottom padding
              const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final selected = _selected.entries
              .where((e) => e.value)
              .map((e) => e.key)
              .toList();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                selected.isEmpty
                    ? 'Chưa chọn mục nào'
                    : 'Đã chọn ${selected.length} mục',
              ),
            ),
          );
        },
        icon: const Icon(Icons.check),
        label: const Text('Xác nhận'),
        backgroundColor: const Color(0xFF4A90E2),
      ),
    );
  }
}

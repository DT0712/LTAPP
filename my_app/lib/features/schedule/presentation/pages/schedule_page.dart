import 'package:flutter/material.dart';
import '../../data/schedule_repository.dart';
import '../../data/schedule_model.dart';
import '../widgets/schedule_item_widget.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);
  static const routeName = '/schedule';

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final ScheduleRepository _repo = ScheduleRepository();
  final Map<String, bool> _selected = {}; // local selection state by item id

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lịch trình'),
      ),
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

          // Group by day for a simple day-separated layout
          final Map<String, List<ScheduleItem>> grouped = {};
          for (final it in items) {
            grouped.putIfAbsent(it.day, () => []).add(it);
          }

          final days = grouped.keys.toList()..sort();

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: days.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final day = days[index];
              final list = grouped[day]!;
              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(day, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      ...list.map((it) => ScheduleItemWidget(
                            item: it,
                            value: _selected[it.id] ?? false,
                            onChanged: (v) =>
                                setState(() => _selected[it.id] = v),
                          )),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // For now show selected items summary; optional: persist selections
          final selected = _selected.entries
              .where((e) => e.value)
              .map((e) => e.key)
              .toList();
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Đã chọn'),
              content: Text(selected.isEmpty
                  ? 'Chưa chọn mục nào'
                  : 'Mục đã chọn: ${selected.join(', ')}'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Đóng')),
              ],
            ),
          );
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}

// lib/features/home/presentation/widgets/filter_panel.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/home_references.dart';

class FilterPanel extends StatelessWidget {
  final String? selectedQuan;
  final Function(String) onQuanSelected;
  final VoidCallback onClear;

  const FilterPanel(
      {super.key,
      required this.selectedQuan,
      required this.onQuanSelected,
      required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                  child: Text("Chọn quận để lọc",
                      style: TextStyle(fontWeight: FontWeight.w600))),
              if (selectedQuan != null)
                TextButton(onPressed: onClear, child: const Text("Bỏ lọc")),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: StreamBuilder<QuerySnapshot>(
              stream: HomeReferences.quanHuyenRef.orderBy('ten').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final rawTen =
                        (docs[index].data() as Map)['ten'] as String?;
                    final ten =
                        HomeReferences.cleanText(rawTen ?? docs[index].id);
                    final isSelected = ten == selectedQuan;

                    return _FilterChip(
                        label: ten,
                        selected: isSelected,
                        onTap: () => onQuanSelected(ten));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.selected;
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
                width: active ? 1.2 : 1),
          ),
          child: Center(
            child: Text(widget.label,
                style: TextStyle(
                    color: textColor,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
          ),
        ),
      ),
    );
  }
}

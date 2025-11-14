import 'package:flutter/material.dart';

class ScheduleFiltersWidget extends StatelessWidget {
  final List<String> districts;
  final List<String> durations;
  final String? selectedDistrict;
  final String? selectedDuration;
  final ValueChanged<String> onDistrictSelected;
  final ValueChanged<String> onDurationSelected;
  final VoidCallback onDistrictReset;
  final VoidCallback onDurationReset;

  const ScheduleFiltersWidget({
    super.key,
    required this.districts,
    required this.durations,
    this.selectedDistrict,
    this.selectedDuration,
    required this.onDistrictSelected,
    required this.onDurationSelected,
    required this.onDistrictReset,
    required this.onDurationReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bộ lọc Quận
          _buildFilterSection(
            title: 'Địa điểm (Quận)',
            options: districts,
            selectedValue: selectedDistrict,
            onSelected: onDistrictSelected,
            onReset: onDistrictReset,
          ),
          const SizedBox(height: 16),
          // Bộ lọc Thời gian
          _buildFilterSection(
            title: 'Thời gian',
            options: durations,
            selectedValue: selectedDuration,
            onSelected: onDurationSelected,
            onReset: onDurationReset,
          ),
        ],
      ),
    );
  }

  /// Tiện ích con nội bộ cho một hàng bộ lọc
  Widget _buildFilterSection({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
    required VoidCallback onReset,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            GestureDetector(
              onTap: onReset,
              child: const Text(
                'Tổ lọc',
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
            children: options.map((option) {
              final isSelected = selectedValue == option ||
                  (selectedValue == null && option == 'Tất cả');
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => onSelected(option),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFF4A90E2) : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF4A90E2)
                            : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.grey[700],
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
    );
  }
}

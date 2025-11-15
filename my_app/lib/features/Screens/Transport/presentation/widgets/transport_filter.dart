// lib/widgets/transport_filter.dart
import 'package:flutter/material.dart';

class TransportFilter extends StatelessWidget {
  final String? selectedLoai;
  final String searchKeyword;
  final Function(String?) onLoaiChanged;
  final Function(String) onSearchChanged;
  final VoidCallback onClear;

  const TransportFilter({
    super.key,
    required this.selectedLoai,
    required this.searchKeyword,
    required this.onLoaiChanged,
    required this.onSearchChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tìm kiếm từ khóa
          TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              labelText: "Tìm kiếm theo thẻ (ví dụ: nhóm, mưa)",
              prefixIcon: const Icon(Icons.search, color: Color(0xFF4CAF50)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF4CAF50)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    const BorderSide(color: Color(0xFF4CAF50), width: 2),
              ),
              labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
              filled: true,
              fillColor: const Color(0xFFE8F5E8),
            ),
            controller: TextEditingController(text: searchKeyword),
          ),
          const SizedBox(height: 12),
          // Bộ lọc loại
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedLoai,
                  decoration: InputDecoration(
                    labelText: "Loại phương tiện",
                    prefixIcon:
                        const Icon(Icons.filter_list, color: Color(0xFF4CAF50)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF4CAF50)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: Color(0xFF4CAF50), width: 2),
                    ),
                    labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                    filled: true,
                    fillColor: const Color(0xFFE8F5E8),
                  ),
                  dropdownColor: const Color(0xFFE8F5E8),
                  items: const [
                    DropdownMenuItem(
                        value: '',
                        child: Text('Tất cả')), // Thêm tùy chọn tất cả
                    DropdownMenuItem(
                        value: 'xe máy',
                        child: Text(
                            'Xe máy')), // Phân loại theo dữ liệu loai trong bảng
                    DropdownMenuItem(value: 'ô tô', child: Text('Ô tô')),
                    DropdownMenuItem(
                        value: 'công cộng', child: Text('Công cộng')),
                  ],
                  onChanged: onLoaiChanged,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: (selectedLoai == null || selectedLoai == '') &&
                        searchKeyword.isEmpty
                    ? null
                    : onClear,
                icon: const Icon(Icons.clear_all, color: Colors.red),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFE8F5E8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

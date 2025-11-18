// lib/widgets/transport_filter.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để hỗ trợ IME cho tiếng Việt

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
    final searchController = TextEditingController(text: searchKeyword);
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tìm kiếm từ khóa - Cải thiện với shadow và hỗ trợ IME
          TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              labelText: "Tìm kiếm theo thẻ (ví dụ: nhóm, mưa)",
              prefixIcon: const Icon(Icons.search, color: Color(0xFF4CAF50)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE8F5E8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF4CAF50), width: 2),
              ),
              labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
              filled: true,
              fillColor: const Color(0xFFE8F5E8),
              suffixIcon: searchKeyword.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        onSearchChanged('');
                        searchController.clear();
                      },
                    )
                  : null,
            ),
            // Hỗ trợ gõ tiếng Việt mượt mà
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            enableSuggestions: true,
            autocorrect: true,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(
                    r'[a-zA-Z0-9\sàáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bộ lọc loại - Cải thiện dropdown với icon
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE8F5E8)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
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
              const SizedBox(width: 12),
              // Nút clear - Làm đẹp hơn với chip
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: (selectedLoai == null || selectedLoai == '') &&
                          searchKeyword.isEmpty
                      ? null
                      : onClear,
                  icon: const Icon(Icons.clear_all, color: Colors.red),
                  constraints:
                      const BoxConstraints(minWidth: 44, minHeight: 44),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

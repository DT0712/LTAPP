// lib/page/transport_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../../data/transport_model.dart';
import '../../data/transport_repository.dart';
import '../widgets/transport_card.dart';
import '../widgets/transport_filter.dart';

class TransportPage extends StatefulWidget {
  const TransportPage({super.key});

  @override
  State<TransportPage> createState() => _TransportPageState();
}

class _TransportPageState extends State<TransportPage> {
  String? selectedLoai; // Bộ lọc loại phương tiện
  String searchKeyword = ''; // Từ khóa tìm kiếm
  Timer? _debounce; // Debounce cho tìm kiếm để mượt mà hơn

  // Hàm chuẩn hóa chuỗi tiếng Việt (loại bỏ dấu để tìm kiếm không phân biệt dấu)
  String _normalize(String input) {
    if (input.isEmpty) return input;
    return input
        .toLowerCase()
        // a
        .replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
        // e
        .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
        // i
        .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
        // o
        .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
        // u
        .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
        // y
        .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
        // d
        .replaceAll(RegExp(r'[đ]'), 'd')
        // Các ký tự khác nếu cần
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '');
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => searchKeyword = value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background gradient đẹp hơn: Từ xanh nhạt đến trắng
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F5E8), // Xanh lá nhạt ở trên
              Color(0xFFF1F8E9), // Xanh nhạt hơn ở dưới
              Colors.white, // Chuyển sang trắng ở dưới cùng
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar đẹp hơn với gradient và nút back
              _buildCustomAppBar(context),
              // Bộ lọc và tìm kiếm
              TransportFilter(
                selectedLoai: selectedLoai,
                searchKeyword: searchKeyword,
                onLoaiChanged: (value) {
                  setState(() => selectedLoai = value);
                },
                onSearchChanged: _onSearchChanged, // Sử dụng hàm debounce
                onClear: () {
                  setState(() {
                    selectedLoai = null;
                    searchKeyword = '';
                  });
                  _debounce?.cancel(); // Hủy debounce khi clear
                },
              ),
              // Danh sách phương tiện
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: TransportRepository.getAllTransportStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                              color: Color(0xFF4CAF50)));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.directions_car_outlined,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Chưa có thông tin phương tiện.',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                      );
                    }

                    final docs = snapshot.data!.docs;
                    final items = docs
                        .map((d) => TransportModel.fromFirestore(d))
                        .toList();

                    // Filter theo loại và từ khóa (tìm trong 'the', ten, moTa) - không phân biệt dấu
                    List<TransportModel> filteredItems = items.where((item) {
                      bool matchLoai = selectedLoai == null ||
                          selectedLoai == '' ||
                          item.loai.toLowerCase() ==
                              selectedLoai!.toLowerCase();
                      bool matchKeyword = searchKeyword.isEmpty ||
                          item.the.any((tag) => _normalize(tag)
                              .contains(_normalize(searchKeyword))) ||
                          _normalize(item.ten)
                              .contains(_normalize(searchKeyword)) ||
                          _normalize(item.moTa)
                              .contains(_normalize(searchKeyword));
                      return matchLoai && matchKeyword;
                    }).toList();

                    if (filteredItems.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Không tìm thấy phương tiện phù hợp.',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, i) {
                        return TransportCard(item: filteredItems[i]);
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
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      height: 80, // Chiều cao AppBar
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4CAF50), // Xanh đậm
            Color(0xFF8BC34A), // Xanh nhạt hơn
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(20), // Bo góc dưới cho hiện đại
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Nút back
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  Navigator.pop(context); // Quay về trang trước
                },
              ),
              // Title căn giữa
              Expanded(
                child: Text(
                  "Phương tiện di chuyển",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              // Placeholder cho symmetric (có thể thêm nút khác nếu cần)
              const SizedBox(width: 48), // Để cân bằng với nút back
            ],
          ),
        ),
      ),
    );
  }
}

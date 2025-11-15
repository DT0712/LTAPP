// lib/page/transport_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFE8F5E8), // Xanh lá cây nhạt cho background
      appBar: AppBar(
        title: const Text(
          "Phương tiện di chuyển",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:
            const Color(0xFF4CAF50), // Xanh lá cây đậm hơn cho AppBar
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Bộ lọc và tìm kiếm
          TransportFilter(
            selectedLoai: selectedLoai,
            searchKeyword: searchKeyword,
            onLoaiChanged: (value) {
              setState(() => selectedLoai = value);
            },
            onSearchChanged: (value) {
              setState(() => searchKeyword = value);
            },
            onClear: () {
              setState(() {
                selectedLoai = null;
                searchKeyword = '';
              });
            },
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: TransportRepository.getAllTransportStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF4CAF50)));
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
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  );
                }

                final docs = snapshot.data!.docs;
                final items =
                    docs.map((d) => TransportModel.fromFirestore(d)).toList();

                // Filter theo loại và từ khóa (tìm trong 'the', ten, moTa)
                List<TransportModel> filteredItems = items.where((item) {
                  bool matchLoai = selectedLoai == null ||
                      selectedLoai == '' ||
                      item.loai.toLowerCase() == selectedLoai!.toLowerCase();
                  bool matchKeyword = searchKeyword.isEmpty ||
                      item.the.any((tag) => tag
                          .toLowerCase()
                          .contains(searchKeyword.toLowerCase())) ||
                      item.ten
                          .toLowerCase()
                          .contains(searchKeyword.toLowerCase()) ||
                      item.moTa
                          .toLowerCase()
                          .contains(searchKeyword.toLowerCase());
                  return matchLoai && matchKeyword;
                }).toList();

                if (filteredItems.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Không tìm thấy phương tiện phù hợp.',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
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
    );
  }
}

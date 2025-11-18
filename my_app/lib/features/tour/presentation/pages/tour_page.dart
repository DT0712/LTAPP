import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../tour/data/tour_data.dart';
import '../widgets/tour_item.dart';

class TourPage extends StatefulWidget {
  const TourPage({super.key});

  @override
  State<TourPage> createState() => _TourPageState();
}

class _TourPageState extends State<TourPage> {
  String? selectedDistrict;
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(220),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          flexibleSpace: ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(32)),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset("assets/images/bannerLT.png", fit: BoxFit.cover),
                Container(color: Colors.black.withOpacity(0.15)),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.35),
                        Colors.black.withOpacity(0.05),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: -40,
                  right: -40,
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // BODY
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------ CHỌN QUẬN ------------------
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: TourRepository.getDistricts(),
              builder: (context, snap) {
                List<String> districts = [];
                if (snap.hasData) {
                  for (var d in snap.data!) {
                    districts.add(d["ten"] ?? "Tên quận?");
                  }
                }
                return SizedBox(
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildChip(
                        label: "Ngẫu nhiên",
                        isSelected: selectedDistrict == "Ngẫu nhiên",
                        onTap: () {
                          setState(() {
                            selectedDistrict = selectedDistrict == "Ngẫu nhiên"
                                ? null
                                : "Ngẫu nhiên";
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ...districts.map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildChip(
                            label: e,
                            isSelected: selectedDistrict == e,
                            onTap: () {
                              setState(() {
                                selectedDistrict =
                                    selectedDistrict == e ? null : e;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // ------------------ CHỌN THỜI GIAN ------------------
            SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildChip(
                    label: "1 ngày",
                    isSelected: selectedTime == "1_ngay",
                    onTap: () {
                      setState(() {
                        selectedTime =
                            selectedTime == "1_ngay" ? null : "1_ngay";
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildChip(
                    label: "2N1Đ",
                    isSelected: selectedTime == "2n1d",
                    onTap: () {
                      setState(() {
                        selectedTime = selectedTime == "2n1d" ? null : "2n1d";
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildChip(
                    label: "3N2Đ",
                    isSelected: selectedTime == "3n2d",
                    onTap: () {
                      setState(() {
                        selectedTime = selectedTime == "3n2d" ? null : "3n2d";
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ------------------ GRADIENT DIVIDER ------------------
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFFA726),
                            Color(0xFFBDBDBD),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "Lịch trình",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        letterSpacing: 0.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFBDBDBD),
                            Color(0xFFFFA726),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ------------------ NỘI DUNG ------------------
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  // CHIP UI
  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange.shade700 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
              color: isSelected ? Colors.orange : Colors.grey.shade300),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: Colors.orange.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // DỮ LIỆU LỊCH TRÌNH
  Widget _buildContent() {
    if (selectedDistrict == null || selectedTime == null) {
      return const Center(child: Text("Hãy chọn khu vực và thời gian"));
    }

    if (selectedDistrict != "Ngẫu nhiên") {
      return const Center(
          child: Text("Chưa cập nhật dữ liệu cho khu vực này."));
    }

    return StreamBuilder<Map<String, dynamic>?>(
      stream: TourRepository.getRandomTour(selectedTime!),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snap.hasData || snap.data == null) {
          return const Center(child: Text("Không có dữ liệu lịch trình."));
        }

        final data = snap.data!;
        final danhSach = data["danh_sach"];

        return ListView(
          children: [
            if (selectedTime == "1_ngay") ...[
              _buildSection("Buổi sáng", danhSach["sang"]),
              _buildSection("Buổi trưa", danhSach["trua"]),
              _buildSection("Buổi chiều", danhSach["chieu"]),
              _buildSection("Buổi tối", danhSach["toi"]),
            ] else ...[
              for (var ngay in danhSach.keys.toList()..sort())
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      _convertNgayLabel(ngay),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    _buildSection("Buổi sáng", danhSach[ngay]["sang"]),
                    _buildSection("Buổi trưa", danhSach[ngay]["trua"]),
                    _buildSection("Buổi chiều", danhSach[ngay]["chieu"]),
                    _buildSection("Buổi tối", danhSach[ngay]["toi"]),
                  ],
                ),
            ]
          ],
        );
      },
    );
  }

  String _convertNgayLabel(String raw) {
    raw = raw.toLowerCase().trim();
    if (raw.startsWith("ngay_")) {
      final num = raw.replaceAll("ngay_", "");
      return "Ngày $num";
    }
    return raw;
  }

  Widget _buildSection(String title, List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...items.map((i) => TourItem(
              ten: i["ten"],
              thoiDiem: i["thoi_diem"],
              moTa: i["mo_ta"],
            )),
      ],
    );
  }
}

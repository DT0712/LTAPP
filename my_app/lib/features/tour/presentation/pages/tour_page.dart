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

      // ------------------- APPBAR STYLE 2 -------------------
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
                // Ảnh nền
                Image.asset(
                  "assets/images/bannerLT.png",
                  fit: BoxFit.cover,
                ),

                // Layer mờ (glass)
                Container(color: Colors.black.withOpacity(0.15)),

                // Gradient tạo chiều sâu
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

                // Họa tiết ánh sáng
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

      // ---------------- BODY ----------------
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //-------------------------------------------------------
            // CHỌN QUẬN (CHIPS)
            //-------------------------------------------------------
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
                            selectedDistrict =
                                (selectedDistrict == "Ngẫu nhiên")
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
                                    (selectedDistrict == e) ? null : e;
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

            //-------------------------------------------------------
            // CHỌN THỜI GIAN
            //-------------------------------------------------------
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
                            (selectedTime == "1_ngay") ? null : "1_ngay";
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildChip(
                    label: "2N1Đ",
                    isSelected: selectedTime == "2n1d",
                    onTap: () {
                      setState(() {
                        selectedTime = (selectedTime == "2n1d") ? null : "2n1d";
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  _buildChip(
                    label: "3N2Đ",
                    isSelected: selectedTime == "3n2d",
                    onTap: () {
                      setState(() {
                        selectedTime = (selectedTime == "3n2d") ? null : "3n2d";
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  // ---------------- CHIP ----------------
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

  // ---------------- CONTENT ----------------
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
              // Nếu dữ liệu nhiều ngày, vẫn giữ thứ tự
              for (var ngay in danhSach.keys.toList()..sort())
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      ngay.toUpperCase(),
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

  // ---------------- SECTION ----------------
  Widget _buildSection(String title, List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
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

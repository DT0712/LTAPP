import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/home_references.dart';

class SuggestedPlacesSection extends StatelessWidget {
  final String? selectedQuan;
  const SuggestedPlacesSection({super.key, this.selectedQuan});

  @override
  Widget build(BuildContext context) {
    // ============================
    //  QUERY FIRESTORE
    // ============================
    final query = selectedQuan == null
        ? HomeReferences.diaDiemDeXuatRef.orderBy('danh_gia', descending: true)
        : HomeReferences.diaDiemDeXuatRef.where(
            'quan_huyen_ten',
            isEqualTo: HomeReferences.cleanText(selectedQuan!),
          );

    if (selectedQuan != null) {
      print(
          "QUERY: where('quan_huyen_ten', isEqualTo: '${HomeReferences.cleanText(selectedQuan!)}')");
    }

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final docs = snapshot.data!.docs;
        print("KẾT QUẢ: ${docs.length} documents");

        if (docs.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Không có địa điểm nào.\nQuery: ${selectedQuan ?? 'Tất cả'}",
              textAlign: TextAlign.center,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TIÊU ĐỀ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                selectedQuan == null
                    ? 'Địa điểm đề xuất'
                    : 'Địa điểm ở $selectedQuan',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // DANH SÁCH ĐỊA ĐIỂM
            SizedBox(
              height: 220,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: docs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;

                  final ten = data['ten'] ?? 'Không tên';
                  final diaChi = data['dia_chi'] ?? '';
                  final hinhAnh = data['hinh_anh'] ?? '';
                  final danhGia = data['danh_gia'] ?? 0;

                  print(
                      "${docs[index].id}: ten='$ten', quan='${data['quan_huyen_ten']}'");

                  return Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.18),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HÌNH
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14),
                          ),
                          child: Image.asset(
                            hinhAnh,
                            width: 160,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),

                        // NỘI DUNG
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ten,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                diaChi,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 16, color: Colors.amber),
                                  const SizedBox(width: 6),
                                  Text(
                                    danhGia.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

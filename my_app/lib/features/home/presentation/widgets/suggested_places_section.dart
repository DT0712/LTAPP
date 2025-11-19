import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ← BẮT BUỘC
import '../../data/home_references.dart';

class SuggestedPlacesSection extends StatelessWidget {
  final String? selectedQuan;
  const SuggestedPlacesSection({super.key, this.selectedQuan});

  @override
  Widget build(BuildContext context) {
    final query = selectedQuan == null
        ? HomeReferences.diaDiemDeXuatRef.orderBy('danh_gia', descending: true)
        : HomeReferences.placesRef
            .where('quan', isEqualTo: HomeReferences.cleanText(selectedQuan!));

    if (selectedQuan != null) {
      print(
          "QUERY: where('quan', isEqualTo: '${HomeReferences.cleanText(selectedQuan!)}')");
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
                textAlign: TextAlign.center),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                selectedQuan == null
                    ? 'Địa điểm đề xuất'
                    : 'Địa điểm ở $selectedQuan',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
            SizedBox(
              height: 220,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: docs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final quan = data['quan'] as String?;
                  final ten = data['ten'] ?? 'Không tên';
                  print("${docs[index].id}: quan='$quan', ten='$ten'");

                  return Container(
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.18),
                            blurRadius: 6,
                            offset: const Offset(0, 3))
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(14)),
                          child: Image.asset(data['hinh_anh'],
                              width: 160, height: 110, fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ten,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 6),
                                Text(data['dia_chi'],
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black54),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 6),
                                Row(children: [
                                  const Icon(Icons.star,
                                      size: 16, color: Colors.amber),
                                  const SizedBox(width: 6),
                                  Text(data['danh_gia'].toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                ]),
                              ]),
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

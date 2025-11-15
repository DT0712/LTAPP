// lib/features/home/presentation/widgets/categories_section.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/home_references.dart';

// Import các trang đích
import '../pages/categories/food_page.dart';
import '../pages/categories/hotel_page.dart';
import '../pages/categories/destination_page.dart';
import '../pages/categories/entertainment_page.dart';
import '../../../screens/transport/presentation/pages/transport_page.dart';
import '../pages/categories/service_page.dart';
import '../../../accommodation/presentation/pages/hotel_list_page.dart';

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: HomeReferences.danhMucRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final docs = snapshot.data!.docs;
        const order = [
          'quan_an',
          'luu_tru',
          'diem_den',
          'khu_vui_choi',
          'phuong_tien',
          'tien_ich'
        ];

        final sortedDocs = docs.where((d) => order.contains(d.id)).toList()
          ..sort((a, b) => order.indexOf(a.id).compareTo(order.indexOf(b.id)));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedDocs.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 18,
              crossAxisSpacing: 18,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final data = sortedDocs[index].data() as Map<String, dynamic>;
              final id = sortedDocs[index].id;

              return GestureDetector(
                onTap: () => _navigateToCategoryPage(context, id),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(data['hinh_anh'],
                            fit: BoxFit.cover, width: double.infinity),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data['ten'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _navigateToCategoryPage(BuildContext context, String id) {
    Widget page;

    switch (id) {
      case 'quan_an':
        page = const FoodPage();
        break;
      case 'luu_tru':
        page = const HotelListPage();
        break;
      case 'diem_den':
        page = const DestinationPage();
        break;
      case 'khu_vui_choi':
        page = const EntertainmentPage();
        break;
      case 'phuong_tien':
        page = const TransportPage();
        break;
      case 'tien_ich':
        page = const ServicePage();
        break;
      default:
        page = const Scaffold(
          body: Center(child: Text('Danh mục chưa hỗ trợ')),
        );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

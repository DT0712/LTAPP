import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/home_references.dart';

class DestinationPage extends StatelessWidget {
  const DestinationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3E5F5),
      appBar: AppBar(
        title: const Text("Điểm đến du lịch"),
        backgroundColor: const Color(0xFFAB47BC),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: HomeReferences.placesRef
            .where('danh_muc_id', isEqualTo: 'diem_den')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty)
            return const Center(child: Text('Chưa có điểm đến.'));
          return _buildList(docs);
        },
      ),
    );
  }

  Widget _buildList(List<QueryDocumentSnapshot> docs) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: docs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16),
      itemBuilder: (context, index) {
        final data = docs[index].data() as Map<String, dynamic>;
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(data['hinh_anh'], fit: BoxFit.cover),
              Container(
                color: Colors.black38,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(8),
                child: Text(
                  data['ten'] ?? '',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

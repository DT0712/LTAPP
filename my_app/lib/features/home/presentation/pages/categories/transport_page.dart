import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/home_references.dart';

class TransportPage extends StatelessWidget {
  const TransportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1),
      appBar: AppBar(
        title: const Text("Phương tiện di chuyển"),
        backgroundColor: const Color(0xFF26A69A),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: HomeReferences.placesRef
            .where('danh_muc_id', isEqualTo: 'phuong_tien')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty)
            return const Center(child: Text('Chưa có thông tin phương tiện.'));
          return _buildList(docs);
        },
      ),
    );
  }

  Widget _buildList(List<QueryDocumentSnapshot> docs) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final data = docs[index].data() as Map<String, dynamic>;
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: const Icon(Icons.directions_car, color: Colors.teal),
            title: Text(data['ten'] ?? ''),
            subtitle: Text(data['dia_chi'] ?? ''),
          ),
        );
      },
    );
  }
}

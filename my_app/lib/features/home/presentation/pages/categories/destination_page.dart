import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/home_references.dart';

class DestinationPage extends StatelessWidget {
  const DestinationPage({super.key});
  static const routeName = '/destination';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        title: const Text("Điểm đến"),
        backgroundColor: const Color(0xFF42A5F5),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: HomeReferences.placesRef
            .where('danh_muc_id', isEqualTo: 'dia_diem_de_xuat')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty)
            return const Center(child: Text('Chưa có dữ liệu điểm đến.'));
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
          color: Colors.white,
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  Image.asset(data['hinh_anh'], width: 80, fit: BoxFit.cover),
            ),
            title: Text(data['ten'] ?? ''),
            subtitle: Text(data['dia_chi'] ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                Text('${data['danh_gia'] ?? '-'}'),
              ],
            ),
          ),
        );
      },
    );
  }
}

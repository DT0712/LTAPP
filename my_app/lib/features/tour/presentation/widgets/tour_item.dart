import 'package:flutter/material.dart';

class TourItem extends StatelessWidget {
  final String ten;
  final String thoiDiem;
  final String moTa;

  const TourItem({
    super.key,
    required this.ten,
    required this.thoiDiem,
    required this.moTa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ten,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 4),
          Text(thoiDiem, style: const TextStyle(color: Colors.blueGrey)),
          const SizedBox(height: 4),
          Text(moTa),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const FoodCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final giamGia = data['giam_gia'] ?? 0;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 110,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildImage(data['hinh_anh']),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['ten'] ?? 'Tên quán ăn',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(' ${data['danh_gia'] ?? 0}'),
                      const SizedBox(width: 6),
                      const Icon(Icons.location_on_outlined,
                          color: Colors.grey, size: 16),
                      Expanded(
                        child: Text(
                          data['quan'] ?? '',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    data['dia_chi'] ?? '',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      if (giamGia is num && giamGia > 0)
                        _buildTag(
                          Icons.local_offer,
                          "Giảm $giamGia%",
                          Colors.redAccent,
                        ),
                      if (data['freeship'] == true)
                        _buildTag(
                          Icons.local_shipping,
                          "FREESHIP",
                          Colors.green.shade600,
                        ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImage(dynamic path) {
    if (path == null || path.toString().isEmpty) {
      return _fallback();
    }
    if (path.toString().startsWith('http')) {
      return Image.network(
        path,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }
    return Image.asset(
      path,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }

  Widget _fallback() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.grey.shade300,
      child: const Icon(Icons.fastfood, color: Colors.grey),
    );
  }

  Widget _buildTag(IconData icon, String text, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6, top: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 2),
          Text(
            text,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

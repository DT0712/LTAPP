import 'package:flutter/material.dart';
import '../../data/attraction_model.dart';

class AttractionCard extends StatelessWidget {
  const AttractionCard({
    super.key,
    this.attraction,
    this.item,
    this.onTap,
    this.onBook,
  }) : assert(attraction != null || item != null,
  'Provide either `attraction` (model) or `item` (Map).');

  final Attraction? attraction;
  final Map<String, dynamic>? item;
  final VoidCallback? onTap;
  final VoidCallback? onBook;

  Attraction _fromItem(Map<String, dynamic> m) {
    List<String> _imagesOf(dynamic v) {
      if (v is List) return v.map((e) => e.toString()).toList();
      if (v is String && v.isNotEmpty) return [v];
      return const <String>[];
    }

    return Attraction(
      id: (m['id'] ?? '').toString(),
      name: (m['ten'] ?? '').toString(),
      address: (m['dia_chi'] ?? '').toString(),
      images: _imagesOf(m['images']),
      rating: (m['danh_gia'] is num) ? (m['danh_gia'] as num).toDouble() : 0.0,
      districtId: (m['quan_huyen_id'] ?? '').toString(),
      districtName: (m['quan_huyen_ten'] ?? '').toString(),
      priceFrom: (m['priceFrom'] is num)
          ? (m['priceFrom'] as num)
          : (double.tryParse((m['priceFrom'] ?? '').toString()) ?? 0),
    );
  }

  String _fmtVND(num value) {
    final s = value.toStringAsFixed(0);
    final re = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(re, (m) => '.');
  }

  @override
  Widget build(BuildContext context) {
    final a = attraction ?? _fromItem(item!);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ẢNH
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: SizedBox(
                height: 140,
                width: double.infinity,
                child: _buildImage(a.images),
              ),
            ),

            // Nội dung
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.black54),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          a.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Color(0xFFFFB000)),
                      const SizedBox(width: 4),
                      Text(
                        (a.rating ?? 0).toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      if (a.priceFrom != null)
                        Text(
                          '${_fmtVND(a.priceFrom!)} VND',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6CA8FF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        elevation: 0,
                      ),
                      onPressed: onBook,
                      icon: const Icon(Icons.local_activity, size: 16),
                      label: const Text('Đặt vé'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(List<String> images) {
    final src = images.isNotEmpty ? images.first : null;
    if (src == null) {
      return Container(
        color: const Color(0xFFF1F3F6),
        child: const Icon(Icons.image_not_supported_outlined, size: 40, color: Colors.grey),
      );
    }
    if (src.startsWith('http')) {
      return Image.network(src, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFFF1F3F6),
            child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
          ));
    }
    return Image.asset(src, fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: const Color(0xFFF1F3F6),
          child: const Icon(Icons.broken_image_outlined, color: Colors.grey),
        ));
  }
}

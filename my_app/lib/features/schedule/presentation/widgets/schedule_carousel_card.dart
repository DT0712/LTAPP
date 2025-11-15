import 'package:flutter/material.dart';
import '../../data/schedule_model.dart';

class ScheduleCarouselCard extends StatelessWidget {
  final ScheduleItem item;

  const ScheduleCarouselCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Xử lý khi nhấn vào thẻ, ví dụ: điều hướng đến trang chi tiết
        print('Tapped on ${item.place}');
      },
      child: Container(
        width: 160, // Chiều rộng cố định cho thẻ
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias, // Để bo góc hình ảnh
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình ảnh
              Container(
                height: 120,
                width: double.infinity,
                color: Colors.grey[200],
                child: item.image != null && item.image!.isNotEmpty
                    ? Image.network(
                        item.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported,
                                color: Colors.grey),
                      )
                    : const Icon(Icons.location_on, color: Colors.grey),
              ),
              // Nội dung
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.place,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.duration ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

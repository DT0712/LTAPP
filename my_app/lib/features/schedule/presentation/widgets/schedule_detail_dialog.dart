// lib/features/schedule/presentation/widgets/schedule_detail_dialog.dart
import 'package:flutter/material.dart';
import '../../data/schedule_model.dart'; // Import ScheduleItem model

class ScheduleDetailDialog extends StatelessWidget {
  final ScheduleItem item;

  const ScheduleDetailDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      // Bo tròn các góc giống hình mẫu
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Quan trọng: Để dialog co lại theo nội dung
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (Gồm Tiêu đề và nút X)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề: Lấy từ 'ten' của item
                Expanded(
                  child: Text(
                    item.name,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                // Nút X để đóng dialog
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const Divider(height: 24), // Đường kẻ phân cách

            // 2. Nội dung chi tiết (Trường 'cu_the')
            // Sử dụng Flexible + SingleChildScrollView để nội dung dài có thể cuộn
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  // Dữ liệu này là trường 'cu_the' đã được xử lý và
                  // nối bằng '\n' (xuống dòng) từ ScheduleItem.fromDoc
                  item.description,
                  style: textTheme.bodyMedium?.copyWith(
                    height: 2, // Giãn cách dòng cho dễ đọc
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

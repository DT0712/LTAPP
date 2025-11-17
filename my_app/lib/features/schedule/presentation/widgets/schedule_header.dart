// lib/features/schedule/presentation/widgets/schedule_header.dart
import 'package:flutter/material.dart';

class ScheduleHeader extends StatelessWidget implements PreferredSizeWidget {
  const ScheduleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.orange,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.only(left: 16.0),
          ),
          leadingWidth: 56,
          title: const Text(
            'Lịch trình',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // Chiều cao AppBar chuẩn
}

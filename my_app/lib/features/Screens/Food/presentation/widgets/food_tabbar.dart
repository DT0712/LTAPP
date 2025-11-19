import 'package:flutter/material.dart';

class FoodTabBar extends StatelessWidget {
  final TabController controller;

  const FoodTabBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(50),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        labelColor: Colors.orange.shade900,
        unselectedLabelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.shade200.withOpacity(0.5),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        tabs: const [
          Tab(text: "Gợi ý"),
          Tab(text: "Gần tôi"),
          Tab(text: "Giảm nhiều"),
          Tab(text: "Mới nhất"),
        ],
      ),
    );
  }
}

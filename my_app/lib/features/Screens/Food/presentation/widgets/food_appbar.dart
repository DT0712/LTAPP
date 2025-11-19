import 'package:flutter/material.dart';
import '../widgets/big_triangle_clipper.dart';
import '../widgets/small_triangle_clipper.dart';
import 'food_tabbar.dart';

class FoodAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBack;
  final VoidCallback onFilter;
  final TabController tabController;

  const FoodAppBar({
    super.key,
    required this.onBack,
    required this.onFilter,
    required this.tabController,
  });

  @override
  Size get preferredSize => const Size.fromHeight(170);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: BigTriangleClipper(),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFB300), Color(0xFFFFA000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        ClipPath(
          clipper: SmallTriangleClipper(),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFE082), Color(0xFFFFB300)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                      onPressed: onBack,
                    ),
                    const Text(
                      "Quán ăn",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list_alt,
                          color: Colors.white),
                      onPressed: onFilter,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FoodTabBar(controller: tabController),
            ],
          ),
        ),
      ],
    );
  }
}

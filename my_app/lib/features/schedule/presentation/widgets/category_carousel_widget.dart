import 'package:flutter/material.dart';
import '../../data/schedule_model.dart';
import 'schedule_carousel_card.dart';

class CategoryCarouselWidget extends StatelessWidget {
  final String category;
  final List<ScheduleItem> items;

  const CategoryCarouselWidget({
    super.key,
    required this.category,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          height: 220, // Chiều cao cố định cho carousel
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ScheduleCarouselCard(item: items[index]);
            },
          ),
        ),
      ],
    );
  }
}

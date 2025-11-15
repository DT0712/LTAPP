import 'package:flutter/material.dart';

class CategoryFilterChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const CategoryFilterChip({
    Key? key,
    required this.category,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(category),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.blue,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(
        color: isSelected ? Colors.blue : Colors.transparent,
      ),
    );
  }
}

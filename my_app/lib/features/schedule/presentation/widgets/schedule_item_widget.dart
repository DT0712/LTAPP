import 'package:flutter/material.dart';
import '../../data/schedule_model.dart';

class ScheduleItemWidget extends StatelessWidget {
  final ScheduleItem item;
  final bool value;
  final ValueChanged<bool> onChanged;

  const ScheduleItemWidget({
    Key? key,
    required this.item,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      title: Text('${item.time} — ${item.place}'),
      subtitle: item.description != null && item.description!.isNotEmpty
          ? Text(item.description!)
          : null,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

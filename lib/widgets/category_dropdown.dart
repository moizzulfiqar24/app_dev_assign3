import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final String current;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const CategoryDropdown({
    Key? key,
    required this.current,
    required this.options,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: current,
      decoration: InputDecoration(
        labelText: 'Category',
        filled: true,
        fillColor: const Color(0xFFFFF6FB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: options
          .map((o) => DropdownMenuItem(value: o, child: Text(o)))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

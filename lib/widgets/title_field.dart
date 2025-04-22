import 'package:flutter/material.dart';

class TitleField extends StatelessWidget {
  final TextEditingController controller;
  const TitleField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Title',
        filled: true,
        fillColor: const Color(0xFFFFF6FB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

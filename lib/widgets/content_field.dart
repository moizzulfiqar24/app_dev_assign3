import 'package:flutter/material.dart';

class ContentField extends StatelessWidget {
  final TextEditingController controller;
  const ContentField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 6,
      decoration: InputDecoration(
        labelText: 'Content',
        filled: true,
        fillColor: const Color(0xFFFFF6FB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

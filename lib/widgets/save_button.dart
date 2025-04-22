import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onPressed;

  const SaveButton({Key? key, required this.isEditing, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink.shade200,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(isEditing ? 'Update' : 'Save'),
    );
  }
}

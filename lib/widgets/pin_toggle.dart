import 'package:flutter/material.dart';

class PinToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const PinToggle({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: const Text('Pin this note'),
      activeColor: Colors.pink.shade200,
      contentPadding: EdgeInsets.zero,
    );
  }
}

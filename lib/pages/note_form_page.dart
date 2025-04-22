import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../models/note_model.dart';
import '../blocs/note_bloc.dart';

class NoteFormPage extends StatefulWidget {
  final Note? initialNote;
  const NoteFormPage({Key? key, this.initialNote}) : super(key: key);

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();
  String _category = 'Personal';
  bool _pinned = false;
  List<XFile> _pickedImages = [];

  final List<String> _allCategories = ['Personal', 'Work', 'Study'];

  @override
  void initState() {
    super.initState();
    final note = widget.initialNote;
    if (note != null) {
      _titleCtrl.text = note.title;
      _contentCtrl.text = note.content;
      _category = note.category;
      _pinned = note.isPinned;
      _pickedImages = note.imagePaths.map((path) => XFile(path)).toList();
    }
  }

  InputDecoration _inputDecor(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFFFF6FB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );

  Future<void> _selectImages() async {
    final result = await ImagePicker().pickMultiImage();
    if (result.isNotEmpty) {
      setState(() {
        for (var file in result) {
          if (!_pickedImages.any((e) => e.path == file.path)) {
            _pickedImages.add(file);
          }
        }
      });
    }
  }

  void _saveNote() {
    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title and content are required.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final newNote = Note(
      title: title,
      content: content,
      category: _category,
      isPinned: _pinned,
      imagePaths: _pickedImages.map((x) => x.path).toList(),
    );

    final bloc = context.read<NoteBloc>();
    if (widget.initialNote != null) {
      bloc.add(UpdateNote(widget.initialNote!, newNote));
    } else {
      bloc.add(AddNote(newNote));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialNote != null;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6FB),
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'Add Note'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: _inputDecor('Title'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _contentCtrl,
              decoration: _inputDecor('Content'),
              maxLines: 6,
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: _inputDecor('Category'),
              items: _allCategories
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    ),
                  )
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _category = val);
              },
            ),
            const SizedBox(height: 15),
            _PinSwitch(
              pinned: _pinned,
              onChanged: (val) => setState(() => _pinned = val),
            ),
            const SizedBox(height: 10),
            ImagePickerSection(
              images: _pickedImages,
              onAdd: _selectImages,
              onRemove: (idx) {
                setState(() => _pickedImages.removeAt(idx));
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade200,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(isEditing ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinSwitch extends StatelessWidget {
  final bool pinned;
  final ValueChanged<bool> onChanged;
  const _PinSwitch({Key? key, required this.pinned, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: pinned,
      onChanged: onChanged,
      title: const Text('Pin this note'),
      activeColor: Colors.pink.shade200,
      contentPadding: EdgeInsets.zero,
    );
  }
}

class ImagePickerSection extends StatelessWidget {
  final List<XFile> images;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  const ImagePickerSection({
    Key? key,
    required this.images,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.image),
          label: const Text('Select Images'),
        ),
        if (images.isNotEmpty) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (ctx, idx) {
                final img = images[idx];
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(img.path),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: -8,
                      right: -8,
                      child: GestureDetector(
                        onTap: () => onRemove(idx),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

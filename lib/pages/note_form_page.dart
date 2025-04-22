import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../models/note_model.dart';
import '../blocs/note_bloc.dart';
import '../widgets/title_field.dart';
import '../widgets/content_field.dart';
import '../widgets/category_dropdown.dart';
import '../widgets/pin_toggle.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/save_button.dart';

class NoteFormPage extends StatefulWidget {
  final Note? initialNote;
  const NoteFormPage({Key? key, this.initialNote}) : super(key: key);

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  String _category = 'Personal';
  bool _pinned = false;
  List<XFile> _pickedImages = [];
  final _allCategories = ['Personal', 'Work', 'Study'];

  @override
  void initState() {
    super.initState();
    final note = widget.initialNote;
    if (note != null) {
      _titleCtrl.text = note.title;
      _contentCtrl.text = note.content;
      _category = note.category;
      _pinned = note.isPinned;
      _pickedImages = note.imagePaths.map((p) => XFile(p)).toList();
    }
  }

  Future<void> _selectImages() async {
    final result = await ImagePicker().pickMultiImage();
    if (result.isNotEmpty) {
      setState(() {
        for (var f in result) {
          if (!_pickedImages.any((e) => e.path == f.path)) {
            _pickedImages.add(f);
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

    final note = Note(
      title: title,
      content: content,
      category: _category,
      isPinned: _pinned,
      imagePaths: _pickedImages.map((x) => x.path).toList(),
    );

    final bloc = context.read<NoteBloc>();
    if (widget.initialNote != null) {
      bloc.add(UpdateNote(widget.initialNote!, note));
    } else {
      bloc.add(AddNote(note));
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
            TitleField(controller: _titleCtrl),
            const SizedBox(height: 15),
            ContentField(controller: _contentCtrl),
            const SizedBox(height: 15),
            CategoryDropdown(
              current: _category,
              options: _allCategories,
              onChanged: (v) => setState(() => _category = v),
            ),
            const SizedBox(height: 15),
            PinToggle(
              value: _pinned,
              onChanged: (v) => setState(() => _pinned = v),
            ),
            const SizedBox(height: 10),
            ImagePickerWidget(
              images: _pickedImages,
              onAdd: _selectImages,
              onRemove: (i) => setState(() => _pickedImages.removeAt(i)),
            ),
            const SizedBox(height: 30),
            SaveButton(isEditing: isEditing, onPressed: _saveNote),
          ],
        ),
      ),
    );
  }
}

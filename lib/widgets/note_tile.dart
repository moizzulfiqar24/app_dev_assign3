import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/note_model.dart';
import '../blocs/note_bloc.dart';
import '../pages/note_form_page.dart';

class NoteTile extends StatelessWidget {
  final Note note;
  const NoteTile({Key? key, required this.note}) : super(key: key);

  Color _colorForCategory(String cat) {
    switch (cat.toLowerCase()) {
      case 'work':
        return const Color(0xFFFFF9C4);
      case 'personal':
        return const Color(0xFFB3E5FC);
      case 'study':
        return const Color(0xFFFFCDD2);
      default:
        return Colors.grey.shade300;
    }
  }

  void _openDetailSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DetailSheet(note: note),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _colorForCategory(note.category);
    return InkWell(
      onTap: () => _openDetailSheet(context),
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TitleRow(note: note),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                note.content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 8),
            _FooterRow(note: note, categoryColor: bgColor),
          ],
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  final Note note;
  const _TitleRow({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            note.title,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        if (note.isPinned) const Icon(Icons.push_pin, size: 16),
      ],
    );
  }
}

class _FooterRow extends StatelessWidget {
  final Note note;
  final Color categoryColor;
  const _FooterRow({
    Key? key,
    required this.note,
    required this.categoryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _InlineCategoryChip(label: note.category, color: categoryColor),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (note.imagePaths.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(right: 4.0),
                child: Icon(Icons.attach_file, size: 18),
              ),
            InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NoteFormPage(initialNote: note),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.edit, size: 18),
              ),
            ),
            InkWell(
              onTap: () => _confirmDeletion(context),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.delete, size: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _confirmDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Note?'),
        content: const Text('Do you want to remove this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<NoteBloc>().add(DeleteNote(note));
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Small, italic chip used in grid tiles
class _InlineCategoryChip extends StatelessWidget {
  final String label;
  final Color color;
  const _InlineCategoryChip({
    Key? key,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _DetailSheet extends StatelessWidget {
  final Note note;
  const _DetailSheet({Key? key, required this.note}) : super(key: key);

  Color _colorForCategory(String cat) {
    switch (cat.toLowerCase()) {
      case 'work':
        return const Color(0xFFFFF9C4);
      case 'personal':
        return const Color(0xFFB3E5FC);
      case 'study':
        return const Color(0xFFFFCDD2);
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (_, ctrl) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF6FF),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            controller: ctrl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        note.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _DetailCategoryChip(
                      label: note.category,
                      color: _colorForCategory(note.category),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (note.imagePaths.isNotEmpty) ...[
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: note.imagePaths.map((path) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(path),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  note.content,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Larger, non-italic chip used in detail sheet
class _DetailCategoryChip extends StatelessWidget {
  final String label;
  final Color color;
  const _DetailCategoryChip({
    Key? key,
    required this.label,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/note_bloc.dart';
import '../models/note_model.dart';
import 'note_form_page.dart';
import '../widgets/note_tile.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({Key? key}) : super(key: key);

  @override
  State<NotesListPage> createState() => _NotesListPageState();
}

class _NotesListPageState extends State<NotesListPage> {
  String _filterCategory = 'All';

  List<String> _buildCategories(List<Note> notes) {
    final cats = notes.map((n) => n.category).toSet().toList()..sort();
    return ['All', ...cats];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'NoteIt',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          BlocBuilder<NoteBloc, NoteState>(
            builder: (ctx, state) {
              if (state is NotesLoaded) {
                final categories = _buildCategories(state.notes);
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CategoryFilter(
                    categories: categories,
                    current: _filterCategory,
                    onSelected: (val) => setState(() => _filterCategory = val),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (ctx, state) {
          if (state is NotesLoaded) {
            final notes = _filterCategory == 'All'
                ? state.notes
                : state.notes
                    .where((n) => n.category == _filterCategory)
                    .toList();

            if (notes.isEmpty) {
              return const Center(child: Text('No notes available.'));
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
              child: GridView.builder(
                itemCount: notes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (ctx, idx) {
                  return Transform.rotate(
                    angle: -0.052,
                    child: NoteTile(note: notes[idx]),
                  );
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade200,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const NoteFormPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String current;
  final ValueChanged<String> onSelected;

  const CategoryFilter({
    Key? key,
    required this.categories,
    required this.current,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: current,
        items: categories
            .map((c) => DropdownMenuItem<String>(
                  value: c,
                  child: Text(c,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ))
            .toList(),
        onChanged: (val) {
          if (val != null) onSelected(val);
        },
        underline: const SizedBox(),
        isDense: true,
        icon: const Icon(Icons.arrow_drop_down),
      ),
    );
  }
}

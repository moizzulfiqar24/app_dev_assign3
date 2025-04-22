import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/note_bloc.dart';
import 'pages/notes_list_page.dart';

void main() {
  runApp(const NoteItApp());
}

class NoteItApp extends StatelessWidget {
  const NoteItApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NoteBloc()..add(LoadNotes()),
      child: MaterialApp(
        title: 'NoteIt',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: const Color(0xFFFEF6FF),
        ),
        home: const NotesListPage(),
      ),
    );
  }
}

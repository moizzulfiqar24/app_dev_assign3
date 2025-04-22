import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';

class SharedPrefUtil {
  static const String _kNotes = 'NOTES';

  static Future<void> persistNotes(List<Note> notes) async {
    final preferences = await SharedPreferences.getInstance();
    final payload = Note.stringifyList(notes);
    await preferences.setString(_kNotes, payload);
  }

  static Future<List<Note>> retrieveNotes() async {
    final preferences = await SharedPreferences.getInstance();
    final stored = preferences.getString(_kNotes);
    if (stored == null || stored.isEmpty) {
      return <Note>[];
    }
    return Note.parseList(stored);
  }
}

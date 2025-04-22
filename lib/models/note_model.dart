import 'dart:convert';

class Note {
  String title;
  String content;
  String category;
  bool isPinned;
  List<String> imagePaths;

  Note({
    required this.title,
    required this.content,
    required this.category,
    this.isPinned = false,
    this.imagePaths = const [],
  });

  factory Note.fromJson(Map<String, dynamic> map) {
    return Note(
      title: map['title'] as String,
      content: map['content'] as String,
      category: map['category'] as String,
      isPinned: map['isPinned'] as bool? ?? false,
      imagePaths: List<String>.from(map['imagePaths'] ?? <String>[]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'category': category,
      'isPinned': isPinned,
      'imagePaths': imagePaths,
    };
  }

  /// Decode a JSON string into a List<Note>
  static List<Note> parseList(String source) {
    final List<dynamic> data = jsonDecode(source) as List<dynamic>;
    return data
        .map((item) => Note.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Encode a List<Note> into a JSON string
  static String stringifyList(List<Note> notes) {
    final jsonList = notes.map((n) => n.toJson()).toList();
    return jsonEncode(jsonList);
  }
}

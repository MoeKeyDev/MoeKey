class NoteTranslate {
  String sourceLang;
  String text;
  bool loading = true;

  NoteTranslate({
    required this.sourceLang,
    required this.text,
  });

  factory NoteTranslate.fromMap(dynamic map) {
    return NoteTranslate(
      sourceLang: map['sourceLang'],
      text: map['text'],
    );
  }

  @override
  String toString() {
    return 'Translate{sourceLang: $sourceLang, text: $text}';
  }
}

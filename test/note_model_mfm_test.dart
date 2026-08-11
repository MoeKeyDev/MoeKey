import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/apis/models/note.dart';

void main() {
  test('pre-parses note MFM without serializing the AST', () {
    final note = NoteModel.fromJson(
      _noteJson(
        id: 'root',
        text: 'hello **world**',
        cw: ':warning: content',
        renote: _noteJson(id: 'renote', text: '#nested'),
      ),
    );

    expect(note.textAst, isNotEmpty);
    expect(note.cwAst, isNotEmpty);
    expect(note.renote?.textAst, isNotEmpty);

    final json = note.toJson();
    expect(json, isNot(contains('textAst')));
    expect(json, isNot(contains('cwAst')));

    final restored = NoteModel.fromJson(
      jsonDecode(jsonEncode(json)) as Map<String, dynamic>,
    );
    expect(restored.textAst, isNotEmpty);
    expect(restored.cwAst, isNotEmpty);
    expect(restored.renote?.textAst, isNotEmpty);
  });
}

Map<String, dynamic> _noteJson({
  required String id,
  required String text,
  String? cw,
  Map<String, dynamic>? renote,
}) {
  return {
    'id': id,
    'createdAt': '2026-08-10T00:00:00.000Z',
    'cw': cw,
    'emojis': <String, dynamic>{},
    'files': <dynamic>[],
    'localOnly': false,
    'reactionEmojis': <String, dynamic>{},
    'reactions': <String, int>{},
    'renote': renote,
    'text': text,
    'user': {
      'avatarBlurhash': null,
      'avatarDecorations': <dynamic>[],
      'avatarUrl': null,
      'emojis': <String, String>{},
      'host': null,
      'id': 'user-$id',
      'makeNotesFollowersOnlyBefore': null,
      'makeNotesHiddenBefore': null,
      'name': 'User',
      'onlineStatus': 'unknown',
      'username': 'user',
    },
    'userId': 'user-$id',
    'visibility': 'public',
  };
}

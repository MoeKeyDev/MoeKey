import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'translate.freezed.dart';

part 'translate.g.dart';

@unfreezed
abstract class NoteTranslate with _$NoteTranslate {
  factory NoteTranslate({
    required String sourceLang,
    required String text,
    @Default(true) bool loading,
  }) = _NoteTranslate;

  factory NoteTranslate.fromJson(Map<String, dynamic> json) =>
      _$NoteTranslateFromJson(json);
}

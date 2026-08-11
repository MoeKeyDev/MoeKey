import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/widgets/note_create_dialog/note_create_dialog.dart';

void main() {
  test('inserts text at the current cursor position', () {
    final controller = TextEditingController(text: 'hello world')
      ..selection = const TextSelection.collapsed(offset: 5);
    addTearDown(controller.dispose);

    insertTextAtSelection(controller, ':smile:');

    expect(controller.text, 'hello:smile: world');
    expect(controller.selection, const TextSelection.collapsed(offset: 12));
  });

  test('replaces the current selection', () {
    final controller = TextEditingController(text: 'hello world')
      ..selection = const TextSelection(baseOffset: 0, extentOffset: 5);
    addTearDown(controller.dispose);

    insertTextAtSelection(controller, 'hi');

    expect(controller.text, 'hi world');
    expect(controller.selection, const TextSelection.collapsed(offset: 2));
  });

  test('appends text when there is no valid selection', () {
    final controller = TextEditingController(text: 'hello');
    addTearDown(controller.dispose);

    insertTextAtSelection(controller, '!');

    expect(controller.text, 'hello!');
    expect(controller.selection, const TextSelection.collapsed(offset: 6));
  });
}

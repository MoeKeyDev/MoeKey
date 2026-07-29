import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/widgets/reactions.dart';

void main() {
  test('groups local and remote variants of the same custom emoji', () {
    final display = normalizeReactionsForDisplay(
      reactions: {
        '❤': 11,
        ':lihai:': 2,
        ':lihai@pari.cafe:': 1,
        ':lihai@stelpolva.moe:': 1,
        ':bgm106@clanna.dev:': 1,
      },
      myReaction: null,
      emojis: const {},
      localEmojiNames: ['lihai'],
    );

    expect(display.reactions, {
      '❤': 11,
      ':lihai@.:': 4,
      ':bgm106@clanna.dev:': 1,
    });
  });

  test('keeps an ungrouped remote-only emoji unchanged', () {
    const reaction = ':ablobcatbongopost@dvd.chat:';

    expect(
      normalizeReactionsForDisplay(
        reactions: {reaction: 1},
        myReaction: null,
        emojis: const {},
        localEmojiNames: const [],
      ).reactions,
      {reaction: 1},
    );
  });

  test('groups same-named remote emojis and keeps a remote image', () {
    final input = {':lihai@pari.cafe:': 1, ':lihai@stelpolva.moe:': 1};

    final display = normalizeReactionsForDisplay(
      reactions: input,
      myReaction: null,
      emojis: {
        'lihai@pari.cafe': 'https://pari.cafe/lihai.png',
        'lihai@stelpolva.moe': 'https://stelpolva.moe/lihai.png',
      },
      localEmojiNames: const [],
    );

    expect(display.reactions, {':lihai@.:': 2});
    expect(display.emojis['lihai'], 'https://pari.cafe/lihai.png');
  });

  test('normalizes the current user reaction to the display key', () {
    final display = normalizeReactionsForDisplay(
      reactions: {':lihai@pari.cafe:': 1, ':lihai@stelpolva.moe:': 1},
      myReaction: ':lihai@pari.cafe:',
      emojis: const {},
      localEmojiNames: const [],
    );

    expect(display.myReaction, ':lihai@.:');
  });
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/themes.dart';
import 'package:twemoji_v2/twemoji_v2.dart';

import '../status/misskey_api.dart';
import 'hover_builder.dart';
import 'mk_image.dart';

String? parseString(String input) {
  final match = RegExp(r'^:([^:]+):$').firstMatch(input);
  final code = match?.group(1);
  if (code == null) {
    return null;
  }
  return code.endsWith('@.') ? code.substring(0, code.length - 2) : code;
}

String? _customEmojiName(String reaction) {
  final code = parseString(reaction);
  if (code == null) {
    return null;
  }
  final atIndex = code.lastIndexOf('@');
  return atIndex == -1 ? code : code.substring(0, atIndex);
}

Set<String> _normalizableReactionNames(
  Map<String, int> reactions,
  Iterable<String> localEmojiNames,
) {
  final names = localEmojiNames.toSet();
  final reactionKeysByName = <String, Set<String>>{};

  for (final reaction in reactions.keys) {
    final name = _customEmojiName(reaction);
    if (name != null) {
      (reactionKeysByName[name] ??= <String>{}).add(reaction);
    }
  }
  for (final entry in reactionKeysByName.entries) {
    if (entry.value.length > 1) {
      names.add(entry.key);
    }
  }

  return names;
}

String _displayReactionKey(String reaction, Set<String> normalizableNames) {
  final name = _customEmojiName(reaction);
  return name != null && normalizableNames.contains(name)
      ? ':$name@.:'
      : reaction;
}

/// Groups local variants and same-named remote variants of a custom emoji.
///
/// A group uses `:name@.:` as its display key.  This combines local custom
/// emoji with its remote copies, and also combines remote copies when more
/// than one site provides the same emoji name.
class NormalizedReactions {
  const NormalizedReactions({
    required this.reactions,
    required this.myReaction,
    required this.emojis,
  });

  final Map<String, int> reactions;
  final String? myReaction;
  final Map emojis;
}

NormalizedReactions normalizeReactionsForDisplay({
  required Map<String, int> reactions,
  required String? myReaction,
  required Map? emojis,
  required Iterable<String> localEmojiNames,
}) {
  final normalizableNames = _normalizableReactionNames(
    reactions,
    localEmojiNames,
  );
  final normalizedReactions = <String, int>{};
  final normalizedEmojis = Map.from(emojis ?? const {});

  for (final entry in reactions.entries) {
    final key = _displayReactionKey(entry.key, normalizableNames);
    normalizedReactions[key] = (normalizedReactions[key] ?? 0) + entry.value;

    final code = parseString(entry.key);
    final name = _customEmojiName(entry.key);
    if (code == null || name == null || !normalizableNames.contains(name)) {
      continue;
    }
    final url = emojis?[code];
    if (code != name && url != null && !normalizedEmojis.containsKey(name)) {
      // Use the first remote variant as the image for its merged group.
      normalizedEmojis[name] = url;
    }
  }

  return NormalizedReactions(
    reactions: normalizedReactions,
    myReaction: myReaction == null
        ? null
        : _displayReactionKey(myReaction, normalizableNames),
    emojis: normalizedEmojis,
  );
}

class ReactionsListComponent extends HookConsumerWidget {
  const ReactionsListComponent({
    super.key,
    this.emojis,
    required this.reactionsList,
    required this.id,
    this.disableReactions = false,
    this.myReaction,
  });

  final Map? emojis;
  final Map<String, int> reactionsList;
  final bool disableReactions;
  final String id;
  final String? myReaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var siteEmoji = ref.watch(apiEmojisProvider);
    var list = <Widget>[];
    final display = normalizeReactionsForDisplay(
      reactions: reactionsList,
      myReaction: myReaction,
      emojis: emojis,
      localEmojiNames: siteEmoji.value?.keys ?? const <String>[],
    );
    // 倒序排序
    for (var item
        in display.reactions.entries.toList()..sort((a, b) {
          return b.value.compareTo(a.value);
        })) {
      var code = parseString(item.key);
      var isOutSite = false;
      if (code != null && siteEmoji.value?[code] == null) {
        isOutSite = true;
      }
      var container = ReactionButton(
        item: item,
        disableReactions: disableReactions,
        isOutSite: isOutSite,
        myReaction: display.myReaction,
        id: id,
        themes: themes,
        emojis: display.emojis,
      );
      list.add(container);
    }
    return Wrap(spacing: 6, runSpacing: 6, children: list);
  }
}

class ReactionButton extends ConsumerWidget {
  const ReactionButton({
    super.key,
    required this.item,
    required this.disableReactions,
    required this.isOutSite,
    required this.myReaction,
    required this.id,
    required this.themes,
    required this.emojis,
  });

  final MapEntry<String, int> item;
  final bool disableReactions;
  final bool isOutSite;
  final String? myReaction;
  final String id;
  final ThemeColorModel themes;
  final Map? emojis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HoverBuilder(
      key: ValueKey(item.key),
      builder: (context, isHover) {
        isHover = isHover && !disableReactions;
        return GestureDetector(
          onTap: disableReactions
              ? null
              : () {
                  if (isOutSite) return;

                  if (item.key != myReaction) {
                    ref
                        .read(misskeyApisProvider)
                        .notes
                        .createReactions(noteId: id, reaction: item.key);
                  } else {
                    if (myReaction != null) {
                      ref
                          .read(misskeyApisProvider)
                          .notes
                          .deleteReactions(noteId: id);
                    }
                  }
                },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isOutSite
                  ? themes.fgColor.withValues(alpha: 0.05)
                  : themes.fgColor.withValues(alpha: isHover ? 0.25 : 0.1),
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              border: Border.all(
                color: item.key == myReaction && !disableReactions
                    ? themes.accentedBgColor.withValues(alpha: 0.7)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ReactionsIcon(emojiCode: item.key, emojis: emojis),
                const SizedBox(width: 4),
                Text(item.value.toString()),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ReactionsIcon extends HookConsumerWidget {
  const ReactionsIcon({super.key, required this.emojiCode, this.emojis});

  final String emojiCode;
  final Map? emojis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var emoji = ref.watch(apiEmojisProvider);
    var code = parseString(emojiCode);
    if (code != null) {
      String url = "";
      if (emoji.value?[code] != null) {
        url = emoji.value![code]?.url ?? '';
      }
      if (emojis?[code] != null) {
        url = emojis?[code];
      }
      if (url != "") {
        return SizedBox(
          height: 28,
          child: MkImage(
            url,
            height: 28,
            proxy: const MkImageProxyOptions(type: MkImageProxyType.emoji),
          ),
        );
      } else {
        return Text(code);
      }
    }
    return Twemoji(
      emoji: emojiCode,
      height: 28,
      width: 28,
      twemojiFormat: TwemojiFormat.png,
    );
  }
}

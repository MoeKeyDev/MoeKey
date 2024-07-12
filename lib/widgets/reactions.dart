import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/themes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:twemoji_v2/twemoji_v2.dart';

import '../status/misskey_api.dart';
import 'hover_builder.dart';
import 'mk_image.dart';

String? parseString(String input) {
  RegExp exp = RegExp(r"^:(.*):$");
  Iterable<Match> matches = exp.allMatches(input);
  for (Match m in matches) {
    if (m.group(1) != null) {
      if (m.group(1)!.endsWith("@.")) {
        return m.group(1)!.substring(0, m.group(1)!.length - 2);
      }
      return m.group(1)!;
    }
  }
  return null;
}

class ReactionsListComponent extends HookConsumerWidget {
  const ReactionsListComponent(
      {super.key,
      this.emojis,
      required this.reactionsList,
      required this.id,
      this.disableReactions = false,
      this.myReaction});

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
    // 倒序排序
    for (var item in reactionsList.entries.toList()
      ..sort(
        (a, b) {
          return b.value.compareTo(a.value);
        },
      )) {
      var code = parseString(item.key);
      var isOutSite = false;
      if (code != null && siteEmoji.valueOrNull?[code] == null) {
        isOutSite = true;
      }
      var container = ReactionButton(
          item: item,
          disableReactions: disableReactions,
          isOutSite: isOutSite,
          myReaction: myReaction,
          id: id,
          themes: themes,
          emojis: emojis);
      list.add(container);
    }
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: list,
    );
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
                      ? themes.fgColor.withOpacity(0.05)
                      : themes.fgColor.withOpacity(isHover ? 0.25 : 0.1),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4),
                  ),
                  border: Border.all(
                      color: item.key == myReaction && !disableReactions
                          ? themes.accentedBgColor.withOpacity(0.7)
                          : Colors.transparent,
                      width: 1)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ReactionsIcon(emojiCode: item.key, emojis: emojis),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(item.value.toString())
                ],
              ),
            ),
          );
        });
  }
}

class ReactionsIcon extends HookConsumerWidget {
  const ReactionsIcon({
    super.key,
    required this.emojiCode,
    this.emojis,
  });

  final String emojiCode;
  final Map? emojis;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var emoji = ref.watch(apiEmojisProvider);
    getApplicationDocumentsDirectory();
    var code = parseString(emojiCode);
    if (code != null) {
      String url = "";
      if (emoji.valueOrNull?[code] != null) {
        url = emoji.valueOrNull![code]?.url ?? '';
      }
      if (emojis?[code] != null) {
        url = emojis?[code];
      }
      if (url != "") {
        return SizedBox(
          height: 28,
          child: MkImage(url, height: 28),
        );
      } else {
        return Text(code);
      }
    }
    return Twemoji(
      emoji: emojiCode,
      height: 28,
      width: 28,
    );
  }
}

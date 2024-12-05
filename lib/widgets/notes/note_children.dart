import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/notes/note_card.dart';

import '../../generated/l10n.dart';

class NoteChildren extends HookConsumerWidget {
  const NoteChildren(
      {super.key,
      required this.noteId,
      required this.deep,
      required this.first,
      required this.last,
      this.load});

  final String noteId;
  final int deep;
  final bool first;
  final bool last;
  final void Function(int)? load;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var apis = ref.read(misskeyApisProvider);
    var themes = ref.watch(themeColorsProvider);
    var loaded = useState(false);
    var childCount = useState<Map<int, int>>(<int, int>{});

    //  最大深度限制
    if (deep >= 10) {
      return SliverToBoxAdapter(
        child: Text(S.current.view),
      );
    }
    var circular = const Radius.circular(12);
    var circularZero = const Radius.circular(0);

    var data = apis.notes.children(noteId: noteId);

    return FutureBuilder(
      future: data,
      builder: (context, snapshot) {
        var list = snapshot.data ?? [];
        if (list.isNotEmpty && !loaded.value) {
          Timer.periodic(Duration.zero, (timer) {
            loaded.value = true;
            if (load != null) {
              load!(list.length);
            }
            timer.cancel();
          });
        }

        return SliverMainAxisGroup(
          slivers: [
            for (int i = 0; i < list.length; i++) ...[
              if (deep < 1 && i != 0)
                SliverToBoxAdapter(
                    child: Container(
                  decoration: BoxDecoration(color: themes.dividerColor),
                  height: 1,
                )),
              SliverToBoxAdapter(
                child: MkCard(
                  shadow: false,
                  borderRadius: BorderRadius.only(
                    topLeft: first && i == 0 ? circular : circularZero,
                    topRight: first && i == 0 ? circular : circularZero,
                    bottomLeft: last &&
                            i == (list.length - 1) &&
                            childCount.value[i] == null
                        ? circular
                        : circularZero,
                    bottomRight: last &&
                            i == (list.length - 1) &&
                            childCount.value[i] == null
                        ? circular
                        : circularZero,
                  ),
                  padding: EdgeInsets.only(
                      top: deep < 1 ? 10 : 0,
                      left: 16,
                      right: 16,
                      bottom: childCount.value[i] != null ||
                              (i < (list.length - 1) && deep > 0)
                          ? 0
                          : 10),
                  child: TimeLineNoteCardComponent(
                    data: list[i],
                    reply: childCount.value[i] != null ||
                        (i < (list.length - 1) && deep > 0),
                  ),
                ),
              ),
              NoteChildren(
                noteId: list[i].id,
                deep: deep + 1,
                first: false,
                last: last && i == (list.length - 1),
                load: (count) {
                  var map = Map<int, int>.from(childCount.value);
                  map[i] = count;
                  childCount.value = map;
                },
              ),
            ],
          ],
        );
      },
    );
  }
}

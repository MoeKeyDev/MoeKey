import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/notifications.dart';
import 'package:moekey/utils/get_padding_note.dart';
import 'package:moekey/widgets/mk_refresh_indicator.dart';

import '../../main.dart';
import '../../status/themes.dart';
import '../../widgets/loading_weight.dart';
import '../../widgets/mk_card.dart';
import '../../widgets/notes/note_card.dart';
import '../../widgets/notes/note_pagination_list.dart';

class MentionsList extends HookConsumerWidget {
  const MentionsList({
    super.key,
    this.specified = false,
  });

  final bool specified;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var dataProvider = mentionsNotificationsProvider(specified: specified);
    var themes = ref.watch(themeColorsProvider);
    var mediaPadding = MediaQuery.of(context).padding;

    return LayoutBuilder(
      builder: (context, constraints) {
        var padding = getPaddingForNote(constraints);
        return MkRefreshIndicator(
          child: CustomScrollView(
            slivers: [
              SliverPaginationNoteList(
                padding:
                    mediaPadding.add(EdgeInsets.symmetric(horizontal: padding)),
                watch: (ref) => ref.watch(dataProvider),
                loadMore: (ref) => ref.read(dataProvider.notifier).loadMore(),
              )
            ],
          ),
          onRefresh: () => ref.refresh(notificationsProvider.future),
        );
      },
    );
  }
}

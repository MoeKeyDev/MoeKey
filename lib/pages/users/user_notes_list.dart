import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/utils/get_padding_note.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_refresh_indicator.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';

import '../../status/user.dart';
import '../../widgets/mk_nav_button.dart';

List<Map<String, bool>> _noteFilter = [
  {
    "withRenotes": false,
    "withChannelNotes": false,
    "withFiles": false,
    "withReplies": false,
    "withFeatured": true,
  },
  {
    "withRenotes": false,
    "withChannelNotes": false,
    "withFiles": false,
    "withReplies": false,
    "withFeatured": false,
  },
  {
    "withRenotes": true,
    "withChannelNotes": true,
    "withFiles": false,
    "withReplies": true,
    "withFeatured": false,
  },
  {
    "withRenotes": false,
    "withChannelNotes": false,
    "withFiles": true,
    "withReplies": false,
    "withFeatured": false,
  }
];

class UserNotesPage extends HookConsumerWidget {
  const UserNotesPage({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.paddingOf(context);
    var select = useState(2);
    const navs = ["热门", "帖子", "全部", "附件"];
    var dataProvider = userNotesListProvider(
      userId: userId,
      withRenotes: _noteFilter[select.value]["withRenotes"]!,
      withChannelNotes: _noteFilter[select.value]["withChannelNotes"]!,
      withFiles: _noteFilter[select.value]["withFiles"]!,
      withReplies: _noteFilter[select.value]["withReplies"]!,
      withFeatured: _noteFilter[select.value]["withFeatured"]!,
      key: 1,
    );
    var data = ref.watch(dataProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        var padding = getPaddingForNote(constraints);
        return Stack(
          children: [
            MkPaginationNoteList(
              padding: const EdgeInsets.only(top: 50),
              onLoad: () => ref.read(dataProvider.notifier).load(),
              onRefresh: () => ref.refresh(dataProvider.future),
              hasMore: data.valueOrNull?.hasMore,
              items: data.valueOrNull?.list,
            ),
            Positioned(
              top: mediaPadding.top - 8,
              left: 0,
              right: 0,
              child: MediaQuery(
                data: const MediaQueryData(padding: EdgeInsets.zero),
                child: MkToolBar(
                  height: 50,
                  border: 0,
                  // color: themes.bgColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: MkNavButtonBar(
                      index: select.value,
                      onSelect: (index) => select.value = index,
                      navs: navs,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/utils/get_padding_note.dart';
import 'package:moekey/widgets/mk_refresh_indicator.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';

import '../../status/user.dart';

class UserReactionsPage extends HookConsumerWidget {
  const UserReactionsPage({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.paddingOf(context);
    var dataProvider = userReactionsListProvider(
      userId: userId,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        double padding = getPaddingForNote(constraints);
        return MkRefreshIndicator(
          child: CustomScrollView(
            slivers: [
              SliverPaginationNoteList(
                padding:
                    mediaPadding.add(EdgeInsets.symmetric(horizontal: padding)),
                watch: (ref) => ref.watch(dataProvider),
                loadMore: (ref) => ref.read(dataProvider.notifier).load(),
              )
            ],
          ),
          onRefresh: () => ref.refresh(dataProvider.future),
        );
      },
    );
  }
}

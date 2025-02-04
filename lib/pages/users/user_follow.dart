import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/pages/users/user_page.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/widgets/loading_weight.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_refresh_load.dart';
import 'package:moekey/widgets/mk_scaffold.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../generated/l10n.dart';
import '../../status/user.dart';
import '../../widgets/mk_user_card.dart';

part 'user_follow.g.dart';

class UserFollowPage extends HookConsumerWidget {
  const UserFollowPage({
    super.key,
    this.username,
    this.host,
    this.userId,
    this.type = "following",
  });

  final String? username;
  final String? host;
  final String? userId;
  final String type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userProvider =
        userInfoProvider(username: username, host: host, userId: userId);
    var user = ref.watch(userProvider);

    return MkScaffold(
      body: user.valueOrNull != null
          ? UserFollowList(
              userId: user.valueOrNull!.id,
              type: type,
            )
          : const LoadingWidget(),
      header: MkAppbar(
        showBack: true,
        leading: AppBarUserTitle(
          user: user.valueOrNull,
          text: type == "following" ? S.current.following : S.current.followers,
        ),
      ),
    );
  }
}

class UserFollowList extends HookConsumerWidget {
  const UserFollowList({
    super.key,
    required this.userId,
    required this.type,
  });

  final String userId;
  final String type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = userFollowProvider(userId: userId, type: type);
    var follow = ref.watch(provider);
    return LayoutBuilder(
      builder: (context, constraints) {
        var maxWidth = 1200;
        double paddingH =
            ((constraints.maxWidth - maxWidth) / 2).clamp(24, double.infinity);
        double maxCrossAxisExtent = constraints.maxWidth < 580 ? 600 : 350;
        return MkRefreshLoadList(
          onLoad: () => ref.read(provider.notifier).load(),
          onRefresh: () => ref.refresh(provider.future),
          hasMore: follow.valueOrNull?.hasMore,
          padding: EdgeInsets.symmetric(horizontal: paddingH),
          slivers: [
            SliverGrid.builder(
              itemBuilder: (context, index) {
                return MkUserCard(user: follow.valueOrNull!.list[index]);
              },

              itemCount: follow.valueOrNull?.list.length ?? 0,
              // maxCrossAxisExtent: maxCrossAxisExtent,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: maxCrossAxisExtent,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 300),
            )
          ],
          empty: follow.valueOrNull?.list.isEmpty,
        );
      },
    );
  }
}

@riverpod
class UserFollow extends _$UserFollow {
  @override
  FutureOr<MkLoadMoreListModel<UserFullModel>> build({
    required String userId,
    String type = "following",
  }) async {
    return MkLoadMoreListModel();
  }

  String? untilId;

  Future<List<UserFullModel>> follow() async {
    var api = ref.read(misskeyApisProvider);
    var list = await api.user
        .follow(userId: userId, type: type, untilId: untilId, limit: 20);
    if (list.isEmpty) return [];
    untilId = list.last.id;
    return List<UserFullModel>.from(list.map(
      (e) => e.followee ?? e.follower!,
    ));
  }

  var loading = false;

  load() async {
    if (loading) return;
    if (!(state.value?.hasMore ?? true)) return;
    loading = true;
    try {
      List<UserFullModel> notesList;
      notesList = await follow();

      var model = MkLoadMoreListModel<UserFullModel>();
      model.list = (state.valueOrNull?.list ?? []) + notesList;
      if (notesList.isEmpty || notesList.length < 20) {
        model.hasMore = false;
      }
      state = AsyncData(model);
    } finally {
      loading = false;
    }
  }
}

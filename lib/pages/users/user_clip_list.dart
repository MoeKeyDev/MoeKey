import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:implicitly_animated_reorderable_list_2/implicitly_animated_reorderable_list_2.dart';
import 'package:implicitly_animated_reorderable_list_2/transitions.dart';
import 'package:moekey/apis/models/clips.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/widgets/mk_refresh_loading_empty_wrapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../widgets/clips/clips_folder.dart';
import '../../widgets/loading_weight.dart';

part 'user_clip_list.g.dart';

class ClipsModelListsModel {
  List<ClipsModel> list = [];
  bool hasMore = true;
}

@riverpod
class UserClipListState extends _$UserClipListState {
  @override
  FutureOr<ClipsModelListsModel> build({required String userId}) async {
    var model = ClipsModelListsModel();

    return model;
  }

  Future<List<ClipsModel>> clips(String? untilId) async {
    var apis = ref.read(misskeyApisProvider);
    return apis.user.clips(userId: userId, untilId: untilId);
  }

  bool loading = false;

  loadMore() async {
    if (loading) return;
    loading = true;

    try {
      String? untilId = state.value?.list.lastOrNull?.id;
      var res = await clips(untilId);
      if (res.isEmpty) {
        state.valueOrNull?.hasMore = false;
      }
      state.valueOrNull!.list += res;
      state = AsyncData(state.valueOrNull!);
    } finally {
      loading = false;
    }
  }
}

class UserClipList extends HookConsumerWidget {
  const UserClipList({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = userClipListStateProvider(userId: userId);
    var data = ref.watch(provider);
    return MkRefreshLoadingEmptyBuilder(
      onRefresh: () => ref.refresh(provider.future),
      loading: data.isLoading,
      empty: data.valueOrNull?.list.isEmpty ?? true,
      builder: (context, constraints) {
        return CustomScrollView(
          slivers: [
            SliverImplicitlyAnimatedList<ClipsModel>(
              items: data.valueOrNull?.list ?? [],
              itemBuilder: (BuildContext context, Animation<double> animation,
                  item, int i) {
                return SizeFadeTransition(
                  animation: animation,
                  child: Column(
                    children: [
                      ClipsFolder(
                        data: item,
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                );
              },
              areItemsTheSame: (oldItem, newItem) {
                return oldItem.id == newItem.id;
              },
            ),
            SliverLayoutBuilder(
              builder: (context, constraints) {
                if (data.valueOrNull?.hasMore ?? true) {
                  if (constraints.remainingPaintExtent > 0) {
                    ref.read(provider.notifier).loadMore();
                  }
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: LoadingCircularProgress(),
                      ),
                    ),
                  );
                }
                return const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 16,
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }
}

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
  Object? loadMoreError;
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

  Future<void> loadMore() async {
    if (loading) return;
    loading = true;
    final model = state.value;
    if (model == null) {
      loading = false;
      return;
    }

    model.loadMoreError = null;
    ref.notifyListeners();
    try {
      String? untilId = model.list.lastOrNull?.id;
      var res = await clips(untilId);
      if (res.isEmpty) {
        model.hasMore = false;
      }
      model.list += res;
      state = AsyncData(model);
    } catch (error) {
      model.loadMoreError = error;
    } finally {
      loading = false;
      state = AsyncData(model);
      ref.notifyListeners();
    }
  }
}

class UserClipList extends HookConsumerWidget {
  const UserClipList({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = userClipListStateProvider(userId: userId);
    var data = ref.watch(provider);
    return MkRefreshLoadingEmptyBuilder(
      onRefresh: () => ref.refresh(provider.future),
      loading: data.isLoading,
      empty: data.value?.list.isEmpty ?? true,
      error: data.hasError && data.value == null ? data.error : null,
      onRetry: () => ref.invalidate(provider),
      builder: (context, constraints) {
        return CustomScrollView(
          slivers: [
            SliverImplicitlyAnimatedList<ClipsModel>(
              items: data.value?.list ?? [],
              itemBuilder:
                  (
                    BuildContext context,
                    Animation<double> animation,
                    item,
                    int i,
                  ) {
                    return SizeFadeTransition(
                      animation: animation,
                      child: Column(
                        children: [
                          ClipsFolder(data: item),
                          const SizedBox(height: 10),
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
                if (data.value?.loadMoreError != null) {
                  return SliverToBoxAdapter(
                    child: MkErrorState(
                      compact: true,
                      onRetry: () => ref.read(provider.notifier).loadMore(),
                    ),
                  );
                }
                if (data.value?.hasMore ?? true) {
                  if (constraints.remainingPaintExtent > 0) {
                    ref.read(provider.notifier).loadMore();
                  }
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: LoadingCircularProgress()),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox(height: 16));
              },
            ),
          ],
        );
      },
    );
  }
}

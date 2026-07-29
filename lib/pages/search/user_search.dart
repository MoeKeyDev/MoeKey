import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/pages/search/search_filter.dart';
import 'package:moekey/utils/get_padding_note.dart';
import 'package:moekey/widgets/mk_refresh_load.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../logger.dart';
import '../../status/misskey_api.dart';
import '../../widgets/mk_user_card.dart';

part 'user_search.g.dart';

class UserSearchPage extends HookConsumerWidget {
  const UserSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var status = ref.watch(userSearchStatusProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        var horizontalPadding = getPaddingForNote(
          constraints,
        ).clamp(8, double.infinity).toDouble();
        var padding = EdgeInsets.fromLTRB(
          horizontalPadding,
          16,
          horizontalPadding,
          0,
        );

        double maxCrossAxisExtent = constraints.maxWidth < 580 ? 600 : 350;
        return MkRefreshLoadList(
          onLoad: () => ref.read(userSearchStatusProvider.notifier).load(),
          onRefresh: () => ref.read(userSearchStatusProvider.notifier).search(),
          slivers: [
            // 用户卡片Grid
            SliverGrid.builder(
              itemBuilder: (context, index) {
                return MkUserCard(user: status.data[index]);
              },

              itemCount: status.data.length,
              // maxCrossAxisExtent: maxCrossAxisExtent,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: maxCrossAxisExtent,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                mainAxisExtent: 300,
              ),
            ),
          ],
          hasMore: status.searched && status.hasMore,
          empty: status.data.isEmpty,
          padding: padding,
          initialLoading:
              status.loading &&
              status.searched &&
              status.data.isEmpty &&
              status.initialError == null,
          initialError: status.initialError,
          onRetry: () => ref.read(userSearchStatusProvider.notifier).search(),
          loadMoreError: status.loadMoreError,
          onRetryLoadMore: () =>
              ref.read(userSearchStatusProvider.notifier).load(),
        );
      },
    );
  }
}

class UserSearchStatusModel {
  List<UserFullModel> data = [];
  String searchValue = "";
  bool loading = false;
  bool searched = false;
  bool hasMore = true;
  Object? initialError;
  Object? loadMoreError;
}

@riverpod
class UserSearchStatus extends _$UserSearchStatus {
  @override
  UserSearchStatusModel build() {
    return UserSearchStatusModel();
  }

  void updateSearchValue(String searchValue) {
    state.searchValue = searchValue;
    ref.notifyListeners();
  }

  Future<void> search() async {
    if (state.loading) return;
    final query = state.searchValue.trim();
    if (query.isEmpty) {
      state.searched = false;
      state.hasMore = false;
      state.data = [];
      state.initialError = null;
      state.loadMoreError = null;
      ref.notifyListeners();
      return;
    }
    state.loading = true;
    state.searched = true;
    state.hasMore = true;
    state.data = [];
    state.initialError = null;
    state.loadMoreError = null;
    ref.notifyListeners();
    try {
      final filter = ref.read(searchFilterProvider);
      final origin = switch (filter.scope) {
        SearchFilterScope.local => "local",
        SearchFilterScope.remote => "remote",
        _ => "combined",
      };
      final data = await ref
          .read(misskeyApisProvider)
          .user
          .search(query: query, origin: origin);
      state.data = data;
      state.hasMore = data.isNotEmpty;
    } catch (error, stackTrace) {
      logger.e(stackTrace);
      state.initialError = error;
      state.hasMore = false;
    }
    state.loading = false;
    ref.notifyListeners();
  }

  Future<void> load() async {
    if (!state.searched ||
        state.loading ||
        !state.hasMore ||
        state.data.isEmpty) {
      return;
    }
    final filter = ref.read(searchFilterProvider);
    state.loading = true;
    state.loadMoreError = null;
    ref.notifyListeners();
    try {
      final origin = switch (filter.scope) {
        SearchFilterScope.local => "local",
        SearchFilterScope.remote => "remote",
        _ => "combined",
      };
      var data = await ref
          .read(misskeyApisProvider)
          .user
          .search(
            query: state.searchValue,
            origin: origin,
            offset: state.data.length,
            limit: 30,
          );
      // 根据id过滤重复数据
      // misskey搜索接口的bug 虽然有分页接口但是依然会返回重复的数据
      data = data.where((element) {
        return !state.data.any((element2) => element2.id == element.id);
      }).toList();
      state.data += data;
      state.hasMore = data.isNotEmpty;
    } catch (error, stackTrace) {
      logger.e(stackTrace);
      state.loadMoreError = error;
    }
    state.loading = false;
    ref.notifyListeners();
  }
}

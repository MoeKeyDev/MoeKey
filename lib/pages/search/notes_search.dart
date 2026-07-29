import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/logger.dart';
import 'package:moekey/pages/search/search_filter.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notes_search.g.dart';

class NotesSearchPage extends HookConsumerWidget {
  const NotesSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var status = ref.watch(notesSearchStatusProvider);
    return MkPaginationNoteList(
      onLoad: () => ref.read(notesSearchStatusProvider.notifier).load(),
      onRefresh: () => ref.read(notesSearchStatusProvider.notifier).search(),
      hasMore: status.searched && status.hasMore,
      items: status.data,
      padding: const EdgeInsets.only(top: 8),
      initialLoading:
          status.loading &&
          status.searched &&
          status.data.isEmpty &&
          status.initialError == null,
      initialError: status.initialError,
      onRetry: () => ref.read(notesSearchStatusProvider.notifier).search(),
      loadMoreError: status.loadMoreError,
      onRetryLoadMore: () =>
          ref.read(notesSearchStatusProvider.notifier).load(),
    );
  }
}

class NotesSearchStatusModel {
  List<NoteModel> data = [];
  String searchValue = "";
  bool loading = false;
  bool searched = false;
  bool hasMore = true;
  Object? initialError;
  Object? loadMoreError;
}

@riverpod
class NotesSearchStatus extends _$NotesSearchStatus {
  @override
  NotesSearchStatusModel build() {
    return NotesSearchStatusModel();
  }

  void updateSearchValue(String searchValue) {
    state.searchValue = searchValue;
    ref.notifyListeners();
  }

  String? _searchHost(SearchFilterModel filter) {
    String? host;
    if (filter.scope == SearchFilterScope.local) {
      return ".";
    }
    if (filter.scope == SearchFilterScope.host) {
      host = filter.host.trim();
      final uri = Uri.tryParse(host);
      if (uri != null && uri.hasScheme && uri.host.isNotEmpty) {
        host = uri.host;
      }
    } else if (filter.scope == SearchFilterScope.user) {
      host = filter.user?.host ?? ".";
    }
    if (host == null || host.isEmpty) {
      return null;
    }
    final localHost = Uri.tryParse(
      ref.read(misskeyApisProvider).instance,
    )?.host;
    return host == localHost ? "." : host;
  }

  Future<List<NoteModel>> _request({required String query, String? untilId}) {
    final filter = ref.read(searchFilterProvider);
    return ref
        .read(misskeyApisProvider)
        .notes
        .search(
          query: query,
          untilId: untilId,
          host: _searchHost(filter),
          userId: filter.scope == SearchFilterScope.user
              ? filter.user?.id
              : null,
          rangeStartAt: filter.rangeStartAt?.millisecondsSinceEpoch,
          rangeEndAt: filter.rangeEndAt?.millisecondsSinceEpoch,
        );
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
      final data = await _request(query: query);
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
    state.loading = true;
    state.loadMoreError = null;
    ref.notifyListeners();
    try {
      final data = await _request(
        query: state.searchValue,
        untilId: state.data.lastOrNull?.id,
      );
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

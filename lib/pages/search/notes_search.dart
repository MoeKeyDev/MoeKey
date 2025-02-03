import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/logger.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/mk_input.dart';
import 'package:moekey/widgets/notes/note_pagination_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../generated/l10n.dart';

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
      slivers: const [
        SliverToBoxAdapter(
          child: NotesSearchPanel(),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 8))
      ],
    );
  }
}

class NotesSearchPanel extends HookConsumerWidget {
  const NotesSearchPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var status = ref.watch(notesSearchStatusProvider);
    var widgetStateProperty = WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return themes.accentColor;
        }
        return themes.fgColor;
      },
    );
    return MkCard(
        shadow: false,
        child: Column(
          children: [
            MkInput(
              prefixIcon: const Icon(TablerIcons.search),
              value: status.searchValue,
              onChanged: ref
                  .read(notesSearchStatusProvider.notifier)
                  .updateSearchValue,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Radio(
                  value: 1,
                  groupValue: status.serverType,
                  fillColor: widgetStateProperty,
                  onChanged: (value) => ref
                      .read(notesSearchStatusProvider.notifier)
                      .updateServerType(value!),
                ),
                Text(S.current.all),
                const SizedBox(width: 8),
                Radio(
                  value: 2,
                  groupValue: status.serverType,
                  fillColor: widgetStateProperty,
                  onChanged: (value) => ref
                      .read(notesSearchStatusProvider.notifier)
                      .updateServerType(value!),
                ),
                Text(S.current.local),
                const SizedBox(width: 8),
                Radio(
                  value: 3,
                  groupValue: status.serverType,
                  fillColor: widgetStateProperty,
                  onChanged: (value) => ref
                      .read(notesSearchStatusProvider.notifier)
                      .updateServerType(value!),
                ),
                Text(S.current.searchHost),
              ],
            ),
            if (status.serverType == 3) ...[
              const SizedBox(height: 16),
              MkInput(
                value: status.hostValue,
                prefixIcon: const Icon(TablerIcons.server),
                onChanged: ref
                    .read(notesSearchStatusProvider.notifier)
                    .updateHostValue,
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(
                onPressed: () =>
                    ref.read(notesSearchStatusProvider.notifier).search(),
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(themes.accentColor),
                    foregroundColor: WidgetStateProperty.all(themes.panelColor),
                    elevation: WidgetStateProperty.all(0)),
                child: Text("   ${S.current.search}   "))
          ],
        ));
  }
}

class NotesSearchStatusModel {
  List<NoteModel> data = [];
  int serverType = 1;
  String searchValue = "";
  String hostValue = "";
  bool loading = false;
  bool searched = false;
  bool hasMore = true;
}

@riverpod
class NotesSearchStatus extends _$NotesSearchStatus {
  @override
  NotesSearchStatusModel build() {
    return NotesSearchStatusModel();
  }

  updateSearchValue(String searchValue) {
    state.searchValue = searchValue;
    ref.notifyListeners();
  }

  updateHostValue(String hostValue) {
    state.hostValue = hostValue;
    ref.notifyListeners();
  }

  updateServerType(int serverType) {
    state.serverType = serverType;
    ref.notifyListeners();
  }

  search() async {
    if (state.loading) return;
    state.loading = true;
    state.searched = true;
    state.hasMore = true;
    state.data = [];
    ref.notifyListeners();
    try {
      String? host;
      if (state.serverType == 2) {
        host = ".";
      }
      if (state.serverType == 3 && state.hostValue.isNotEmpty) {
        host = state.hostValue;
      }
      var data = await ref.read(misskeyApisProvider).notes.search(
            query: state.searchValue,
            host: host,
          );
      state.data = data;
      state.hasMore = data.isNotEmpty;
    } catch (e) {
      logger.e(e);
    }
    state.loading = false;
    ref.notifyListeners();
  }

  load() async {
    if (state.loading) return;
    state.loading = true;
    try {
      String? host;
      if (state.serverType == 2) {
        host = ".";
      }
      if (state.serverType == 3 && state.hostValue.isNotEmpty) {
        host = state.hostValue;
      }
      var data = await ref.read(misskeyApisProvider).notes.search(
            query: state.searchValue,
            host: host,
            untilId: state.data.lastOrNull?.id,
          );
      state.data += data;
      state.hasMore = data.isNotEmpty;
    } catch (e) {
      logger.e(e);
    }
    state.loading = false;
    ref.notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/pages/search/notes_search.dart';
import 'package:moekey/pages/search/search_filter.dart';
import 'package:moekey/pages/search/search_trends.dart';
import 'package:moekey/pages/search/user_search.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/status/server.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_input.dart';
import 'package:moekey/widgets/mk_modal.dart';
import 'package:moekey/widgets/mk_scaffold.dart';
import 'package:moekey/widgets/mk_tabbar_list.dart';
import 'package:moekey/widgets/mk_user_avatar.dart';
import 'package:moekey/widgets/user_select_dialog/user_select_dialog.dart';

import '../../generated/l10n.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final showingResults = useState(false);
    final showingSearchOverlay = useState(false);

    Future<void> search(int index) {
      if (index == 0) {
        return ref.read(notesSearchStatusProvider.notifier).search();
      }
      return ref.read(userSearchStatusProvider.notifier).search();
    }

    Future<void> submitSearch(_SearchOverlayResult result) async {
      showingSearchOverlay.value = false;
      ref
          .read(notesSearchStatusProvider.notifier)
          .updateSearchValue(result.query);
      ref
          .read(userSearchStatusProvider.notifier)
          .updateSearchValue(result.query);
      ref
          .read(searchFilterProvider.notifier)
          .update(
            scope: result.scope,
            host: result.host,
            rangeStartAt: result.rangeStartAt,
            rangeEndAt: result.rangeEndAt,
            user: result.user,
          );
      showingResults.value = true;
      await search(currentIndex.value);
    }

    void showSearchOverlay() {
      showingSearchOverlay.value = true;
    }

    Widget page;
    if (!showingResults.value) {
      page = MkScaffold(
        header: MkAppbar(
          isSmallLeadingCenter: true,
          content: SearchHeader(
            currentIndex: currentIndex.value,
            onOpenSearch: showSearchOverlay,
          ),
        ),
        body: const SearchTrendsPage(),
      );
    } else {
      page = MkTabBarRefreshScroll(
        alwaysStackHeader: true,
        initIndex: currentIndex.value,
        onIndexUpdate: (index) {
          if (currentIndex.value == index) {
            return;
          }
          currentIndex.value = index;
          final query = index == 0
              ? ref.read(notesSearchStatusProvider).searchValue
              : ref.read(userSearchStatusProvider).searchValue;
          if (query.trim().isNotEmpty) {
            Future.microtask(() => search(index));
          }
        },
        items: [
          MkTabBarItem(
            label: Tab(
              child: Row(
                children: [
                  const Icon(TablerIcons.pencil, size: 14),
                  Text(S.current.notes, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            child: const NotesSearchPage(),
          ),
          MkTabBarItem(
            label: Tab(
              child: Row(
                children: [
                  const Icon(TablerIcons.users, size: 14),
                  Text(S.current.user, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            child: const UserSearchPage(),
          ),
        ],
        content: SearchHeader(
          currentIndex: currentIndex.value,
          onBack: () => showingResults.value = false,
          onOpenSearch: showSearchOverlay,
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        page,
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !showingSearchOverlay.value,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              reverseDuration: const Duration(milliseconds: 150),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  fit: StackFit.expand,
                  children: [...previousChildren, ?currentChild],
                );
              },
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.025),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: showingSearchOverlay.value
                  ? _SearchOverlay(
                      key: const ValueKey('search-overlay-visible'),
                      initialQuery: ref
                          .read(notesSearchStatusProvider)
                          .searchValue,
                      initialFilter: ref.read(searchFilterProvider),
                      searchType: currentIndex.value,
                      onClose: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        showingSearchOverlay.value = false;
                      },
                      onSubmit: submitSearch,
                    )
                  : const SizedBox.shrink(
                      key: ValueKey('search-overlay-hidden'),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchHeader extends ConsumerWidget {
  const SearchHeader({
    super.key,
    required this.currentIndex,
    required this.onOpenSearch,
    this.onBack,
  });

  final int currentIndex;
  final VoidCallback onOpenSearch;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themes = ref.watch(themeColorsProvider);
    final notesStatus = ref.watch(notesSearchStatusProvider);
    final userStatus = ref.watch(userSearchStatusProvider);
    final query = currentIndex == 0
        ? notesStatus.searchValue
        : userStatus.searchValue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          if (onBack != null) ...[
            SizedBox.square(
              dimension: 38,
              child: IconButton(
                key: const ValueKey('search-results-back'),
                onPressed: onBack,
                tooltip: S.current.back,
                padding: EdgeInsets.zero,
                icon: const Icon(TablerIcons.arrow_left, size: 20),
              ),
            ),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Material(
              key: const ValueKey('search-query-field'),
              color: themes.buttonBgColor.withValues(
                alpha: themes.buttonBgColor.a * 0.5,
              ),
              borderRadius: BorderRadius.circular(19),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onOpenSearch,
                child: SizedBox(
                  height: 38,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const Icon(TablerIcons.search, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            query.trim().isEmpty ? S.current.search : query,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              color: query.trim().isEmpty
                                  ? themes.fgColor.withValues(alpha: 0.6)
                                  : themes.fgColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchOverlayResult {
  const _SearchOverlayResult({
    required this.query,
    required this.scope,
    required this.host,
    required this.rangeStartAt,
    required this.rangeEndAt,
    required this.user,
  });

  final String query;
  final SearchFilterScope scope;
  final String host;
  final DateTime? rangeStartAt;
  final DateTime? rangeEndAt;
  final UserFullModel? user;
}

class _SearchOverlay extends HookConsumerWidget {
  const _SearchOverlay({
    super.key,
    required this.initialQuery,
    required this.initialFilter,
    required this.searchType,
    required this.onClose,
    required this.onSubmit,
  });

  final String initialQuery;
  final SearchFilterModel initialFilter;
  final int searchType;
  final VoidCallback onClose;
  final ValueChanged<_SearchOverlayResult> onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = useState(initialQuery);
    final scope = useState(
      searchType == 0
          ? switch (initialFilter.scope) {
              SearchFilterScope.remote => SearchFilterScope.all,
              _ => initialFilter.scope,
            }
          : switch (initialFilter.scope) {
              SearchFilterScope.all ||
              SearchFilterScope.local ||
              SearchFilterScope.remote => initialFilter.scope,
              _ => SearchFilterScope.all,
            },
    );
    final host = useState(initialFilter.host);
    final rangeStartAt = useState(initialFilter.rangeStartAt);
    final rangeEndAt = useState(initialFilter.rangeEndAt);
    final user = useState(initialFilter.user);
    final themes = ref.watch(themeColorsProvider);
    final currentUser = ref.watch(currentLoginUserProvider);

    bool canSubmit() {
      if (query.value.trim().isEmpty) {
        return false;
      }
      if (scope.value == SearchFilterScope.host) {
        return host.value.trim().isNotEmpty;
      }
      if (scope.value == SearchFilterScope.user) {
        return user.value != null;
      }
      return true;
    }

    void submit() {
      final value = query.value.trim();
      final hostValue = host.value.trim();
      if (!canSubmit()) {
        return;
      }
      FocusManager.instance.primaryFocus?.unfocus();
      onSubmit(
        _SearchOverlayResult(
          query: value,
          scope: scope.value,
          host: hostValue,
          rangeStartAt: rangeStartAt.value,
          rangeEndAt: rangeEndAt.value,
          user: user.value,
        ),
      );
    }

    Future<void> selectUser() async {
      final selected = await showModel<Iterable<dynamic>>(
        context: context,
        useRootNavigator: false,
        builder: (context) => const UserSelectDialog(maxSelect: 1),
      );
      if (selected == null || !context.mounted) {
        return;
      }
      final users = selected.whereType<UserFullModel>();
      if (users.isNotEmpty) {
        user.value = users.first;
      }
    }

    return Material(
      key: const ValueKey('search-overlay'),
      color: themes.bgColor,
      child: MkScaffold(
        header: MkAppbar(
          isSmallLeadingCenter: true,
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 38,
                  child: IconButton(
                    key: const ValueKey('search-overlay-close'),
                    onPressed: onClose,
                    tooltip: S.current.cancel,
                    padding: EdgeInsets.zero,
                    icon: const Icon(TablerIcons.x, size: 20),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: MkInput(
                      key: const ValueKey('search-overlay-query-field'),
                      value: query.value,
                      hintText: S.current.search,
                      prefixIcon: const Icon(TablerIcons.search, size: 18),
                      backgroundColor: themes.buttonBgColor.withValues(
                        alpha: themes.buttonBgColor.a * 0.5,
                      ),
                      compact: true,
                      borderRadius: 19,
                      borderless: true,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onChanged: (value) => query.value = value,
                      onSubmitted: (_) => submit(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox.square(
                  dimension: 38,
                  child: IconButton.filled(
                    key: const ValueKey('search-overlay-submit'),
                    onPressed: canSubmit() ? submit : null,
                    tooltip: S.current.search,
                    padding: EdgeInsets.zero,
                    icon: const Icon(TablerIcons.search, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final mediaPadding = MediaQuery.paddingOf(context);
            return ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                mediaPadding.top,
                16,
                mediaPadding.bottom + 24,
              ),
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 768),
                    child: Material(
                      color: themes.panelColor,
                      borderRadius: BorderRadius.circular(12),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(TablerIcons.filter, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  S.current.searchOptions,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            if (searchType == 0) ...[
                              const SizedBox(height: 14),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _SearchDateTimeField(
                                      key: const ValueKey(
                                        'search-overlay-start-date',
                                      ),
                                      label: S.current.searchStartDate,
                                      value: rangeStartAt.value,
                                      onChanged: (value) {
                                        rangeStartAt.value = value;
                                        if (value != null &&
                                            rangeEndAt.value != null &&
                                            value.isAfter(rangeEndAt.value!)) {
                                          rangeEndAt.value = null;
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _SearchDateTimeField(
                                      key: const ValueKey(
                                        'search-overlay-end-date',
                                      ),
                                      label: S.current.searchEndDate,
                                      value: rangeEndAt.value,
                                      onChanged: (value) {
                                        rangeEndAt.value = value;
                                        if (value != null &&
                                            rangeStartAt.value != null &&
                                            value.isBefore(
                                              rangeStartAt.value!,
                                            )) {
                                          rangeStartAt.value = null;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 10),
                            RadioGroup<SearchFilterScope>(
                              groupValue: scope.value,
                              onChanged: (value) {
                                if (value != null) {
                                  scope.value = value;
                                }
                              },
                              child: Wrap(
                                spacing: 4,
                                runSpacing: 0,
                                children: [
                                  SizedBox(
                                    width: 140,
                                    child: RadioListTile<SearchFilterScope>(
                                      key: const ValueKey(
                                        'search-overlay-filter-all',
                                      ),
                                      value: SearchFilterScope.all,
                                      title: Text(S.current.searchAll),
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 140,
                                    child: RadioListTile<SearchFilterScope>(
                                      key: const ValueKey(
                                        'search-overlay-filter-local',
                                      ),
                                      value: SearchFilterScope.local,
                                      title: Text(S.current.searchLocal),
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                  if (searchType == 0)
                                    SizedBox(
                                      width: 140,
                                      child: RadioListTile<SearchFilterScope>(
                                        key: const ValueKey(
                                          'search-overlay-filter-host',
                                        ),
                                        value: SearchFilterScope.host,
                                        title: Text(S.current.searchServer),
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    )
                                  else
                                    SizedBox(
                                      width: 140,
                                      child: RadioListTile<SearchFilterScope>(
                                        key: const ValueKey(
                                          'search-overlay-filter-remote',
                                        ),
                                        value: SearchFilterScope.remote,
                                        title: Text(S.current.searchRemote),
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                  if (searchType == 0)
                                    SizedBox(
                                      width: 140,
                                      child: RadioListTile<SearchFilterScope>(
                                        key: const ValueKey(
                                          'search-overlay-filter-user',
                                        ),
                                        value: SearchFilterScope.user,
                                        title: Text(S.current.searchUser),
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 150),
                              curve: Curves.easeOutCubic,
                              alignment: Alignment.topCenter,
                              child: scope.value == SearchFilterScope.host
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      child: MkInput(
                                        key: const ValueKey(
                                          'search-overlay-host-field',
                                        ),
                                        value: host.value,
                                        hintText: S.current.hostnames,
                                        prefixIcon: const Icon(
                                          TablerIcons.world,
                                          size: 18,
                                        ),
                                        compact: true,
                                        onChanged: (value) =>
                                            host.value = value,
                                        onSubmitted: (_) => submit(),
                                      ),
                                    )
                                  : scope.value == SearchFilterScope.user
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8,
                                        bottom: 8,
                                      ),
                                      child: _SearchUserSelector(
                                        user: user.value,
                                        onSelect: selectUser,
                                        onSelectSelf: currentUser == null
                                            ? null
                                            : () => user.value =
                                                  currentUser.userInfo,
                                        onRemove: () => user.value = null,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SearchUserSelector extends ConsumerWidget {
  const _SearchUserSelector({
    required this.user,
    required this.onSelect,
    required this.onSelectSelf,
    required this.onRemove,
  });

  final UserFullModel? user;
  final Future<void> Function() onSelect;
  final VoidCallback? onSelectSelf;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themes = ref.watch(themeColorsProvider);
    final selectedUser = user;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.current.selectUser, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        if (selectedUser == null)
          Row(
            children: [
              Expanded(
                child: _SearchUserSelectButton(
                  key: const ValueKey('search-overlay-select-user'),
                  icon: TablerIcons.user_plus,
                  label: S.current.selectUser,
                  onTap: onSelect,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 150,
                child: _SearchUserSelectButton(
                  key: const ValueKey('search-overlay-select-self'),
                  icon: TablerIcons.user,
                  label: S.current.selectSelf,
                  onTap: onSelectSelf,
                ),
              ),
            ],
          )
        else
          Material(
            color: themes.buttonBgColor,
            borderRadius: BorderRadius.circular(8),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              key: const ValueKey('search-overlay-select-user'),
              onTap: onSelect,
              child: SizedBox(
                height: 58,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 4),
                  child: Row(
                    children: [
                      MkUserAvatar(
                        size: 38,
                        avatarUrl: selectedUser.avatarUrl,
                        avatarBlurhash: selectedUser.avatarBlurhash,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedUser.name ?? selectedUser.username,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '@${selectedUser.username}${selectedUser.host == null ? '' : '@${selectedUser.host}'}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: themes.fgColor.withValues(alpha: 0.65),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        key: const ValueKey('search-overlay-remove-user'),
                        onPressed: onRemove,
                        tooltip: S.current.clear,
                        icon: Icon(
                          TablerIcons.x,
                          size: 19,
                          color: themes.errorColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SearchUserSelectButton extends ConsumerWidget {
  const _SearchUserSelectButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themes = ref.watch(themeColorsProvider);
    return Material(
      color: themes.buttonBgColor,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 58,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 10),
                Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchDateTimeField extends ConsumerWidget {
  const _SearchDateTimeField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  Future<void> _select(BuildContext context) async {
    final initial = value ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      useRootNavigator: false,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 366)),
    );
    if (date == null || !context.mounted) {
      return;
    }
    final time = await showTimePicker(
      context: context,
      useRootNavigator: false,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) {
      return;
    }
    onChanged(
      DateTime(date.year, date.month, date.day, time.hour, time.minute),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themes = ref.watch(themeColorsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 6),
        Material(
          color: themes.buttonBgColor,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _select(context),
            child: SizedBox(
              height: 42,
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        value == null
                            ? '年 / 月 / 日 --:--'
                            : DateFormat('yyyy/MM/dd HH:mm').format(value!),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: value == null
                              ? themes.fgColor.withValues(alpha: 0.6)
                              : themes.fgColor,
                        ),
                      ),
                    ),
                    if (value != null)
                      IconButton(
                        onPressed: () => onChanged(null),
                        tooltip: S.current.clear,
                        icon: const Icon(TablerIcons.x, size: 16),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(TablerIcons.calendar, size: 17),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

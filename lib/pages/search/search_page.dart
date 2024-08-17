import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/search/notes_search.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/mk_tabbar_list.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return MkTabBarRefreshScroll(
      items: [
        MkTabBarItem(
            label: Tab(
              child: Row(
                children: [
                  Icon(
                    TablerIcons.pencil,
                    size: 14,
                  ),
                  Text("帖子", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            child: NotesSearchPage()),
        MkTabBarItem(
            label: Tab(
              child: Row(
                children: [
                  Icon(
                    TablerIcons.users,
                    size: 14,
                  ),
                  Text("用户", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            child: NotesSearchPage()),
      ],
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              TablerIcons.search,
              size: 18,
              color: themes.fgColor,
            ),
            const SizedBox(
              width: 8,
            ),
            const Text("搜索"),
          ],
        ),
      ),
      offset: 100,
    );
  }
}

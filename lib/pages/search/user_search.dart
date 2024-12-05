import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/utils/get_padding_note.dart';
import 'package:moekey/widgets/mk_refresh_load.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../generated/l10n.dart';
import '../../logger.dart';
import '../../status/misskey_api.dart';
import '../../status/themes.dart';
import '../../widgets/mk_card.dart';
import '../../widgets/mk_input.dart';
import '../../widgets/mk_user_card.dart';

part 'user_search.g.dart';

class UserSearchPage extends HookConsumerWidget {
  const UserSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var status = ref.watch(userSearchStatusProvider);
    return LayoutBuilder(builder: (context, constraints) {
      var padding = EdgeInsets.symmetric(
          horizontal: getPaddingForNote(constraints).clamp(8, double.infinity));

      double maxCrossAxisExtent = constraints.maxWidth < 580 ? 600 : 350;
      return MkRefreshLoadList(
        onLoad: () => ref.read(userSearchStatusProvider.notifier).load(),
        onRefresh: () => ref.read(userSearchStatusProvider.notifier).search(),
        slivers: [
          const SliverToBoxAdapter(
            child: UserSearchPanel(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 16)),
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
                mainAxisExtent: 300),
          )
        ],
        hasMore: status.searched && status.hasMore,
        empty: status.data.isEmpty,
        padding: padding,
      );
    });
  }
}

class UserSearchPanel extends HookConsumerWidget {
  const UserSearchPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var status = ref.watch(userSearchStatusProvider);
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
              initialValue: status.searchValue,
              onChanged:
                  ref.read(userSearchStatusProvider.notifier).updateSearchValue,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Radio(
                  value: "combined",
                  groupValue: status.origin,
                  fillColor: widgetStateProperty,
                  onChanged: (value) => ref
                      .read(userSearchStatusProvider.notifier)
                      .updateOrigin(value!),
                ),
                Text(S.current.searchAll),
                const SizedBox(width: 8),
                Radio(
                  value: "local",
                  groupValue: status.origin,
                  fillColor: widgetStateProperty,
                  onChanged: (value) => ref
                      .read(userSearchStatusProvider.notifier)
                      .updateOrigin(value!),
                ),
                Text(S.current.searchLocal),
                const SizedBox(width: 8),
                Radio(
                  value: "remote",
                  groupValue: status.origin,
                  fillColor: widgetStateProperty,
                  onChanged: (value) => ref
                      .read(userSearchStatusProvider.notifier)
                      .updateOrigin(value!),
                ),
                Text(S.current.searchRemote),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
                onPressed: () =>
                    ref.read(userSearchStatusProvider.notifier).search(),
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

class UserSearchStatusModel {
  List<UserFullModel> data = [];
  String origin = "combined";
  String searchValue = "";
  bool loading = false;
  bool searched = false;
  bool hasMore = true;
}

@riverpod
class UserSearchStatus extends _$UserSearchStatus {
  @override
  UserSearchStatusModel build() {
    return UserSearchStatusModel();
  }

  updateSearchValue(String searchValue) {
    state.searchValue = searchValue;
    ref.notifyListeners();
  }

  updateOrigin(String origin) {
    state.origin = origin;
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
      var data = await ref.read(misskeyApisProvider).user.search(
            query: state.searchValue,
            origin: state.origin,
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
      String? untilId;
      if (state.data.isNotEmpty) {
        untilId = state.data.lastOrNull?.id;
      }
      var data = await ref.read(misskeyApisProvider).user.search(
          query: state.searchValue,
          origin: state.origin,
          untilId: untilId,
          limit: 30);
      // 根据id过滤重复数据
      // misskey搜索接口的bug 虽然有分页接口但是依然会返回重复的数据
      data = data.where((element) {
        return !state.data.any((element2) => element2.id == element.id);
      }).toList();
      state.data += data;
      state.hasMore = data.isNotEmpty;
    } catch (e) {
      logger.e(e);
    }
    state.loading = false;
    ref.notifyListeners();
  }
}

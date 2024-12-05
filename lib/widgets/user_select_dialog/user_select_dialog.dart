import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/widgets/loading_weight.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey/widgets/mk_image.dart';
import 'package:moekey/widgets/mk_modal.dart';
import 'package:moekey/widgets/user_select_dialog/user_select_dialog_state.dart';

import '../../generated/l10n.dart';
import '../../status/themes.dart';
import '../mk_input.dart';

class UserSelectDialog extends HookConsumerWidget {
  const UserSelectDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var userList = ref.watch(userSelectDialogStateProvider);
    var selectList = useState({});

    return MkModal(
      body: buildUserListView(userList, selectList, themes),
      appbar: buildHeader(selectList.value),
      width: 400,
      height: 550,
    );
  }

  SingleChildScrollView buildUserListView(
      AsyncValue<List<UserFullModel>> userList,
      ValueNotifier<Map<dynamic, dynamic>> selectList,
      ThemeColorModel themes) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),
          buildUserQuery(),
          const SizedBox(height: 8),
          for (var item in userList.valueOrNull ?? [])
            GestureDetector(
              onTap: () {
                if (selectList.value.containsKey(item.id)) {
                  selectList.value.remove(item.id);
                } else {
                  selectList.value[item.id] = item;
                }

                selectList.value = Map.from(selectList.value);
              },
              behavior: HitTestBehavior.opaque,
              child: buildUserItem(
                themes,
                item,
                selectList.value.containsKey(
                  item.id,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget buildHeader(Map selectList) {
    return HookConsumer(
      builder: (context, ref, child) {
        var themes = ref.watch(themeColorsProvider);
        var data = ref.watch(userSelectDialogStateProvider);
        return Row(
          children: [
            const SizedBox(
              width: 4,
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                TablerIcons.x,
                size: 18,
                color: themes.fgColor,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Text(S.current.selectUser),
            Text("(${selectList.length})"),
            const Spacer(),
            if (data.isLoading)
              const LoadingCircularProgress(
                size: 18,
                strokeWidth: 4,
              ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(selectList.values);
              },
              icon: Icon(
                TablerIcons.check,
                size: 18,
                color: themes.fgColor,
              ),
            ),
            const SizedBox(
              width: 4,
            ),
          ],
        );
      },
    );
  }

  Widget buildUserQuery() {
    return HookConsumer(
      builder: (context, ref, child) {
        var themes = ref.watch(themeColorsProvider);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: MkInput(
                  label: S.current.username,
                  prefixIcon: Icon(
                    TablerIcons.at,
                    color: themes.fgColor,
                  ),
                  onChanged: (value) {
                    ref
                        .read(userSelectDialogStateProvider.notifier)
                        .search(name: value);
                  },
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: MkInput(
                  label: S.current.hostnames,
                  prefixIcon: Icon(TablerIcons.at, color: themes.fgColor),
                  onChanged: (value) {
                    ref
                        .read(userSelectDialogStateProvider.notifier)
                        .search(host: value);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildUserItem(ThemeColorModel themes, item, isActive) {
    var name = item.name ?? item.name ?? "";
    var color = isActive ? themes.fgOnAccentColor : themes.fgColor;
    var style = TextStyle(color: color);
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: style,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: isActive ? themes.accentColor : themes.panelColor,
        child: Row(
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: MkImage(
                item.avatarUrl ?? "",
                blurHash: item.avatarBlurhash ?? "",
                width: 48,
                height: 48,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: style.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 14),
                      child: MFMText(
                        text: name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        bigEmojiCode: false,
                        feature: const [MFMFeature.emojiCode],
                      )),
                  Builder(
                    builder: (context) {
                      return Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "@${item.username}"),
                            if (item.host != null)
                              TextSpan(
                                  text: "@${item.host}",
                                  style: TextStyle(
                                      color: DefaultTextStyle.of(context)
                                          .style
                                          .color
                                          ?.withOpacity(0.6)))
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

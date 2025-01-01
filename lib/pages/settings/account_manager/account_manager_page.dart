import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/login_user.dart';
import 'package:moekey/widgets/context_menu.dart';
import 'package:moekey/widgets/mk_scaffold.dart';

import '../../../status/server.dart';
import '../../../status/themes.dart';
import '../../../widgets/mk_image.dart';
import '../../home/home_page.dart';

class AccountManagerPage extends HookConsumerWidget {
  const AccountManagerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var list = ref.watch(loginUserListProvider);
    var user = ref.watch(currentLoginUserProvider);
    var theme = ref.watch(themeColorsProvider);
    return MkScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilledButton(
                    onPressed: () {
                      showServerListDialog(context);
                    },
                    child: Row(
                      spacing: 8,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(TablerIcons.plus),
                        Text("Add Account"),
                      ],
                    )),
                for (var item in list.values)
                  ContextMenuBuilder(
                    menu: ContextMenuCard(
                      menuListBuilder: () async {
                        return [
                          if (item.userInfo.id != user?.userInfo.id)
                            ContextMenuItem(
                              icon: TablerIcons.user_check,
                              label: "切换到此账户",
                              onTap: () {
                                ref
                                    .read(currentLoginUserProvider.notifier)
                                    .setLoginUser(item.id);
                                return false;
                              },
                            ),
                          ContextMenuItem(
                            icon: TablerIcons.user,
                            label: "账户信息",
                            onTap: () {
                              context.push(
                                  "/user/${Uri.parse(item.serverUrl).host}/${item.userInfo.username}");
                              return false;
                            },
                          ),
                          ContextMenuItem(
                            icon: TablerIcons.trash,
                            label: "删除账户",
                            danger: true,
                            onTap: () {
                              // 如果删除的是当前登录用户，切换到第一个账户
                              if (item.userInfo.id == user?.userInfo.id) {
                                // 如果列表中只有一个账户，跳转登录
                                if (list.length == 1) {
                                  ref
                                      .read(currentLoginUserProvider.notifier)
                                      .setLoginUser(list.keys.first);
                                  // 退出app
                                  exit(0);
                                } else {
                                  ref
                                      .read(currentLoginUserProvider.notifier)
                                      .setLoginUser(list.keys.first);
                                }
                              }
                              ref
                                  .read(loginUserListProvider.notifier)
                                  .removeUser(item.id);
                              return false;
                            },
                          ),
                        ];
                      },
                    ),
                    child: _UserItem(item: item, user: user, theme: theme),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserItem extends StatelessWidget {
  const _UserItem({
    super.key,
    required this.item,
    required this.user,
    required this.theme,
  });

  final LoginUser item;
  final LoginUser? user;
  final ThemeColorModel theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: theme.panelColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTapUp: (details) {
          ContextMenuBuilder.show(context, details);
        },
        borderRadius: BorderRadius.circular(12),
        hoverColor: theme.panelColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: MkImage(item.userInfo.avatarUrl ?? "",
                    shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.userInfo.name ?? ""),
                    Text(
                      "@${item.userInfo.username}@${Uri.parse(item.serverUrl).host}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (item.userInfo.id == user?.userInfo.id)
                Icon(
                  TablerIcons.check,
                  color: theme.accentColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

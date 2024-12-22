import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/user_full.dart';
import 'package:moekey/pages/users/user_clip_list.dart';
import 'package:moekey/pages/users/user_notes_list.dart';
import 'package:moekey/pages/users/user_overview.dart';
import 'package:moekey/pages/users/user_reactions_list.dart';
import 'package:moekey/status/user.dart';
import 'package:moekey/widgets/loading_weight.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_image.dart';
import 'package:moekey/widgets/mk_scaffold.dart';
import 'package:moekey/widgets/mk_tabbar_list.dart';

import '../../generated/l10n.dart';
import '../../status/server.dart';
import '../../status/themes.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({
    super.key,
    this.username,
    this.host,
    this.userId,
  });

  final String? username;
  final String? host;
  final String? userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userProvider =
        userInfoProvider(username: username, host: host, userId: this.userId);

    var loginUser = ref.watch(currentLoginUserProvider);
    var user = ref.watch(userProvider);
    if (user.isLoading) {
      return MkScaffold(
          body: const LoadingWidget(),
          header: MkAppbar(
            showBack: true,
          ));
    }
    // 错误处理
    if (user.hasError) {
      return MkScaffold(
          body: GestureDetector(
            onTap: () => ref.invalidate(userProvider),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    user.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    user.stackTrace.toString(),
                    textAlign: TextAlign.center,
                  ),
                  const Text("Click retry")
                ],
              ),
            ),
          ),
          header: MkAppbar(
            showBack: true,
          ));
    }
    var userData = user.valueOrNull;
    var userId = userData!.id;
    return LayoutBuilder(builder: (context, constraints) {
      return MkTabBarRefreshScroll(
        items: [
          MkTabBarItem(
            label: Tab(
              child: Row(
                children: [
                  const Icon(
                    TablerIcons.home,
                    size: 14,
                  ),
                  Text(S.current.overviews,
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            child: UserOverview(userId: userId),
          ),
          MkTabBarItem(
            label: Tab(
              child: Row(
                children: [
                  const Icon(
                    TablerIcons.pencil,
                    size: 14,
                  ),
                  Text(S.current.notes, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            child: UserNotesPage(userId: userId),
          ),
          if (userData.publicReactions || userData.id == loginUser?.id)
            MkTabBarItem(
              label: Tab(
                child: Row(
                  children: [
                    const Icon(
                      TablerIcons.mood_happy,
                      size: 14,
                    ),
                    Text(S.current.reaction,
                        style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              child: UserReactionsPage(userId: userId),
            ),
          MkTabBarItem(
            label: Tab(
              child: Row(
                children: [
                  const Icon(
                    TablerIcons.paperclip,
                    size: 14,
                  ),
                  Text(S.current.clips, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            child: UserClipList(userId: userId),
          ),
        ],
        showBack: true,
        tabAlignment: constraints.maxWidth > 500
            ? TabAlignment.start
            : TabAlignment.center,
        leading: AppBarUserTitle(user: userData),
      );
    });
  }
}

class AppBarUserTitle extends HookConsumerWidget {
  const AppBarUserTitle({super.key, required this.user, this.text});

  final UserFullModel? user;
  final String? text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textStyle = DefaultTextStyle.of(context).style;
    var themes = ref.watch(themeColorsProvider);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (user != null) ...[
          SizedBox(
            width: 32,
            height: 32,
            child: MkImage(
              user?.avatarUrl ?? "",
              width: 32,
              height: 32,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          ConstrainedBox(
            constraints: BoxConstraints.loose(const Size.fromWidth(200)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: DefaultTextStyle.of(context)
                      .style
                      .copyWith(fontWeight: FontWeight.bold),
                  child: MFMText(
                    text: user?.name ?? user?.username ?? "",
                    emojis: user?.emojis,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    bigEmojiCode: false,
                    feature: const [MFMFeature.emojiCode],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      if (text != null)
                        TextSpan(
                            text: "$text",
                            style: textStyle.copyWith(
                                fontSize: 12,
                                color: themes.fgColor.withAlpha(179)))
                      else ...[
                        TextSpan(
                            text: "@${user?.username}",
                            style: textStyle.copyWith(
                                fontSize: 12,
                                color: themes.fgColor.withAlpha(179))),
                        TextSpan(
                          text: user?.host != null ? "@${user?.host}" : "",
                          style: textStyle.copyWith(
                              color: themes.fgColor.withAlpha(89),
                              fontSize: 12),
                        ),
                      ]
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
          const SizedBox(
            width: 16,
          )
        ]
      ],
    );
  }
}

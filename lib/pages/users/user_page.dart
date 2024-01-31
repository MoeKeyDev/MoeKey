import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/networks/user.dart';
import 'package:moekey/pages/users/user_overview.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_image.dart';
import 'package:moekey/widgets/mk_scaffold.dart';

import '../../main.dart';
import '../../state/themes.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({
    super.key,
    required this.userId,
  });
  final String userId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var padding = MediaQuery.paddingOf(context);
    var themes = ref.watch(themeColorsProvider);
    var tabController = useTabController(initialLength: 3);
    var user = ref.watch(userInfoProvider(userId: userId));
    var userData = user.valueOrNull;
    logger.d(user);
    var tabs = const [
      Tab(
        child: Row(
          children: [
            Icon(
              TablerIcons.home,
              size: 14,
            ),
            Text("概览", style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      Tab(
        child: Row(
          children: [
            Icon(TablerIcons.mood_happy, size: 14),
            Text("回应", style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
      Tab(
        child: Row(
          children: [
            Icon(TablerIcons.chart_line, size: 14),
            Text("活动", style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    ];
    var textStyle = DefaultTextStyle.of(context).style;
    return LayoutBuilder(
      builder: (context, constraints) {
        return MkScaffold(
            body: TabBarView(
              controller: tabController,
              children: [
                UserOverview(userId: userId),
                Text("data"),
                Text("data"),
              ],
            ),
            header: MkAppbar(
              showBack: true,
              isSmallLeadingCenter: constraints.maxWidth < 500,
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (user.valueOrNull != null) ...[
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: MkImage(
                        userData?.avatarUrl ?? "",
                        width: 32,
                        height: 32,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.loose(Size.fromWidth(200)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultTextStyle(
                            style: DefaultTextStyle.of(context)
                                .style
                                .copyWith(fontWeight: FontWeight.bold),
                            child: MFMText(
                              text: userData?.name ?? userData?.username ?? "",
                              emojis: userData?.emojis,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              bigEmojiCode: false,
                              feature: const [MFMFeature.emojiCode],
                            ),
                          ),
                          DefaultTextStyle(
                            style: DefaultTextStyle.of(context)
                                .style
                                .copyWith(fontSize: 12),
                            child: Opacity(
                              opacity: 0.7,
                              child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "@${userData?.username ?? ""}",
                                          style:
                                              textStyle.copyWith(fontSize: 12)),
                                      TextSpan(
                                        text: userData?.host != null
                                            ? "@${userData?.host}"
                                            : "",
                                        style: textStyle.copyWith(
                                            color:
                                                themes.fgColor.withAlpha(128),
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    )
                  ]
                ],
              ),
              bottom: user.valueOrNull != null
                  ? MkTabBar(
                      controller: tabController,
                      tabs: tabs,
                      tabAlignment: constraints.maxWidth < 500
                          ? TabAlignment.center
                          : TabAlignment.start,
                    )
                  : null,
            ));
      },
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/notifications.dart';
import 'package:moekey/pages/notes/note_page.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/notifications/notifications_user_card.dart';

import '../../apis/models/notification.dart';
import '../../router/main_router_delegate.dart';
import '../../utils/get_padding_note.dart';
import '../../widgets/loading_weight.dart';
import '../../widgets/mk_image.dart';
import '../../widgets/notes/note_card.dart';
import '../../widgets/reactions.dart';
import '../users/user_page.dart';

class NotificationsGroupList extends HookConsumerWidget {
  NotificationsGroupList({super.key});

  static openUser(BuildContext context, String userId) {
    MainRouterDelegate.of(context).setNewRoutePath(RouterItem(
      path: "user/$userId",
      page: () {
        return UserPage(userId: userId);
      },
    ));
  }

  static openNote(BuildContext context, String noteId) {
    MainRouterDelegate.of(context).setNewRoutePath(RouterItem(
      path: "user/$noteId",
      page: () {
        return NotesPage(noteId: noteId);
      },
    ));
  }

  final Map<
      NotificationType,
      Widget Function(NotificationModel data, BorderRadius borderRadius,
          ThemeColorModel themes)> widgetList = {
    NotificationType.follow: (data, borderRadius, themes) =>
        NotificationsUserCard(
          data: data,
          borderRadius: borderRadius,
          content: const Text("你有新的关注者"),
          avatarBadge: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 54, 174, 210),
              boxShadow: [
                BoxShadow(color: themes.panelColor, spreadRadius: 3),
              ],
            ),
            child: const Icon(
              TablerIcons.plus,
              size: 15,
              color: Colors.white,
            ),
          ),
          onTap: (context) {
            openUser(context, data.user!.id);
          },
        ),
    NotificationType.followRequestAccepted: (data, borderRadius, themes) =>
        NotificationsUserCard(
          data: data,
          borderRadius: borderRadius,
          content: const Text("你的关注请求被通过了"),
          avatarBadge: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 54, 174, 210),
              boxShadow: [
                BoxShadow(color: themes.panelColor, spreadRadius: 3),
              ],
            ),
            child: const Icon(
              TablerIcons.check,
              size: 15,
              color: Colors.white,
            ),
          ),
          onTap: (context) {
            openUser(context, data.user!.id);
          },
        ),
    NotificationType.reaction: (data, borderRadius, themes) =>
        NotificationsUserCard(
          data: data,
          borderRadius: borderRadius,
          content: MFMText(
            text: "${data.note?.cw ?? ""}${data.note?.text ?? ""}"
                .replaceAll('\n', ' '),
            bigEmojiCode: false,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            currentServerHost: data.note?.user.host,
          ),
          avatarBadge: Container(
            decoration:
                BoxDecoration(color: themes.panelColor, shape: BoxShape.circle),
            padding: const EdgeInsets.all(3),
            child: SizedBox(
              width: 20,
              height: 20,
              child: ReactionsIcon(
                  emojiCode: data.reaction!, emojis: data.note?.reactionEmojis),
            ),
          ),
          onTap: (context) {
            openNote(context, data.note!.id);
          },
        ),
    NotificationType.reactionGrouped: (data, borderRadius, themes) =>
        NotificationsUserCard(
          data: data,
          borderRadius: borderRadius,
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var item in data.reactions ?? [])
                Builder(builder: (context) {
                  return GestureDetector(
                    child: SizedBox(
                      width: 38,
                      height: 38,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          MkImage(
                            item.user.avatarUrl ?? "",
                            shape: BoxShape.circle,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: themes.panelColor,
                                  shape: BoxShape.circle),
                              padding: const EdgeInsets.all(3),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: ReactionsIcon(
                                    emojiCode: item.reaction,
                                    emojis: data.note?.reactionEmojis),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      if (item?.user?.id != null) {
                        openUser(context, item.user.id);
                      }
                    },
                  );
                }),
            ],
          ),
          name: MFMText(
            text: ((data.note?.cw ?? "") + (data.note?.text ?? ""))
                .replaceAll('\n', ' '),
            bigEmojiCode: false,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            currentServerHost: data.note?.user.host,
          ),
          avatar: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 233, 154, 11),
                shape: BoxShape.circle),
            child: const Icon(
              TablerIcons.plus,
              size: 28,
              color: Colors.white,
            ),
          ),
          onTap: (context) {
            openNote(context, data.note!.id);
          },
        ),
    NotificationType.reply: (data, borderRadius, themes) => NoteCard(
          data: data.note!,
          borderRadius: borderRadius,
        ),
    NotificationType.renote: (data, borderRadius, themes) =>
        NotificationsUserCard(
          data: data,
          borderRadius: borderRadius,
          content: MFMText(
            text: data.note?.renote?.text ?? "",
            bigEmojiCode: false,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            currentServerHost: data.note?.user.host,
          ),
          avatarBadge: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 54, 210, 152),
              boxShadow: [
                BoxShadow(color: themes.panelColor, spreadRadius: 3),
              ],
            ),
            child: const Icon(
              TablerIcons.repeat,
              size: 15,
              color: Colors.white,
            ),
          ),
          onTap: (context) {
            openNote(context, data.note!.id);
          },
        ),
    NotificationType.renoteGrouped: (data, borderRadius, themes) =>
        NotificationsUserCard(
          data: data,
          borderRadius: borderRadius,
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var item in data.users ?? [])
                Builder(builder: (context) {
                  return GestureDetector(
                    child: SizedBox(
                      width: 38,
                      height: 38,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          MkImage(
                            item?["avatarUrl"] ?? "",
                            shape: BoxShape.circle,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      if (item?["id"] != null) {
                        openUser(context, item?["id"]);
                      }
                    },
                  );
                }),
            ],
          ),
          name: MFMText(
            text: ((data.note?.renote?.cw ?? "") +
                    (data.note?.renote?.text ?? ""))
                .replaceAll('\n', ' '),
            bigEmojiCode: false,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            currentServerHost: data.note?.user.host,
          ),
          avatar: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 54, 210, 152),
                shape: BoxShape.circle),
            child: const Icon(
              TablerIcons.repeat,
              size: 28,
              color: Colors.white,
            ),
          ),
          onTap: (context) {
            openNote(context, data.note!.id);
          },
        ),
    NotificationType.quote: (data, borderRadius, themes) => NoteCard(
          data: data.note!,
          borderRadius: borderRadius,
        ),
    NotificationType.mention: (data, borderRadius, themes) => NoteCard(
          data: data.note!,
          borderRadius: borderRadius,
        ),
    NotificationType.note: (data, borderRadius, themes) => NoteCard(
          data: data.note!,
          borderRadius: borderRadius,
        ),
    NotificationType.pollEnded: (data, borderRadius, themes) =>
        NotificationsUserCard(
          data: data,
          borderRadius: borderRadius,
          content: MFMText(
            text: "${data.note?.text}(投票)",
            bigEmojiCode: false,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            currentServerHost: data.note?.user.host,
          ),
          name: const Text("投票结果已经生成"),
          avatarBadge: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 54, 210, 152),
              boxShadow: [
                BoxShadow(color: themes.panelColor, spreadRadius: 3),
              ],
            ),
            child: const Icon(
              TablerIcons.chart_arrows,
              size: 15,
              color: Colors.white,
            ),
          ),
          onTap: (context) {
            openNote(context, data.note!.id);
          },
        ),
    // "reaction:grouped": (data, borderRadius, themes) {}
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var res = ref.watch(notificationsProvider);
    var themes = ref.watch(themeColorsProvider);
    var mediaPadding = MediaQuery.of(context).padding;
    // logger.d(res);
    var scrollController = useScrollController();
    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.offset + 1000 >=
            scrollController.position.maxScrollExtent) {
          ref.read(notificationsProvider.notifier).loadMore();
        }
      });
      return null;
    }, const []);
    return RefreshIndicator.adaptive(
        onRefresh: () => ref.refresh(notificationsProvider.future),
        edgeOffset: mediaPadding.top - 8,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: LoadingAndEmpty(
            loading: res.isLoading,
            empty: res.valueOrNull?.isEmpty ?? true,
            refresh: () {
              ref.invalidate(notificationsProvider);
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                var padding = getPaddingForNote(constraints);
                return ListView.separated(
                  itemCount: res.valueOrNull?.length ?? 0,
                  controller: scrollController,
                  itemBuilder: (context, index) {
                    // return Text("$index");
                    BorderRadius borderRadius;
                    if (index == 0) {
                      borderRadius = const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12));
                    } else {
                      borderRadius = const BorderRadius.all(Radius.zero);
                    }
                    var type = res.valueOrNull![index].type;
                    if (widgetList[type] != null) {
                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: padding),
                          child: widgetList[type]!(
                              res.valueOrNull![index], borderRadius, themes));
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: MkCard(
                          shadow: false,
                          borderRadius: borderRadius,
                          child:
                              Text("暂时不支持的通知:${res.valueOrNull?[index].type}")),
                    );
                    // return SizedBox();
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: SizedBox(
                        width: double.infinity,
                        height: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: themes.dividerColor,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ));
  }
}

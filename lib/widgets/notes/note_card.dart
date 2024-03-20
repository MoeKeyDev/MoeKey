import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/main.dart';
import 'package:moekey/models/note.dart';
import 'package:moekey/models/user_simple.dart';
import 'package:moekey/networks/apis.dart';
import 'package:moekey/networks/notes.dart';
import 'package:moekey/pages/users/user_page.dart';
import 'package:moekey/state/server.dart';
import 'package:moekey/state/themes.dart';
import 'package:moekey/utils/format_duration.dart';
import 'package:moekey/widgets/context_menu.dart';
import 'package:moekey/widgets/emoji_list.dart';
import 'package:moekey/widgets/mk_overflow_show.dart';
import 'package:moekey/widgets/note_create_dialog/note_create_dialog.dart';
import 'package:moekey/widgets/note_create_dialog/note_create_dialog_state.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../models/drive.dart';
import '../../networks/timeline.dart';
import '../../pages/image_preview/image_preview.dart';
import '../../pages/notes/note_page.dart';
import '../../router/main_router_delegate.dart' as main_router;
import '../../utils/parse-color.dart';
import '../../utils/time_ago_since_date.dart';
import '../hover_builder.dart';
import '../mfm_text/mfm_text.dart';
import '../mk_card.dart';
import '../mk_image.dart';
import '../reactions.dart';
import 'note_image.dart';

List<String> extractLinksFromMarkdown(String markdownText) {
  final RegExp linkRegex = RegExp(
      r'(http|https)://[\w\-_]+(\.[\w\-_]+)+([\w\-.,@?^=%&:/~+#]*[\w\-@?^=%&/~+#])?');

  final Set<String> links = {};
  final Iterable<RegExpMatch> matches = linkRegex.allMatches(markdownText);

  for (final RegExpMatch match in matches) {
    if (match.group(0) != null) {
      final String linkUrl = match.group(0)!;
      links.add(linkUrl);
    }
  }

  return links.toList();
}

class NoteCard extends ConsumerWidget {
  final NoteModel data;
  final BorderRadius borderRadius;
  final bool pined;
  const NoteCard({
    super.key,
    required this.data,
    required this.borderRadius,
    this.pined = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    NoteModel thisData;
    bool isReNote = false;
    thisData = data;
    if (data.text == null && (data.files.isEmpty) && data.renote != null) {
      thisData = data.renote!;
      isReNote = true;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        var textStyle = Theme.of(context).textTheme.bodyMedium;
        return DefaultTextStyle(
          style: textStyle!,
          child: MkCard(
            shadow: false,
            borderRadius: borderRadius,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pined)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          TablerIcons.pin,
                          size: 17,
                          color: Colors.orangeAccent,
                        ),
                        Text(
                          " 已置顶的帖子",
                          style: TextStyle(
                              color: Colors.orangeAccent, fontSize: 13.5),
                        ),
                      ],
                    ),
                  ),
                if (thisData.reply != null)
                  Opacity(
                    opacity: 0.8,
                    child: TimeLineNoteCardComponent(
                      data: thisData.reply!,
                      reply: true,
                      // isShowReactions: false,
                      disableReactions: true,
                    ),
                  ),
                if (isReNote) ReNoteUserInfo(data: data),
                const SizedBox(
                  height: 4,
                ),
                TimeLineNoteCardComponent(
                  data: thisData,
                  isShowUrlPreview: true,
                  innerWidget: thisData.renote != null
                      ? Container(
                          margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: themes.fgColor.withOpacity(0.6)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          padding: const EdgeInsets.all(12),
                          child: TimeLineNoteCardComponent(
                            data: thisData.renote!,
                            isShowAction: false,
                            isShowReactions: false,
                            limit: 500,
                            height: 300,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TimeLineNoteCardComponent extends HookConsumerWidget {
  TimeLineNoteCardComponent({
    super.key,
    required this.data,
    this.reply = false,
    this.isShowAction = true,
    this.innerWidget,
    this.isShowReactions = true,
    this.isShowUrlPreview = false,
    this.disableReactions = false,
    this.limit = 1000,
    this.height = 400,
  });
  final NoteModel data;
  final bool reply;
  final bool isShowAction;
  final bool isShowReactions;
  final bool disableReactions;
  final bool isShowUrlPreview;
  final Widget? innerWidget;
  final ConstraintId avatar = ConstraintId('avatar');
  final ConstraintId content = ConstraintId('content');
  final double limit;
  final double height;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var fontsize = DefaultTextStyle.of(context).style.fontSize!;
    var isHiddenCw = useState(true);
    var themes = ref.watch(themeColorsProvider);
    // var notifier = ref.read(notesListenerProvider.notifier);
    NoteModel data = ref.watch(noteListProvider.select((value) {
      return value[this.data.id] ?? this.data;
    }));
    NotesListener note = ref.watch(notesListenerProvider.notifier);
    useEffect(() {
      var code = hashCode.toString();

      note.subNote(data, code);

      return () => note.unsubNote(data, code);
    }, [this.data.id]);
    var links = extractLinksFromMarkdown(data.text ?? "");
    return LayoutBuilder(builder: (context, constraints) {
      var isSmall = constraints.maxWidth < 400;
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            main_router.MainRouterDelegate.of(context)
                .setNewRoutePath(main_router.RouterItem(
              path: "notes/${data.id}",
              page: () => NotesPage(
                noteId: data.id,
              ),
              launchMode: main_router.LaunchMode.standard,
            ));
          },
          child: Container(
            color: Colors.transparent,
            child: ConstraintLayout(
              children: [
                GestureDetector(
                  onTap: () {
                    main_router.MainRouterDelegate.of(context)
                        .setNewRoutePath(main_router.RouterItem(
                      path: "user/${data.user.id}",
                      page: () {
                        return UserPage(userId: data.user.id);
                      },
                    ));
                  },
                  child: MkImage(
                    data.user.avatarUrl ?? "",
                    shape: BoxShape.circle,
                  ),
                ).applyConstraint(
                  top: parent.top,
                  left: parent.left,
                  size: isSmall ? 7 * (fontsize - 8) : 8 * (fontsize - 8),
                  id: avatar,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left:
                          isSmall ? 8.5 * (fontsize - 8) : 10 * (fontsize - 8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(child: UserNameRichText(data: data.user)),
                          Text(timeAgoSinceDate(data.createdAt),
                              style: TextStyle(fontSize: fontsize * 0.9)),
                          const SizedBox(
                            width: 6,
                          ),
                          if (NoteVisibility.getIcon(data.visibility) != null)
                            Icon(
                              NoteVisibility.getIcon(data.visibility)!,
                              size: fontsize,
                              color: themes.fgColor,
                            )
                        ],
                      ),
                      if (data.user.instance != null) const SizedBox(height: 4),
                      if (data.user.instance != null)
                        UserInstanceBar(data: data),
                      // start
                      MkOverflowShow(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (data.cw != null) const SizedBox(height: 4),
                            if (data.cw != null)
                              MFMText(
                                text: data.cw ?? "",
                                currentServerHost: data.user.host,
                                emojis: data.emojis,
                              ),
                            if (data.cw != null) const SizedBox(height: 4),
                            if (data.cw != null)
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  onPressed: () {
                                    isHiddenCw.value = !isHiddenCw.value;
                                  },
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(MaterialState.hovered)) {
                                          return themes.buttonHoverBgColor;
                                        }
                                        return themes.buttonBgColor;
                                      }),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              themes.fgColor),
                                      elevation: MaterialStateProperty.all(0)),
                                  child: Text(isHiddenCw.value ? "查看更多" : "收起"),
                                ),
                              ),
                            if (!isHiddenCw.value || data.cw == null) ...[
                              const SizedBox(height: 4),
                              if ((data.text ?? "") != "")
                                MFMText(
                                  key: ValueKey(data.text ?? ""),
                                  text: data.text ?? "",
                                  emojis: data.emojis,
                                  currentServerHost: data.user.host,
                                ),
                              const SizedBox(height: 4),
                              // 投票
                              if (data.poll != null) PollCard(data: data),
                              TimeLineImage(
                                  files: data.files,
                                  mainAxisExtent: constraints.maxWidth * 0.7),
                              // 链接预览
                              if (isShowUrlPreview)
                                for (var link in links)
                                  NoteLinkPreview(
                                      link: link, fontsize: fontsize),
                              if (innerWidget != null) innerWidget!,
                            ],
                          ],
                        ),
                        action: (isShow, p1) {
                          return Text("查看更多");
                        },
                        limit: limit,
                        height: height,
                      ),

                      // end
                      if (isShowReactions) ...[
                        const SizedBox(height: 8),
                        ReactionsListComponent(
                            emojis: data.reactionEmojis,
                            reactionsList: data.reactions,
                            id: data.id,
                            myReaction: data.myReaction,
                            disableReactions: disableReactions),
                      ],
                      if (isShowAction)
                        TimeLineActions(
                          fontsize: fontsize,
                          data: data,
                        )
                    ],
                  ),
                ).applyConstraint(
                    top: parent.top,
                    width: matchParent,
                    height: wrapContent,
                    id: content),
                if (reply)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 4),
                    child: Container(
                      color: themes.dividerColor,
                    ),
                  ).applyConstraint(
                      width: 2,
                      top: avatar.bottom,
                      bottom: parent.bottom,
                      left: avatar.left,
                      right: avatar.right,
                      height: matchConstraint)
              ],
            ),
          ),
        ),
      );
    });

    // return VisibilityDetector(
    //   onVisibilityChanged: (visibilityInfo) {
    //     if (visibilityInfo.visibleFraction > 0) {
    //       notifier.subNote(data);
    //     } else {
    //       notifier.unsubNote(data);
    //     }
    //   },
    //   key: ValueKey(data.id),
    //   child: ,
    // );
  }
}

class NoteLinkPreview extends HookConsumerWidget {
  const NoteLinkPreview({
    super.key,
    required this.link,
    required this.fontsize,
  });

  final String link;
  final double fontsize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var res = ref.watch(getUriInfoProvider(link));
    if (res.valueOrNull != null) {
      var data = res.valueOrNull;
      return Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(
              color: themes.dividerColor,
              width: 1,
            )),
        child: IntrinsicHeight(
          child: Row(
            children: [
              if (data["thumbnail"] != null)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                  child: SizedBox(
                    width: fontsize * 7,
                    height: fontsize * 7,
                    child: MkImage(
                      data["thumbnail"],
                      height: fontsize * 8,
                      width: fontsize * 8,
                    ),
                  ),
                ),
              Expanded(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data["title"] ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: fontsize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data["description"] ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: fontsize * 0.9,
                      ),
                    ),
                    Row(
                      children: [
                        if (data["icon"] != null) ...[
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: MkImage(
                              data["icon"],
                              height: 16,
                              width: 16,
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          )
                        ],
                        Expanded(
                          child: Text(
                            data["sitename"] ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: fontsize * 0.9,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      );
    }
    return const SizedBox();
  }
}

class ReNoteUserInfo extends HookConsumerWidget {
  const ReNoteUserInfo({
    super.key,
    required this.data,
  });

  final NoteModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var fontsize = DefaultTextStyle.of(context).style.fontSize!;

    return LayoutBuilder(builder: (context, constraints) {
      var isSmall = constraints.maxWidth < 400;
      return Row(
        children: [
          SizedBox(
            width: isSmall ? 7 * (fontsize - 8) - 29 : 8 * (fontsize - 8) - 29,
          ),
          GestureDetector(
            onTap: () {
              main_router.MainRouterDelegate.of(context)
                  .setNewRoutePath(main_router.RouterItem(
                path: "user/${data.user.id}",
                page: () {
                  return UserPage(userId: data.user.id);
                },
              ));
            },
            child: MkImage(
              data.user.avatarUrl ?? "",
              width: 28,
              height: 28,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: isSmall ? 1.5 * (fontsize - 8) : 2 * (fontsize - 8),
          ),
          Icon(
            TablerIcons.repeat,
            color: themes.reNoteColor,
            size: fontsize * 1.2,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: DefaultTextStyle(
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: fontsize,
                  color: themes.reNoteColor),
              child: MFMText(
                text: data.user.name ?? data.user.username ?? "",
                after: [
                  TextSpan(
                      text: "转发了",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: fontsize,
                          color: themes.reNoteColor)),
                ],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                emojis: data.user.emojis,
                bigEmojiCode: false,
                feature: const [MFMFeature.emojiCode],
              ),
            ),
          ),
          Text(timeAgoSinceDate(data.createdAt),
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: fontsize,
                  color: themes.reNoteColor))
        ],
      );
    });
  }
}

class UserNameRichText extends HookConsumerWidget {
  const UserNameRichText({
    super.key,
    required this.data,
  });

  final UserSimpleModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textStyle = DefaultTextStyle.of(context).style;
    var themes = ref.watch(themeColorsProvider);
    return GestureDetector(
      onTap: () {
        main_router.MainRouterDelegate.of(context)
            .setNewRoutePath(main_router.RouterItem(
          path: "user/${data.id}",
          page: () {
            return UserPage(userId: data.id);
          },
        ));
      },
      child: DefaultTextStyle(
        style: textStyle.copyWith(fontWeight: FontWeight.bold),
        child: MFMText(
          text: data.name ?? data.username,
          after: [
            TextSpan(text: "@${data.username ?? ""}", style: textStyle),
            TextSpan(
              text: data.host != null ? "@${data.host}" : "",
              style: textStyle.copyWith(color: themes.fgColor.withAlpha(128)),
            ),
            const TextSpan(
              text: "  ",
            ),
            for (var badge in data.badgeRoles)
              WidgetSpan(
                  child: Tooltip(
                    message: badge.name,
                    child: MkImage(
                      badge.iconUrl,
                      height: 16,
                    ),
                  ),
                  alignment: PlaceholderAlignment.middle)
          ],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          emojis: data.emojis,
          bigEmojiCode: false,
          feature: const [MFMFeature.emojiCode],
        ),
      ),
    );
  }
}

class UserInstanceBar extends HookConsumerWidget {
  const UserInstanceBar({
    super.key,
    required this.data,
  });

  final NoteModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(4),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 16,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              parseColor(data.user.instance?.themeColor ?? "#66ccff"),
              themes.panelColor,
            ], end: FractionalOffset.centerRight, begin: Alignment.centerLeft),
          ),
          child: Row(
            children: [
              if (data.user.instance?.faviconUrl != null ||
                  data.user.instance?.iconUrl != null)
                MkImage(
                  data.user.instance?.faviconUrl ??
                      data.user.instance?.iconUrl ??
                      "",
                  width: 16,
                  height: 16,
                ),
              Expanded(
                  child: Text(
                data.user.instance?.name ?? "",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    shadows: [
                      Shadow(
                          color: Colors.black,
                          offset: Offset(1, 0),
                          blurRadius: 1),
                      Shadow(
                          color: Colors.black,
                          offset: Offset(0, 1),
                          blurRadius: 1),
                      Shadow(
                          color: Colors.black,
                          offset: Offset(-1, 0),
                          blurRadius: 1),
                      Shadow(
                          color: Colors.black,
                          offset: Offset(0, -1),
                          blurRadius: 1),
                    ]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class TimeLineImage extends StatelessWidget {
  final List<DriveFileModel> files;
  final double mainAxisExtent;

  TimeLineImage(
      {super.key, required List<DriveFileModel> files, this.mainAxisExtent = 0})
      : files = files.map((e) => e.copyWith(hero: UniqueKey())).toList();
  open(index, BuildContext context) {
    globalNav.currentState?.push(
      FFTransparentPageRoute(
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return ImagePreviewPage(
            initialIndex: index,
            galleryItems: files,
            backgroundDecoration: null,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 过滤出所有的图片和视频
    List<DriveFileModel> media = [];
    List<Widget> filesWidget = [];
    for (var item in files) {
      if (item.type.startsWith("image") || item.type.startsWith("video")) {
        media.add(item);
      } else {
        filesWidget.add(GestureDetector(
          onTap: () {
            launchUrlString(item.url);
          },
          child: Tooltip(
            message: item.url,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  TablerIcons.download,
                  size: 18,
                  color: DefaultTextStyle.of(context).style.color,
                ),
                Text(item.name)
              ],
            ),
          ),
        ));
      }
    }
    Widget? imageListWidget;
    if (media.length == 1) {
      imageListWidget = NoteImage(
        imageFile: media[0],
        maxHeight: 460,
        onClick: () {
          open(0, context);
        },
      );
    } else if (media.length == 2) {
      imageListWidget = StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: [
          StaggeredGridTile.extent(
            mainAxisExtent: mainAxisExtent / 2,
            crossAxisCellCount: 1,
            child: NoteImage(
              imageFile: media[0],
              onClick: () {
                open(0, context);
              },
            ),
          ),
          StaggeredGridTile.extent(
            mainAxisExtent: mainAxisExtent / 2,
            crossAxisCellCount: 1,
            child: NoteImage(
                imageFile: media[1],
                onClick: () {
                  open(1, context);
                }),
          ),
        ],
      );
    } else if (media.length == 3) {
      imageListWidget = StaggeredGrid.count(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: [
          StaggeredGridTile.extent(
              mainAxisExtent: mainAxisExtent / 1.5 + 8,
              crossAxisCellCount: 2,
              child: NoteImage(
                  imageFile: media[0],
                  onClick: () {
                    open(0, context);
                  })),
          StaggeredGridTile.extent(
            mainAxisExtent: mainAxisExtent / 3,
            crossAxisCellCount: 1,
            child: NoteImage(
                imageFile: media[1],
                onClick: () {
                  open(1, context);
                }),
          ),
          StaggeredGridTile.extent(
            mainAxisExtent: mainAxisExtent / 3,
            crossAxisCellCount: 1,
            child: NoteImage(
                imageFile: media[2],
                onClick: () {
                  open(2, context);
                }),
          ),
        ],
      );
    } else if (media.length > 3) {
      imageListWidget = StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: [
          for (var (index, file) in media.indexed)
            StaggeredGridTile.extent(
              mainAxisExtent: mainAxisExtent / 2.5,
              crossAxisCellCount: 1,
              child: NoteImage(
                  imageFile: file,
                  onClick: () {
                    open(index, context);
                  }),
            ),
        ],
      );
    }
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: filesWidget,
        ),
        if (imageListWidget != null) imageListWidget,
      ],
    );
  }
}

class TimeLineActions extends StatelessWidget {
  const TimeLineActions({
    super.key,
    required this.fontsize,
    required this.data,
  });
  final NoteModel data;
  final double fontsize;

  @override
  Widget build(BuildContext context) {
    return HookConsumer(builder: (context, ref, child) {
      var currentUser = ref.watch(currentLoginUserProvider);
      return Row(
        children: [
          TimelineActionButton(
            fontsize: fontsize,
            icon: TablerIcons.arrow_back_up,
            count: data.repliesCount,
            onTap: () {
              globalNav.currentState?.push(
                NoteCreateDialog.getRouter(
                  noteId: data.id,
                  type: NoteType.reply,
                  note: data,
                  initText: "${data.createReplyAtText(currentUser.value!.id)} ",
                ),
              );
            },
          ),
          const SizedBox(
            width: 28,
          ),
          ContextMenuBuilder(
              menu: ContextMenuCard(
                initialChildSize: 0.3,
                maxChildSize: 0.4,
                minChildSize: 0.3,
                menuListBuilder: () {
                  return [
                    ContextMenuItem(
                      icon: TablerIcons.repeat,
                      label: "转发",
                      onTap: () {
                        ref.read(noteApisProvider.notifier).reNote(data.id);
                        return false;
                      },
                    ),
                    ContextMenuItem(
                      icon: TablerIcons.quote,
                      label: "引用",
                      onTap: () {
                        globalNav.currentState?.push(NoteCreateDialog.getRouter(
                          type: NoteType.reNote,
                          noteId: data.id,
                          note: data,
                        ));
                        return false;
                      },
                    )
                  ];
                },
              ),
              mode: const [ContextMenuMode.onTap],
              child: Builder(
                builder: (context) {
                  return TimelineActionButton(
                    fontsize: fontsize,
                    icon: TablerIcons.repeat,
                    count: data.renoteCount,
                    onTap: () {
                      if (Platform.isAndroid || Platform.isIOS) {
                        context
                            .findAncestorStateOfType<ContextMenuBuilderState>()
                            ?.showBottomSheet();
                      } else {
                        context
                            .findAncestorStateOfType<ContextMenuBuilderState>()
                            ?.show((context.findRenderObject() as RenderBox)
                                    .localToGlobal(Offset.zero) +
                                context.size!
                                    .bottomCenter(const Offset(-100, 0)));
                      }
                    },
                  );
                },
              )),
          const SizedBox(
            width: 28,
          ),
          TimelineActionButton(
            fontsize: fontsize,
            icon: TablerIcons.plus,
            onTap: () {
              EmojiList.showBottomSheet(
                context,
                onInsert: (emoji) {
                  ref
                      .read(noteApisProvider.notifier)
                      .createReactions(data.id, emoji["name"]);
                  globalNav.currentState?.pop();
                },
              );
            },
          ),
          const SizedBox(
            width: 28,
          ),
          TimelineActionButton(
            fontsize: fontsize,
            icon: TablerIcons.dots,
          ),
        ],
      );
    });
  }
}

class TimelineActionButton extends HookConsumerWidget {
  final void Function()? onTap;

  final IconData? icon;

  final num count;

  const TimelineActionButton({
    super.key,
    required this.fontsize,
    required this.icon,
    this.onTap,
    this.count = 0,
  });

  final double fontsize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return HoverBuilder(
      builder: (context, isHover) {
        var color = themes.fgColor.withAlpha(isHover ? 255 : 128);
        return InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: fontsize * 1.3,
                  color: color,
                ),
                if (count != 0)
                  const SizedBox(
                    width: 4,
                  ),
                if (count != 0)
                  Text(
                    "$count",
                    style: TextStyle(
                      color: color,
                      fontSize: fontsize,
                    ),
                    textAlign: TextAlign.left,
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}

class PollCard extends HookConsumerWidget {
  const PollCard({
    super.key,
    required this.data,
  });
  final NoteModel data;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // return Text(data.poll["choices"].toString());
    num count = 0;
    var isVoted = false;
    for (var item in data.poll!.choices) {
      count += item.votes;
      isVoted = isVoted || item.isVoted;
    }
    return HookConsumer(
      builder: (context, ref, child) {
        var themes = ref.watch(themeColorsProvider);
        var isExpires = useState(false);
        var duration = useState<int?>(null);
        func() {
          isExpires.value = data.poll!.expiresAt != null &&
              (data.poll!.expiresAt!.millisecondsSinceEpoch <
                  DateTime.now().millisecondsSinceEpoch);
          // int? duration;
          if (data.poll?.expiresAt != null && !isExpires.value) {
            duration.value = data.poll!.expiresAt!.millisecondsSinceEpoch -
                DateTime.now().millisecondsSinceEpoch;
          } else {
            duration.value = null;
          }
        }

        func();
        useEffect(() {
          var time = Timer.periodic(
            const Duration(seconds: 1),
            (timer) => func(),
          );
          return () => time.cancel();
        }, const []);
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var item in data.poll!.choices)
              Builder(
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.only(top: 2, bottom: 2),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: themes.accentedBgColor,
                              ),
                            ),
                            AnimatedFractionallySizedBox(
                              duration: const Duration(milliseconds: 300),
                              widthFactor: count == 0
                                  ? 0
                                  : isVoted || isExpires.value
                                      ? item.votes / count
                                      : 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: themes.accentColor,
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Container(
                                margin: const EdgeInsets.only(left: 4),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 2),
                                decoration: BoxDecoration(
                                    color: themes.panelColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4))),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (item.isVoted)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: Icon(
                                          TablerIcons.check,
                                          size: 16,
                                          color: themes.fgColor,
                                        ),
                                      ),
                                    Text(item.text),
                                    if (isVoted || isExpires.value)
                                      Opacity(
                                        opacity: 0.7,
                                        child: Text(" (${item.votes}票) "),
                                      ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text("总票数 $count"),
                if (isExpires.value)
                  const Text(" · 已截止")
                else if (duration.value != null) ...[
                  const Text(" · "),
                  Text(formatDuration(duration.value!)),
                  const Text("后截至")
                ]
              ],
            )
          ],
        );
      },
    );
  }
}

class FFTransparentPageRoute<T> extends PageRouteBuilder<T> {
  FFTransparentPageRoute({
    super.settings,
    required super.pageBuilder,
    super.transitionsBuilder = _defaultTransitionsBuilder,
    super.transitionDuration = const Duration(milliseconds: 150),
    super.barrierDismissible,
    super.barrierColor,
    super.barrierLabel,
    super.maintainState,
  }) : super(
          opaque: false,
        );
}

Widget _defaultTransitionsBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

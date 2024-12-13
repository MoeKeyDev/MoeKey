import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/meta.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/pages/clips/clips.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/notes_listener.dart';
import 'package:moekey/status/server.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/utils/format_duration.dart';
import 'package:moekey/widgets/clips/clips_create_dialog.dart';
import 'package:moekey/widgets/context_menu.dart';
import 'package:moekey/widgets/emoji_list.dart';
import 'package:moekey/widgets/loading_weight.dart';
import 'package:moekey/widgets/mk_modal.dart';
import 'package:moekey/widgets/mk_overflow_show.dart';
import 'package:moekey/widgets/note_create_dialog/note_create_dialog.dart';
import 'package:moekey/widgets/note_create_dialog/note_create_dialog_state.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../apis/models/drive.dart';
import '../../apis/models/note.dart';
import '../../apis/models/translate.dart';
import '../../apis/models/user_lite.dart';
import '../../status/misskey_api.dart';
import '../../utils/parse_color.dart';
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
  final List<ContextMenuItem>? customContextmenu;

  const NoteCard({
    super.key,
    required this.data,
    required this.borderRadius,
    this.pined = false,
    this.customContextmenu,
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
            if (pined) const _NotePined(),
            if (thisData.reply != null)
              TimeLineNoteCardComponent(
                data: thisData.reply!,
                reply: true,
                // isShowReactions: false,
                disableReactions: true,
              ),
            if (isReNote) ReNoteUserInfo(data: data),
            const SizedBox(
              height: 4,
            ),
            TimeLineNoteCardComponent(
              data: thisData,
              isShowUrlPreview: true,
              customMenuItem: customContextmenu,
              innerWidget: thisData.renote != null
                  ? Container(
                      margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: themes.fgColor.withOpacity(0.6)),
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
  }
}

class _NotePined extends StatelessWidget {
  const _NotePined({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Icon(
            TablerIcons.pin,
            size: 17,
            color: Colors.orangeAccent,
          ),
          Text(
            S.current.notePined,
            style: const TextStyle(color: Colors.orangeAccent, fontSize: 13.5),
          ),
        ],
      ),
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
    this.customMenuItem,
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
  final List<ContextMenuItem>? customMenuItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var fontsize = DefaultTextStyle.of(context).style.fontSize!;
    var themes = ref.watch(themeColorsProvider);
    var noteListener = noteListenerProvider(this.data);
    var data = ref.watch(noteListener);

    var links = extractLinksFromMarkdown(data.text ?? "");
    var serverUrl = ref.watch(currentLoginUserProvider)!.serverUrl;
    var meta = ref.watch(instanceMetaProvider).valueOrNull;
    return LayoutBuilder(
      builder: (context, constraints) {
        var isSmall = constraints.maxWidth < 400;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              context.push('/notes/${data.id}', extra: data.copyWith());
              // main_router.MainRouterDelegate.of(context)
              //     .setNewRoutePath(main_router.RouterItem(
              //   path: "notes/${data.id}",
              //   page: () => NotesPage(
              //     noteId: data.id,
              //     previewNote: data,
              //   ),
              //   launchMode: main_router.LaunchMode.standard,
              // ));
            },
            child: ContextMenuBuilder(
              mode: const [
                ContextMenuMode.onSecondaryTap,
                ContextMenuMode.onLongPress
              ],
              menu: buildNoteContextMenu(serverUrl, meta, data, ref, context,
                  customMenuItem: customMenuItem),
              child: Container(
                color: Colors.transparent,
                child: ConstraintLayout(
                  children: [
                    _TimeLineNoteCardAvatar(data: data).applyConstraint(
                      top: parent.top,
                      left: parent.left,
                      size: isSmall ? 7 * (fontsize - 8) : 8 * (fontsize - 8),
                      id: avatar,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: isSmall
                              ? 8.5 * (fontsize - 8)
                              : 10 * (fontsize - 8)),
                      child: _NoteCardContent(
                        data: data,
                        fontsize: fontsize,
                        isShowUrlPreview: isShowUrlPreview,
                        links: links,
                        innerWidget: innerWidget,
                        limit: limit,
                        height: height,
                        isShowReactions: isShowReactions,
                        disableReactions: disableReactions,
                        isShowAction: isShowAction,
                        customMenuItem: customMenuItem,
                        constraints: constraints,
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
          ),
        );
      },
    );
  }
}

class _TimeLineNoteCardAvatar extends StatelessWidget {
  const _TimeLineNoteCardAvatar({
    super.key,
    required this.data,
  });

  final NoteModel data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // main_router.MainRouterDelegate.of(context)
        //     .setNewRoutePath(main_router.RouterItem(
        //   path: "user/${data.user.id}",
        //   page: () {
        //     return UserPage(userId: data.user.id);
        //   },
        // ));
        context.push('/user/${data.user.id}');
      },
      child: MkImage(
        data.user.avatarUrl ?? "",
        shape: BoxShape.circle,
        blurHash: data.user.avatarBlurhash,
      ),
    );
  }
}

class _NoteCardContent extends HookConsumerWidget {
  const _NoteCardContent(
      {super.key,
      required this.data,
      required this.fontsize,
      required this.isShowUrlPreview,
      required this.links,
      required this.innerWidget,
      required this.limit,
      required this.height,
      required this.isShowReactions,
      required this.disableReactions,
      required this.isShowAction,
      required this.customMenuItem,
      required this.constraints});

  final NoteModel data;
  final double fontsize;
  final bool isShowUrlPreview;
  final List<String> links;
  final Widget? innerWidget;
  final double limit;
  final double height;
  final bool isShowReactions;
  final bool disableReactions;
  final bool isShowAction;
  final BoxConstraints constraints;
  final List<ContextMenuItem>? customMenuItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isHiddenCw = useState(true);
    var themes = ref.watch(themeColorsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _NoteCardContentUerHeader(
            data: data, fontsize: fontsize, themes: themes),
        if (data.user.instance != null) ...[
          const SizedBox(height: 4),
          RepaintBoundary(child: UserInstanceBar(data: data.user)),
        ],

        // start
        _TimeLineNoteCardContent(
            data: data,
            isHiddenCw: isHiddenCw,
            themes: themes,
            constraints: constraints,
            isShowUrlPreview: isShowUrlPreview,
            links: links,
            fontsize: fontsize,
            innerWidget: innerWidget,
            limit: limit,
            height: height),

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
            customMenuItem: customMenuItem,
          )
      ],
    );
  }
}

class _TimeLineNoteCardContent extends StatelessWidget {
  const _TimeLineNoteCardContent({
    super.key,
    required this.data,
    required this.isHiddenCw,
    required this.themes,
    required this.constraints,
    required this.isShowUrlPreview,
    required this.links,
    required this.fontsize,
    required this.innerWidget,
    required this.limit,
    required this.height,
  });

  final NoteModel data;
  final ValueNotifier<bool> isHiddenCw;
  final ThemeColorModel themes;
  final BoxConstraints constraints;
  final bool isShowUrlPreview;
  final List<String> links;
  final double fontsize;
  final Widget? innerWidget;
  final double limit;
  final double height;

  @override
  Widget build(BuildContext context) {
    return MkOverflowShow(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.cw != null)
            _NoteCardContentCw(
                data: data, isHiddenCw: isHiddenCw, themes: themes),
          if (!isHiddenCw.value || data.cw == null) ...[
            const SizedBox(height: 4),
            if ((data.text ?? "") != "")
              MFMText(
                text: data.text ?? "",
                emojis: data.emojis,
                currentServerHost: data.user.host,
              ),
            if (data.noteTranslate != null) NoteCardTranslate(data: data),
            const SizedBox(height: 4),
            // 投票
            if (data.poll != null) PollCard(data: data),
            // 图片
            TimeLineImage(
                files: data.files, mainAxisExtent: constraints.maxWidth * 0.7),
            // 链接预览
            if (isShowUrlPreview)
              for (var link in links) ...[
                NoteLinkPreview(link: link, fontsize: fontsize)
              ],
            if (innerWidget != null) innerWidget!,
          ],
        ],
      ),
      action: (isShow, p1) {
        return Text(S.current.viewMore);
      },
      limit: limit,
      height: height,
    );
  }
}

class NoteCardTranslate extends HookConsumerWidget {
  const NoteCardTranslate({
    super.key,
    required this.data,
  });

  final NoteModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: themes.dividerColor, width: 1),
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.only(top: 6, bottom: 2),
      child: [
        if (data.noteTranslate!.loading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: LoadingCircularProgress(
                size: 22,
                strokeWidth: 4,
              ),
            ),
          )
        else
          MFMText(
            emojis: data.emojis,
            currentServerHost: data.user.host,
            before: [
              TextSpan(
                  text: S.current.noteFormLanguageTranslation(
                      data.noteTranslate!.sourceLang),
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ],
            text: data.noteTranslate!.text ?? "",
          ),
      ][0],
    );
  }
}

class _NoteCardContentCw extends HookConsumerWidget {
  const _NoteCardContentCw({
    super.key,
    required this.data,
    required this.isHiddenCw,
    required this.themes,
  });

  final NoteModel data;
  final ValueNotifier<bool> isHiddenCw;
  final ThemeColorModel themes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        MFMText(
          text: data.cw ?? "",
          currentServerHost: data.user.host,
          emojis: data.emojis,
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              isHiddenCw.value = !isHiddenCw.value;
            },
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return themes.buttonHoverBgColor;
                  }
                  return themes.buttonBgColor;
                }),
                foregroundColor: WidgetStateProperty.all(themes.fgColor),
                elevation: WidgetStateProperty.all(0)),
            child: Text(
                isHiddenCw.value ? S.current.noteCwShow : S.current.noteCwHide),
          ),
        ),
      ],
    );
  }
}

class _NoteCardContentUerHeader extends StatelessWidget {
  const _NoteCardContentUerHeader({
    super.key,
    required this.data,
    required this.fontsize,
    required this.themes,
  });

  final NoteModel data;
  final double fontsize;
  final ThemeColorModel themes;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: UserNameRichText(data: data.user)),
        Text(timeAgoSinceDate(data.createdAt),
            style: TextStyle(fontSize: fontsize * 0.9),
            maxLines: 1,
            overflow: TextOverflow.fade),
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
    );
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

    var data = res.valueOrNull;

    if (data == null) {
      return const SizedBox();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(
            color: themes.dividerColor,
            width: 1,
          )),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            launchUrlString(link);
          },
          child: Row(
            children: [
              if (data.thumbnail != null)
                ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                  child: SizedBox(
                    width: fontsize * 7,
                    height: fontsize * 7,
                    child: MkImage(
                      data.thumbnail!,
                      height: fontsize * 7,
                      width: fontsize * 7,
                    ),
                  ),
                )
              else
                SizedBox(
                  height: fontsize * 7,
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
                      data.title ?? "...",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: fontsize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data.description ?? "...",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: fontsize * 0.9,
                      ),
                    ),
                    Row(
                      children: [
                        if (data.icon != null) ...[
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: MkImage(
                              data.icon!,
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
                            data.sitename ?? "...",
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
      ),
    );
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
              // main_router.MainRouterDelegate.of(context)
              //     .setNewRoutePath(main_router.RouterItem(
              //   path: "user/${data.user.id}",
              //   page: () {
              //     return UserPage(userId: data.user.id);
              //   },
              // ));
              context.push('/user/${data.user.id}');
            },
            child: SizedBox(
              width: 28,
              height: 28,
              child: MkImage(
                data.user.avatarUrl ?? "",
                width: 28,
                height: 28,
                shape: BoxShape.circle,
                blurHash: data.user.avatarBlurhash,
              ),
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
                      text: S.current.noteReNoteByUser,
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
          RepaintBoundary(
            child: Text(timeAgoSinceDate(data.createdAt),
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: fontsize,
                    color: themes.reNoteColor)),
          )
        ],
      );
    });
  }
}

class UserNameRichText extends HookConsumerWidget {
  const UserNameRichText(
      {super.key, required this.data, this.navigator = true});

  final UserLiteModel data;
  final bool navigator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textStyle = DefaultTextStyle.of(context).style;
    var themes = ref.watch(themeColorsProvider);
    return GestureDetector(
      onTap: navigator
          ? () {
              context.push('/user/${data.id}');
            }
          : null,
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
            for (var badge in data.badgeRoles ?? [])
              if (badge.iconUrl != null)
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

  final UserLiteModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(4),
      ),
      child: SizedBox(
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              parseColor(data.instance?.themeColor ?? "#66ccff"),
              themes.panelColor,
            ], end: FractionalOffset.centerRight, begin: Alignment.centerLeft),
          ),
          child: Row(
            children: [
              if (data.instance?.faviconUrl != null ||
                  data.instance?.iconUrl != null)
                MkImage(
                  data.instance?.faviconUrl ?? data.instance?.iconUrl ?? "",
                  width: 16,
                  height: 16,
                ),
              Expanded(
                  child: Text(
                data.instance?.name ?? "",
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

class TimeLineImage extends StatefulWidget {
  final List<DriveFileModel> files;
  final double mainAxisExtent;

  const TimeLineImage(
      {super.key, this.mainAxisExtent = 0, required this.files});

  @override
  State<TimeLineImage> createState() => _TimeLineImageState();
}

class _TimeLineImageState extends State<TimeLineImage> {
  open(index) {
    context.push('/image-preview', extra: {
      'initialIndex': index,
      'galleryItems': widget.files,
      'heroKeys': heroKeys
    });
  }

  List<UniqueKey> heroKeys = [];

  @override
  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.files.length; i++) {
      heroKeys.add(UniqueKey());
    }
  }

  @override
  Widget build(BuildContext context) {
    // 过滤出所有的图片和视频
    List<DriveFileModel> media = [];
    List<Widget> filesWidget = [];

    for (var item in widget.files) {
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
        heroKey: heroKeys[0],
        onClick: () {
          open(0);
        },
      );
    } else if (media.length == 2) {
      imageListWidget = StaggeredGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: [
          StaggeredGridTile.extent(
            mainAxisExtent: widget.mainAxisExtent / 2,
            crossAxisCellCount: 1,
            child: NoteImage(
              imageFile: media[0],
              heroKey: heroKeys[0],
              onClick: () {
                open(0);
              },
            ),
          ),
          StaggeredGridTile.extent(
            mainAxisExtent: widget.mainAxisExtent / 2,
            crossAxisCellCount: 1,
            child: NoteImage(
                imageFile: media[1],
                heroKey: heroKeys[1],
                onClick: () {
                  open(1);
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
              mainAxisExtent: widget.mainAxisExtent / 1.5 + 8,
              crossAxisCellCount: 2,
              child: NoteImage(
                  imageFile: media[0],
                  heroKey: heroKeys[0],
                  onClick: () {
                    open(0);
                  })),
          StaggeredGridTile.extent(
            mainAxisExtent: widget.mainAxisExtent / 3,
            crossAxisCellCount: 1,
            child: NoteImage(
                imageFile: media[1],
                heroKey: heroKeys[1],
                onClick: () {
                  open(1);
                }),
          ),
          StaggeredGridTile.extent(
            mainAxisExtent: widget.mainAxisExtent / 3,
            crossAxisCellCount: 1,
            child: NoteImage(
                imageFile: media[2],
                heroKey: heroKeys[2],
                onClick: () {
                  open(2);
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
              mainAxisExtent: widget.mainAxisExtent / 2.5,
              crossAxisCellCount: 1,
              child: NoteImage(
                  imageFile: file,
                  heroKey: heroKeys[index],
                  onClick: () {
                    open(index);
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

ContextMenuCard buildNoteContextMenu(String serverUrl, MetaDetailedModel? meta,
    NoteModel data, WidgetRef ref, BuildContext context,
    {List<ContextMenuItem>? customMenuItem}) {
  return ContextMenuCard(
      menuListBuilder: () {
        return [
          if (customMenuItem != null) ...customMenuItem,
          ContextMenuItem(
            icon: TablerIcons.copy,
            label: S.current.copyContent,
            onTap: () {
              Clipboard.setData(
                ClipboardData(text: data.text ?? ""),
              );
              return false;
            },
          ),
          ContextMenuItem(
            icon: TablerIcons.link,
            label: S.current.noteCopyLocalLink,
            onTap: () {
              Clipboard.setData(
                ClipboardData(text: "$serverUrl/notes/${data.id}"),
              );
              return false;
            },
          ),
          ContextMenuItem(
            icon: TablerIcons.share,
            label: S.current.share,
            onTap: () {
              // ref.read(noteApisProvider.notifier).reNote(data.id);
              Share.shareUri(Uri.parse("$serverUrl/notes/${data.id}"));
              return false;
            },
          ),
          if (data.user.host != null)
            ContextMenuItem(
              icon: TablerIcons.external_link,
              label: S.current.noteOpenRemoteLink,
              onTap: () {
                if (data.uri != null) {
                  launchUrlString(data.uri!);
                }
                // ref.read(noteApisProvider.notifier).reNote(data.id);
                return false;
              },
            ),
          if (meta != null && meta.translatorAvailable)
            ContextMenuItem(
              divider: true,
              icon: TablerIcons.language_hiragana,
              label: S.current.translate,
              onTap: () {
                translateNote(data, ref);
                return false;
              },
            ),
          ContextMenuItem(
            icon: TablerIcons.paperclip,
            label: S.current.clip,
            child: ContextMenuCard(
              menuListBuilder: () async {
                var list = await ref.read(clipsProvider.future);
                return [
                  for (var item in list.indexed)
                    ContextMenuItem(
                      icon: TablerIcons.paperclip,
                      label: item.$2.name,
                      divider: item.$1 == (list.length - 1),
                      onTap: () {
                        ref
                            .read(misskeyApisProvider)
                            .clips
                            .addNote(clipId: item.$2.id, noteId: data.id);

                        return false;
                      },
                    ),
                  ContextMenuItem(
                    label: S.current.clipCreate,
                    icon: TablerIcons.plus,
                    onTap: () {
                      Future.delayed(Duration.zero).then(
                        (value) {
                          if (!context.mounted) return;
                          showModel(
                            context: context,
                            builder: (context) {
                              return const ClipCreateDialog();
                            },
                          );
                        },
                      );

                      return false;
                    },
                  )
                ];
              },
            ),
          )
        ];
      },
      initialChildSize: 0.6,
      maxChildSize: 0.7);
}

/// 翻译Note
Future<void> translateNote(NoteModel data, WidgetRef ref) async {
  var noteListener = noteListenerProvider(data);
  ref.read(noteListener.notifier).updateNote((noteModel) {
    noteModel.noteTranslate = NoteTranslate(text: "", sourceLang: "");
  });
  var apis = ref.read(misskeyApisProvider);
  var value = await apis.notes.translate(noteId: data.id);
  if (value != null) {
    value.loading = false;
    ref.read(noteListener.notifier).updateNote((noteModel) {
      noteModel.noteTranslate = value;
    });
  }
}

class TimeLineActions extends HookConsumerWidget {
  const TimeLineActions(
      {super.key,
      required this.fontsize,
      required this.data,
      this.customMenuItem});

  final NoteModel data;
  final double fontsize;
  final List<ContextMenuItem>? customMenuItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentUser = ref.watch(currentLoginUserProvider);
    var serverUrl = currentUser!.serverUrl;
    var meta = ref.watch(instanceMetaProvider).valueOrNull;
    return Row(
      children: [
        TimelineActionButton(
          fontsize: fontsize,
          icon: TablerIcons.arrow_back_up,
          count: data.repliesCount,
          onTap: () {
            NoteCreateDialog.open(
              noteId: data.id,
              type: NoteType.reply,
              note: data,
              initText: "${data.createReplyAtText(currentUser.id)} ",
              context: context,
            );
          },
        ),
        const SizedBox(
          width: 28,
        ),
        ContextMenuBuilder(
          menu: _buildNoteRepeatContextMenu(ref, context),
          mode: const [ContextMenuMode.onTap],
          alignmentChild: true,
          child: TimelineActionButton(
            fontsize: fontsize,
            icon: TablerIcons.repeat,
            count: data.renoteCount,
          ),
        ),
        const SizedBox(
          width: 28,
        ),
        TimelineActionButton(
          fontsize: fontsize,
          icon: TablerIcons.plus,
          onTap: () {
            EmojiList.showBottomSheet(
              context,
              onInsert: (emoji, context) {
                Navigator.of(context).pop();
                ref
                    .read(misskeyApisProvider)
                    .notes
                    .createReactions(noteId: data.id, reaction: emoji['name']);
              },
            );
          },
        ),
        const SizedBox(
          width: 28,
        ),
        ContextMenuBuilder(
          mode: const [ContextMenuMode.onTap],
          menu: buildNoteContextMenu(serverUrl, meta, data, ref, context,
              customMenuItem: customMenuItem),
          child: TimelineActionButton(
            fontsize: fontsize,
            icon: TablerIcons.dots,
          ),
        ),
      ],
    );
  }

  ContextMenuCard _buildNoteRepeatContextMenu(
      WidgetRef ref, BuildContext context) {
    return ContextMenuCard(
      initialChildSize: 0.3,
      maxChildSize: 0.4,
      minChildSize: 0.3,
      menuListBuilder: () {
        return [
          ContextMenuItem(
            icon: TablerIcons.repeat,
            label: S.current.noteReNote,
            onTap: () {
              ref.read(misskeyApisProvider).notes.reNote(renoteId: data.id);
              return false;
            },
          ),
          ContextMenuItem(
            icon: TablerIcons.quote,
            label: S.current.noteQuote,
            onTap: () {
              NoteCreateDialog.open(
                  type: NoteType.reNote,
                  noteId: data.id,
                  note: data,
                  context: context);
              return false;
            },
          )
        ];
      },
    );
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
        return RepaintBoundary(
          child: InkWell(
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
                    padding: const EdgeInsets.only(top: 2, bottom: 2),
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
                                        child: Text(
                                            " ${S.current.voteCount(item.votes)} "),
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
                Text(S.current.voteAllCount(count)),
                if (isExpires.value)
                  Text(" · ${S.current.voteExpired}")
                else if (duration.value != null) ...[
                  const Text(" · "),
                  Text(S.current
                      .voteWillExpired(formatDuration(duration.value!))),
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

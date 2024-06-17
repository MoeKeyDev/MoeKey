import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/notes_listener.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/utils/get_padding_note.dart';
import 'package:moekey/widgets/loading_weight.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/notes/note_children.dart';

import '../../apis/models/note.dart';
import '../../apis/models/user_lite.dart';
import '../../router/main_router_delegate.dart';
import '../../status/apis.dart';
import '../../status/notes.dart';
import '../../status/server.dart';
import '../../utils/time_ago_since_date.dart';
import '../../utils/time_to_desired_format.dart';
import '../../widgets/context_menu.dart';
import '../../widgets/mfm_text/mfm_text.dart';
import '../../widgets/mk_card.dart';
import '../../widgets/mk_image.dart';
import '../../widgets/mk_scaffold.dart';
import '../../widgets/notes/note_card.dart';
import '../../widgets/reactions.dart';
import '../users/user_page.dart';

class NotesPage extends HookConsumerWidget {
  const NotesPage({super.key, required this.noteId, this.previewNote});

  final String noteId;
  final NoteModel? previewNote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.of(context).padding;
    var themes = ref.watch(themeColorsProvider);
    var notes = notesProvider(noteId);
    var dataProvider = ref.watch(notes);

    var loadConversation = useState<Future?>(null);
    var loadConversationSnapshot = useFuture(loadConversation.value);
    var conversation = dataProvider.valueOrNull?.conversation ?? [];
    var data = dataProvider.valueOrNull?.data ?? previewNote;

    return LayoutBuilder(
      builder: (context, constraints) {
        double padding = getPaddingForNote(constraints);
        return MkScaffold(
            header: MkAppbar(
              showBack: true,
              content: Row(
                children: [
                  if (!dataProvider.isLoading || data != null) ...[
                    GestureDetector(
                      child: MkImage(
                        data?.user.avatarUrl ?? "",
                        shape: BoxShape.circle,
                        width: 32,
                        height: 32,
                      ),
                      onTap: () {
                        MainRouterDelegate.of(context)
                            .setNewRoutePath(RouterItem(
                          path: "user/${data?.userId}",
                          page: () {
                            return UserPage(userId: data?.userId ?? "0");
                          },
                        ));
                      },
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MFMText(
                            text: data?.user.name ?? data?.user.username ?? "",
                            emojis: data?.user.emojis,
                            bigEmojiCode: false,
                            feature: const [MFMFeature.emojiCode],
                            after: const [TextSpan(text: " 的帖子")],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (data?.createdAt != null)
                            Opacity(
                              opacity: 0.6,
                              child: Text(
                                timeAgoSinceDate(data!.createdAt),
                                style: const TextStyle(fontSize: 12),
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              // trailing: TextButton(onPressed: () {}, child: const Text("关注")),
            ),
            body: CustomScrollView(
              slivers: [
                if (data != null)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                        padding, 56 + mediaPadding.top, padding, 0),
                    sliver: SliverToBoxAdapter(
                      child: MkCard(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                        shadow: false,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (conversation.isNotEmpty &&
                                conversation.first.replyId != null) ...[
                              Align(
                                alignment: Alignment.center,
                                child: loadConversationSnapshot
                                            .connectionState ==
                                        ConnectionState.waiting
                                    ? TextButton(
                                        onPressed: () {},
                                        child: const LoadingCircularProgress(
                                            size: 16, strokeWidth: 4),
                                      )
                                    : TextButton(
                                        onPressed: () {
                                          loadConversation.value = ref
                                              .read(notes.notifier)
                                              .loadConversation();
                                        },
                                        child: const Text("查看对话"),
                                      ),
                              )
                            ],
                            const SizedBox(
                              height: 16,
                            ),
                            // 聊天
                            for (var item in conversation)
                              TimeLineNoteCardComponent(
                                data: item,
                                reply: true,
                                disableReactions: true,
                              ),
                            NotesPageNoteCard(data: data)
                          ],
                        ),
                      ),
                    ),
                  ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                  sliver: SliverToBoxAdapter(
                    child: MkCard(
                      shadow: false,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      borderRadius: BorderRadius.zero,
                      child: Container(
                        decoration: BoxDecoration(color: themes.dividerColor),
                        height: 1,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(padding, 0, padding, 16),
                  sliver: NoteChildren(
                    noteId: noteId,
                    deep: 0,
                    first: false,
                    last: true,
                  ),
                )
              ],
            ));
      },
    );
  }
}

class NotesPageNoteCard extends HookConsumerWidget {
  const NotesPageNoteCard({super.key, required this.data});

  final NoteModel data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isHiddenCw = useState(true);
    var themes = ref.watch(themeColorsProvider);
    var noteListener = noteListenerProvider(this.data);
    var data = ref.watch(noteListener);

    // useEffect(() {
    //   // 更新note缓存
    //   ref.read(noteListener.notifier).updateModel(data);
    //   return null;
    // }, [this.data.id]);

    var links = extractLinksFromMarkdown(data.text ?? "");
    var meta = ref.watch(instanceMetaProvider).valueOrNull;
    var serverUrl = ref.watch(currentLoginUserProvider)!.serverUrl;
    return LayoutBuilder(
      builder: (context, constraints) {
        return ContextMenuBuilder(
          mode: const [
            ContextMenuMode.onSecondaryTap,
            ContextMenuMode.onLongPress
          ],
          menu: buildNoteContextMenu(serverUrl, meta, data, ref, context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              UserInfo(
                data: data.user,
                suffix: NoteVisibility.getIcon(data.visibility) != null
                    ? Icon(
                        NoteVisibility.getIcon(data.visibility)!,
                        size: 16,
                        color: themes.fgColor,
                      )
                    : null,
              ),
              const SizedBox(height: 8),
              if (data.cw != null) ...[
                MFMText(
                  text: data.cw ?? "",
                  emojis: data.emojis,
                  currentServerHost: data.user.host,
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      isHiddenCw.value = !isHiddenCw.value;
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.hovered)) {
                            return themes.buttonHoverBgColor;
                          }
                          return themes.buttonBgColor;
                        }),
                        foregroundColor:
                            WidgetStateProperty.all(themes.fgColor),
                        elevation: WidgetStateProperty.all(0)),
                    child: Text(isHiddenCw.value ? "查看更多" : "收起"),
                  ),
                ),
              ],
              if (!isHiddenCw.value || data.cw == null) ...[
                const SizedBox(height: 4),
                if (data.text != null)
                  MFMText(
                    text: data.text ?? "",
                    emojis: data.emojis,
                    currentServerHost: data.user.host,
                    isSelection: true,
                  ),
                if (meta != null &&
                    meta.translatorAvailable &&
                    data.noteTranslate == null)
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        translateNote(data, ref);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          "翻译帖子",
                          style: TextStyle(color: themes.accentColor),
                        ),
                      ),
                    ),
                  ),

                if (data.noteTranslate != null)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: themes.dividerColor, width: 1),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(6),
                      ),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    margin: const EdgeInsets.only(top: 8, bottom: 2),
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
                                text: "从${data.noteTranslate!.sourceLang}翻译:\n",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))
                          ],
                          text: data.noteTranslate!.text ?? "",
                        ),
                    ][0],
                  ),
                const SizedBox(height: 4),
                // 投票
                if (data.poll != null) PollCard(data: data),
                TimeLineImage(
                    files: data.files,
                    mainAxisExtent: constraints.maxWidth * 0.7),
                for (var link in links)
                  NoteLinkPreview(
                      link: link,
                      fontsize: DefaultTextStyle.of(context).style.fontSize!),
              ],
              if (data.reactions.isNotEmpty)
                const SizedBox(
                  height: 8,
                ),
              if (data.renote != null)
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: themes.fgColor.withOpacity(0.6)),
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  padding: const EdgeInsets.all(12),
                  child: TimeLineNoteCardComponent(
                      data: data.renote!,
                      isShowAction: false,
                      disableReactions: true),
                ),
              // 发布日期
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Opacity(
                  opacity: 0.7,
                  child: Text(timeToDesiredFormat(data.createdAt)),
                ),
              ),
              ReactionsListComponent(
                emojis: data.reactionEmojis,
                reactionsList: data.reactions,
                id: data.id,
                myReaction: data.myReaction,
              ),
              const SizedBox(
                height: 4,
              ),
              TimeLineActions(
                fontsize: 14,
                data: data,
              )
            ],
          ),
        );
      },
    );
  }
}

class UserInfo extends HookConsumerWidget {
  const UserInfo({
    super.key,
    required this.data,
    this.suffix,
  });

  final UserLiteModel data;
  final Widget? suffix;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return Row(
      children: [
        GestureDetector(
          child: MkImage(
            data.avatarUrl ?? "",
            width: 56,
            height: 56,
            shape: BoxShape.circle,
          ),
          onTap: () {
            MainRouterDelegate.of(context).setNewRoutePath(RouterItem(
              path: "user/${data.id}",
              page: () {
                return UserPage(userId: data.id);
              },
            ));
          },
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: GestureDetector(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MFMText(
                  text: data.name ?? data.username,
                  emojis: data.emojis,
                  bigEmojiCode: false,
                  feature: const [MFMFeature.emojiCode],
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "@${data.username}",
                      ),
                      if (data.host != null)
                        TextSpan(
                          text: "@${data.host}",
                          style: TextStyle(
                            color: themes.fgColor.withOpacity(0.7),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                if (data.instance != null) UserInstanceBar(data: data)
              ],
            ),
            onTap: () {
              MainRouterDelegate.of(context).setNewRoutePath(RouterItem(
                path: "user/${data.id}",
                page: () {
                  return UserPage(userId: data.id);
                },
              ));
            },
          ),
        ),
        if (suffix != null) suffix!
      ],
    );
  }
}

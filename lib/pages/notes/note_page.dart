import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:misskey/models/note.dart';
import 'package:misskey/networks/timeline.dart';
import 'package:misskey/state/themes.dart';
import 'package:misskey/widgets/loading_weight.dart';
import 'package:misskey/widgets/mk_header.dart';

import '../../main.dart';
import '../../networks/notes.dart';
import '../../utils/time_ago_since_date.dart';
import '../../utils/time_to_desired_format.dart';
import '../../widgets/mfm_text/mfm_text.dart';
import '../../widgets/mk_card.dart';
import '../../widgets/mk_image.dart';
import '../../widgets/mk_scaffold.dart';
import '../../widgets/notes/note_card.dart';
import '../../widgets/reactions.dart';

class NotesPage extends HookConsumerWidget {
  const NotesPage({super.key, required this.noteId});
  final String noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.of(context).padding;
    var themes = ref.watch(themeColorsProvider);
    var notes = notesProvider(noteId);
    var children = notesChildTimelineProvider(noteId);
    var dataProvider = ref.watch(notes);
    var childrenProvider = ref.watch(children);

    var loadConversation = useState<Future?>(null);
    var loadConversationSnapshot = useFuture(loadConversation.value);

    var data = ref.watch(noteListProvider.select((value) => value[noteId]));
    logger.d(childrenProvider.error);
    logger.d(childrenProvider.stackTrace);
    logger.d(dataProvider.error);
    logger.d(dataProvider.stackTrace);
    var childrenList = childrenProvider.valueOrNull ?? [];
    var conversation = dataProvider.valueOrNull?.conversation ?? [];
    NotesListener note = ref.watch(notesListenerProvider.notifier);
    useEffect(() {
      var code = hashCode.toString();
      if (data != null) {
        note.subNote(data, code);
      }

      return () => {
            if (data != null) {note.unsubNote(data, code)}
          };
    }, [data]);
    return LayoutBuilder(
      builder: (context, constraints) {
        double padding = 0;
        if (constraints.maxWidth > 860) {
          padding = (constraints.maxWidth - 800) / 2;
        } else if (constraints.maxWidth > 500) {
          padding = 30;
        } else if (constraints.maxWidth > 400) {
          padding = 8;
        } else {
          padding = 0;
        }
        // var notifier = ref.read(notesListenerProvider.notifier);
        // var data =  dataProvider.valueOrNull?.data ?? {};

        // logger.d(data);
        return MkScaffold(
            header: MkAppbar(
              showBack: true,
              content: Row(
                children: [
                  if (!dataProvider.isLoading || data != null) ...[
                    MkImage(
                      data?.user.avatarUrl ?? "",
                      shape: BoxShape.circle,
                      width: 32,
                      height: 32,
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
              trailing: TextButton(onPressed: () {}, child: const Text("关注")),
            ),
            body: [
              if (!dataProvider.isLoading || data != null)
                SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                        padding, 56 + mediaPadding.top, padding, 0),
                    child: Column(
                      children: [
                        MkCard(
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
                              NoteCard(data: data!)
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: themes.dividerColor),
                          height: 1,
                        ),
                        if (childrenProvider.isLoading)
                          const SizedBox(
                            width: double.infinity,
                            child: MkCard(
                              padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
                              shadow: false,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12)),
                              child: Column(
                                children: [LoadingCircularProgress()],
                              ),
                            ),
                          ),
                        if (childrenProvider.hasError)
                          MkCard(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                            shadow: false,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(childrenProvider.error.toString()),
                                Text(childrenProvider.stackTrace.toString()),
                              ],
                            ),
                          ),
                        if (!childrenProvider.isLoading && childrenList.isEmpty)
                          const MkCard(
                            padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
                            shadow: false,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12)),
                            child: Center(
                              child: Text("回复为空"),
                            ),
                          ),
                        for (var (index, item) in childrenList.indexed) ...[
                          Container(
                            decoration:
                                BoxDecoration(color: themes.dividerColor),
                            height: 1,
                          ),
                          MkCard(
                            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                            shadow: false,
                            borderRadius: BorderRadius.only(
                              bottomLeft: (childrenList.length == index + 1)
                                  ? const Radius.circular(12)
                                  : Radius.zero,
                              bottomRight: (childrenList.length == index + 1)
                                  ? const Radius.circular(12)
                                  : Radius.zero,
                            ),
                            child: Builder(builder: (context) {
                              List<NoteModel> list = item;
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var (index, item1) in list.indexed)
                                    TimeLineNoteCardComponent(
                                      data: item1,
                                      reply: index != (list.length - 1),
                                    )
                                ],
                              );
                            }),
                          ),
                        ],
                        const SizedBox(
                          height: 88,
                        )
                      ],
                    ))
              else if (dataProvider.hasError)
                SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                        padding, 56 + mediaPadding.top, padding, 0),
                    child: Column(
                      children: [
                        MkCard(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                          shadow: false,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (dataProvider.error is DioException)
                                Text((dataProvider.error as DioException)
                                    .response
                                    .toString())
                              else
                                Text(dataProvider.error.toString()),
                              Text(dataProvider.stackTrace.toString()),
                            ],
                          ),
                        ),
                      ],
                    ))
              else
                const LoadingWidget()
            ][0]);
      },
    );
  }
}

class NoteCard extends HookConsumerWidget {
  const NoteCard({super.key, required this.data});
  final NoteModel data;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isHiddenCw = useState(true);
    var themes = ref.watch(themeColorsProvider);
    var data = ref.watch(
        noteListProvider.select((value) => value[this.data.id] ?? this.data));
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            UserInfo(data: data),
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
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.hovered)) {
                          return themes.buttonHoverBgColor;
                        }
                        return themes.buttonBgColor;
                      }),
                      foregroundColor:
                          MaterialStateProperty.all(themes.fgColor),
                      elevation: MaterialStateProperty.all(0)),
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
                  currentServerHost: data.user.host ?? "",
                  isSelection: true,
                ),
              const SizedBox(height: 4),
              // 投票
              if (data.poll != null) PollCard(data: data),
              TimeLineImage(
                  files: data.files,
                  mainAxisExtent: constraints.maxWidth * 0.7),
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
                    data: data.renote,
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
        );
      },
    );
  }
}

class UserInfo extends HookConsumerWidget {
  const UserInfo({super.key, required this.data});
  final NoteModel data;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return Row(
      children: [
        MkImage(
          data.user.avatarUrl ?? "",
          width: 56,
          height: 56,
          shape: BoxShape.circle,
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
                text: data.user.name ?? data.user.username,
                emojis: data.user.emojis,
                bigEmojiCode: false,
                feature: const [MFMFeature.emojiCode],
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "@${data.user.username}",
                    ),
                    if (data.user.host != null)
                      TextSpan(
                        text: "@${data.user.host}",
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
              if (data.user.instance != null) UserInstanceBar(data: data)
            ],
          ),
        ),
        if (NoteVisibility.getIcon(data.visibility) != null)
          Icon(
            NoteVisibility.getIcon(data.visibility)!,
            size: 16,
            color: themes.fgColor,
          )
      ],
    );
  }
}

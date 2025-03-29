import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/drive.dart';
import 'package:moekey/apis/models/meta.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/context_menu.dart';
import 'package:moekey/widgets/emoji_list.dart';
import 'package:moekey/widgets/hover_builder.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/mk_image.dart';
import 'package:moekey/widgets/mk_input.dart';
import 'package:moekey/widgets/mk_modal.dart';
import 'package:moekey/widgets/note_create_dialog/note_create_dialog_state.dart';
import 'package:moekey/widgets/user_select_dialog/user_select_dialog.dart';

import '../../apis/models/note.dart';
import '../../generated/l10n.dart';
import '../../logger.dart';
import '../../utils/time_ago_since_date.dart';
import '../driver/drive_thumbnail.dart';
import '../driver/driver_select_dialog/driver_select_dialog.dart';
import '../hashtag/hashtag_select_dialog.dart';
import '../mk_switch.dart';
import '../notes/note_card.dart';

class NoteCreateDialog extends HookConsumerWidget {
  const NoteCreateDialog({
    super.key,
    this.noteId,
    this.noteType = NoteType.note,
    this.note,
    this.initText,
    this.files,
  });

  static final GlobalKey myKey = GlobalKey();
  final String? noteId;
  final NoteType noteType;
  final NoteModel? note;
  final String? initText;
  final List<DriveFileModel>? files;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        var isFullscreen = constraints.maxWidth < 580;
        var keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        var queryPadding = MediaQuery.of(context).padding;
        var topPadding = isFullscreen ? queryPadding.top : 0.0;
        Widget form = MkCard(
          key: myKey,
          padding: const EdgeInsets.all(8).copyWith(top: 8 + topPadding),
          borderRadius: isFullscreen
              ? const BorderRadius.all(Radius.zero)
              : const BorderRadius.all(
                  Radius.circular(12),
                ),
          child: buildWidget(themes, isFullscreen, keyboardHeight),
        );

        // if (!isFullscreen) {
        //   form = IntrinsicHeight(child: form);
        // }
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          behavior: HitTestBehavior.opaque,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  AnimatedPositioned(
                      duration: const Duration(milliseconds: 500),
                      top: isFullscreen ? 0 : 40,
                      child: GestureDetector(
                        onTap: () {},
                        child: SizedBox(
                          width: isFullscreen ? constraints.maxWidth : 560,
                          height: isFullscreen ? constraints.maxHeight : null,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: 0,
                                maxHeight: isFullscreen
                                    ? constraints.maxHeight
                                    : constraints.maxHeight - 80),
                            child: form,
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildWidget(
      ThemeColorModel themes, bool fullscreen, double keyboardHeight) {
    return HookConsumer(
      builder: (context, ref, child) {
        MetaDetailedModel? data = ref.watch(instanceMetaProvider).valueOrNull;
        var form = ref.watch(noteCreateDialogStateProvider(noteId, noteType));
        var contentController =
            useTextEditingController(text: form.text ?? initText);
        if (note != null && note?.cw != null) {
          form.cw = note!.cw!;
          form.isCw = true;
        }
        contentController.addListener(() {
          ref
              .read(noteCreateDialogStateProvider(noteId, noteType).notifier)
              .setText(contentController.text);
        });
        return IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
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
                    width: 8,
                  ),
                  Text(
                    [
                      if (noteType == NoteType.reply) S.current.replyNoteText,
                      if (noteType == NoteType.reNote) S.current.reNoteText,
                      S.current.createNote
                    ][0],
                    style: const TextStyle(fontSize: 15),
                  ),
                  const Spacer(),
                  buildVisibilityBottomList(themes),
                  const SizedBox(width: 8),
                  buildLocalOnlyBottom(themes),
                  const SizedBox(width: 8),
                  buildReactionAcceptanceBottom(themes),
                  const SizedBox(width: 8),
                  Tooltip(
                    message: S.current.publish,
                    child: FilledButton(
                      onPressed: () async {
                        var res = await ref
                            .read(
                                noteCreateDialogStateProvider(noteId, noteType)
                                    .notifier)
                            .send(context);
                        if (res != null) {
                          contentController.text = initText ?? "";
                          if (context.mounted) {
                            Navigator.of(context).pop(res);
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all(themes.accentColor),
                        shape: WidgetStateProperty.all(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                        ),
                        elevation: WidgetStateProperty.all(0),
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.fromLTRB(12, 0, 12, 0),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(S.current.publish),
                          const SizedBox(
                            width: 2,
                          ),
                          const Icon(
                            TablerIcons.send,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              if (form.visibility == NoteVisibility.specified) buildRecipient(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (note != null) buildNotePreview(themes),
                      if (!form.preview)
                        buildTextField(data, fullscreen, contentController)
                      else
                        buildPreview(data),
                      if (form.files.isNotEmpty) ...[
                        buildDriverList(),
                        const SizedBox(
                          height: 8,
                        )
                      ],
                      if (form.isNotePoll) buildPollCard(fullscreen),
                    ],
                  ),
                ),
              ),
              buildBottomBar(contentController, fullscreen, keyboardHeight),
              if (!fullscreen)
                AnimatedContainer(
                  height:
                      form.isShowEmoji ? form.emojiListHeight.toDouble() : 0,
                  duration: const Duration(milliseconds: 300),
                  child: EmojiList(
                    onInsert: (data) {
                      contentController.text =
                          "${contentController.text}${data["name"]}";
                    },
                  ),
                )
              else
                SizedBox(
                  height: keyboardHeight,
                )
            ],
          ),
        );
      },
    );
  }

  Padding buildNotePreview(ThemeColorModel themes) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MkImage(
            note!.user.avatarUrl ?? "",
            shape: BoxShape.circle,
            width: 48,
            height: 48,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: UserNameRichText(data: note!.user)),
                    Text(timeAgoSinceDate(note!.createdAt),
                        style: const TextStyle(fontSize: 12)),
                    const SizedBox(
                      width: 6,
                    ),
                    if (NoteVisibility.getIcon(note!.visibility) != null)
                      Icon(
                        NoteVisibility.getIcon(note!.visibility)!,
                        size: 14,
                        color: themes.fgColor,
                      )
                  ],
                ),
                if (note!.cw != null)
                  MFMText(
                    key: ValueKey(note!.cw ?? ""),
                    text: note!.cw ?? "",
                    emojis: note!.emojis,
                    currentServerHost: note!.user.host,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                MFMText(
                  key: ValueKey(note!.text ?? ""),
                  text: note!.text ?? "",
                  emojis: note!.emojis,
                  currentServerHost: note!.user.host,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildRecipient() {
    return HookConsumer(
      builder: (context, ref, child) {
        var themes = ref.watch(themeColorsProvider);
        var data = ref.watch(noteCreateDialogStateProvider(noteId, noteType)
            .select((value) => value.visibleUserIds));
        logger.d(data);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(S.current.recipient),
              for (var key in data.keys)
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: themes.mentionColor.withAlpha(25)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 22,
                        height: 22,
                        child: MkImage(data[key]["avatarUrl"],
                            shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 2),
                      if (data[key]["username"] != null)
                        Text(
                          "@${data[key]["username"]}",
                          style: TextStyle(color: themes.mentionColor),
                        ),
                      if (data[key]["host"] != null)
                        Text(
                          "@${data[key]["host"]}",
                          style: TextStyle(
                            color: themes.mentionColor.withAlpha(178),
                          ),
                        ),
                      const SizedBox(width: 2),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            ref
                                .read(noteCreateDialogStateProvider(
                                        noteId, noteType)
                                    .notifier)
                                .removeVisibleUser(key);
                          },
                          child: Icon(TablerIcons.x,
                              size: 15, color: themes.mentionColor),
                        ),
                      ),
                      const SizedBox(width: 2),
                    ],
                  ),
                ),
              SizedBox(
                width: 28,
                height: 28,
                child: Tooltip(
                  message: S.current.add,
                  child: IconButton(
                    onPressed: () async {
                      var list = await showModel(
                        context: context,
                        builder: (context) {
                          return const UserSelectDialog();
                        },
                      );
                      for (var item in list ?? []) {
                        ref
                            .read(
                                noteCreateDialogStateProvider(noteId, noteType)
                                    .notifier)
                            .addVisibleUser(item["id"], item);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(themes.accentColor),
                      shape: WidgetStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                      elevation: WidgetStateProperty.all(0),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                    ),
                    icon: Icon(
                      TablerIcons.plus,
                      size: 16,
                      color: themes.fgOnAccentColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildPollCard(bool isFullscreen) {
    return HookConsumer(
      builder: (context, ref, child) {
        var form = ref.watch(noteCreateDialogStateProvider(noteId, noteType));
        var themes = ref.watch(themeColorsProvider);
        Widget widget = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (form.poll!.choices.length < 2) ...[
              Text(
                S.current.voteOptionAtLeastTwo,
                style: TextStyle(color: themes.errorColor),
              ),
              const SizedBox(height: 8)
            ],
            for (var (index, (key, item))
                in (form.poll?.choices ?? []).indexed) ...[
              Row(
                children: [
                  Expanded(
                    child: MkInput(
                      key: key,
                      hintText: S.current.voteOptionHint(index + 1),
                      value: item,
                      onChanged: (value) {
                        ref
                            .read(
                                noteCreateDialogStateProvider(noteId, noteType)
                                    .notifier)
                            .setPollChoices(index, value);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  HoverBuilder(
                    builder: (context, isHover) {
                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(noteCreateDialogStateProvider(
                                      noteId, noteType)
                                  .notifier)
                              .removePollChoices(index);
                        },
                        child: Icon(
                          TablerIcons.x,
                          size: 18,
                          color: themes.fgColor,
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                ],
              ),
              const SizedBox(height: 8)
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: form.poll!.choices.length >= 10
                      ? null
                      : () {
                          ref
                              .read(noteCreateDialogStateProvider(
                                      noteId, noteType)
                                  .notifier)
                              .addPollChoices();
                        },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(themes.buttonBgColor),
                    shape: WidgetStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    elevation: WidgetStateProperty.all(0),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.fromLTRB(32, 0, 32, 0),
                    ),
                  ),
                  child: Text(
                    S.current.add,
                    style: TextStyle(color: themes.fgColor),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                const Spacer(),
                Text(S.current.voteEnableMultiChoice),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                  height: 32,
                  child: FittedBox(
                    child: MkSwitch(
                      key: const ValueKey("m"),
                      value: form.poll!.multiple,
                      onChanged: (value) {
                        ref
                            .read(
                                noteCreateDialogStateProvider(noteId, noteType)
                                    .notifier)
                            .setPollMultiple(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(S.current.voteDueDate),
                const Spacer(),
                Text(S.current.voteNoDueDate),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                  height: 32,
                  child: FittedBox(
                    child: MkSwitch(
                      value: form.poll!.never,
                      onChanged: (value) {
                        ref
                            .read(
                                noteCreateDialogStateProvider(noteId, noteType)
                                    .notifier)
                            .setPollNever(value);
                      },
                    ),
                  ),
                )
              ],
            ),
            if (!form.poll!.never) ...[
              const SizedBox(
                height: 8,
              ),
              HookConsumer(
                builder: (context, ref, child) {
                  var form = ref
                      .watch(noteCreateDialogStateProvider(noteId, noteType));
                  return Row(
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.current.day),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                decoration: inputDecoration(
                                  themes,
                                  S.current.day,
                                ),
                                style: const TextStyle(fontSize: 14),
                                cursorWidth: 1,
                                cursorColor: themes.fgColor,
                                maxLines: 1,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,

                                  // FilteringTextInputFormatter.allow(
                                  //     RegExp(r'^([1-9]\d{0,3}|0)$')),
                                ],
                                onChanged: (value) {
                                  ref
                                      .read(noteCreateDialogStateProvider(
                                              noteId, noteType)
                                          .notifier)
                                      .setPollTime(
                                          days: int.tryParse(value) ?? 0);
                                },
                                initialValue: form.poll!.days.toString(),
                              )),
                            ],
                          )
                        ],
                      )),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.current.hour),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                decoration: inputDecoration(
                                  themes,
                                  S.current.hour,
                                ),
                                // style: const TextStyle(fontSize: 14),
                                cursorWidth: 1,
                                cursorColor: themes.fgColor,
                                maxLines: 1,
                                textAlignVertical: TextAlignVertical.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  FilteringTextInputFormatter(
                                      RegExp(r'^([01]?[0-9]|2[0-4])$'),
                                      allow: true)
                                ],
                                onChanged: (value) {
                                  ref
                                      .read(noteCreateDialogStateProvider(
                                              noteId, noteType)
                                          .notifier)
                                      .setPollTime(
                                          hours: int.tryParse(value) ?? 0);
                                },
                                initialValue: form.poll!.hours.toString(),
                              )),
                            ],
                          )
                        ],
                      )),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.current.minute),
                          const SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: inputDecoration(
                                    themes,
                                    S.current.minute,
                                  ),
                                  style: const TextStyle(fontSize: 14),
                                  cursorWidth: 1,
                                  cursorColor: themes.fgColor,
                                  maxLines: 1,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    FilteringTextInputFormatter(
                                        RegExp(r'^([0-5]?[0-9]|60)$'),
                                        allow: true)
                                  ],
                                  onChanged: (value) {
                                    ref
                                        .read(noteCreateDialogStateProvider(
                                                noteId, noteType)
                                            .notifier)
                                        .setPollTime(
                                            minutes: int.tryParse(value) ?? 0);
                                  },
                                  initialValue: form.poll!.minutes.toString(),
                                ),
                              ),
                            ],
                          )
                        ],
                      ))
                    ],
                  );
                },
              )
            ]
          ],
        );

        // widget = ConstrainedBox(
        //   constraints: BoxConstraints(maxHeight: isFullscreen ? 400 : 500),
        //   child: SingleChildScrollView(
        //     child: widget,
        //   ),
        // );

        return Padding(
          padding: const EdgeInsets.all(8),
          child: widget,
        );
      },
    );
  }

  Widget buildDriverList() {
    return HookConsumer(
      builder: (context, ref, child) {
        var themes = ref.watch(themeColorsProvider);
        var provider = noteCreateDialogStateProvider(noteId, noteType);
        var form = ref.watch(provider);
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var (index, item) in form.files.indexed)
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                        child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: DriverFileIcon(
                        data: item,
                        themes: themes,
                        fit: BoxFit.cover,
                      ),
                    )),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            ref.read(provider.notifier).removeFile(index);
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Colors.black.withAlpha(100),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            child: const Center(
                              child: Icon(
                                TablerIcons.x,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
          ],
        );
      },
    );
  }

  Widget buildBottomBar(TextEditingController contentController,
      bool isFullscreen, double keyboardHeight) {
    return HookConsumer(
      builder: (context, ref, child) {
        var form = ref.watch(noteCreateDialogStateProvider(noteId, noteType));
        var themes = ref.watch(themeColorsProvider);

        return Row(
          children: [
            DriverSelectContextMenu(
              builder: (context, open) {
                return buildActionBottom(
                    onPressed: () {
                      open();
                    },
                    context: context,
                    tooltip: S.current.insertDriverFile,
                    icon: TablerIcons.photo_plus);
              },
              selectCallback: (List<DriveFileModel> files) {
                ref
                    .read(noteCreateDialogStateProvider(noteId, noteType)
                        .notifier)
                    .addFileList(files);
              },
            ),
            const SizedBox(
              width: 4,
            ),
            buildActionBottom(
                onPressed: () {
                  if (!form.isNotePoll) {
                    ref
                        .read(noteCreateDialogStateProvider(noteId, noteType)
                            .notifier)
                        .createPoll();
                  } else {
                    ref
                        .read(noteCreateDialogStateProvider(noteId, noteType)
                            .notifier)
                        .removePoll();
                  }
                },
                context: context,
                tooltip: S.current.vote,
                icon: TablerIcons.chart_arrows,
                color: form.isNotePoll ? themes.accentColor : null),
            const SizedBox(
              width: 4,
            ),
            buildActionBottom(
                onPressed: () {
                  ref
                      .read(noteCreateDialogStateProvider(noteId, noteType)
                          .notifier)
                      .setIsCw(!form.isCw);
                },
                context: context,
                tooltip: S.current.cw,
                icon: TablerIcons.eye_off,
                color: form.isCw ? themes.accentColor : null),
            const SizedBox(
              width: 4,
            ),
            buildActionBottom(
                onPressed: () async {
                  var list = await showModel(
                    context: context,
                    builder: (context) {
                      return const UserSelectDialog();
                    },
                  );
                  print(list);
                  if (list != null && list != []) {
                    contentController.text = "${contentController.text} ${[
                      for (var item in list ?? [])
                        "@${item?.username}${item?.host != null ? "@${item?.host}" : ""}"
                    ].join(" ")} ";
                    ref
                        .read(noteCreateDialogStateProvider(noteId, noteType)
                            .notifier)
                        .setText(contentController.text);
                  }
                },
                context: context,
                tooltip: S.current.mention,
                icon: TablerIcons.at),
            const SizedBox(
              width: 4,
            ),
            buildActionBottom(
                onPressed: () async {
                  var list = await showModel(
                    context: context,
                    builder: (context) {
                      return const HashtagSelectDialog();
                    },
                  );
                  if (list != null && list != []) {
                    contentController.text = "${contentController.text}${[
                      for (var item in list ?? []) "#$item"
                    ].join(" ")} ";
                    ref
                        .read(noteCreateDialogStateProvider(noteId, noteType)
                            .notifier)
                        .setText(contentController.text);
                  }
                },
                context: context,
                tooltip: S.current.hashtag,
                icon: TablerIcons.hash),
            const SizedBox(
              width: 4,
            ),
            buildActionBottom(
                onPressed: () {
                  var maxSize = 350.0;

                  if (!isFullscreen) {
                    maxSize = MediaQuery.of(context).size.height -
                        (myKey.currentContext?.size?.height ?? 0) -
                        40;
                    maxSize = maxSize.clamp(250, 350);
                  }
                  if (isFullscreen) {
                    EmojiList.showBottomSheet(context,
                        onInsert: (data, context) {
                      contentController.text =
                          "${contentController.text}${data["name"]}";
                    });
                  } else {
                    ref
                        .read(noteCreateDialogStateProvider(noteId, noteType)
                            .notifier)
                        .setEmojiListHeight(maxSize);
                    ref
                        .read(noteCreateDialogStateProvider(noteId, noteType)
                            .notifier)
                        .setIsShowEmoji(!form.isShowEmoji);
                  }
                },
                context: context,
                tooltip: S.current.emoji,
                icon: TablerIcons.mood_happy,
                color: form.isShowEmoji ? themes.accentColor : null),
            const Spacer(),
            buildActionBottom(
                onPressed: () {
                  ref
                      .read(noteCreateDialogStateProvider(noteId, noteType)
                          .notifier)
                      .setPreview(!form.preview);
                },
                context: context,
                tooltip: S.current.previewNote,
                icon: TablerIcons.eye,
                color: form.preview ? themes.accentColor : null),
          ],
        );
      },
    );
  }

  Widget buildActionBottom(
      {required BuildContext context,
      required void Function()? onPressed,
      required String tooltip,
      required IconData icon,
      Color? color}) {
    return HookConsumer(builder: (context, ref, child) {
      var themes = ref.watch(themeColorsProvider);
      return Tooltip(
        message: tooltip,
        child: IconButton(
          onPressed: onPressed,
          style: ButtonStyle(
            foregroundColor: WidgetStateProperty.all(themes.fgColor),
            shape: WidgetStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.fromLTRB(0, 0, 0, 0),
            ),
          ),
          icon: Icon(icon, size: 16, color: color),
        ),
      );
    });
  }

  Widget buildTextField(MetaDetailedModel? meta, bool isFullscreen,
      TextEditingController contentController) {
    return HookConsumer(
      builder: (context, ref, child) {
        var state = ref.watch(noteCreateDialogStateProvider(noteId, noteType));
        return Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.isCw) ...[
                TextFormField(
                  key: const ValueKey("cw"),
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: S.current.cw,
                      isDense: true),
                  maxLines: 1,
                  initialValue: state.cw,
                  style: DefaultTextStyle.of(context).style,
                  onChanged: (value) {
                    ref
                        .read(noteCreateDialogStateProvider(noteId, noteType)
                            .notifier)
                        .setCw(value);
                  },
                ),
                const Divider(),
              ],
              TextFormField(
                controller: contentController,
                key: const ValueKey("text"),
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: [
                    if (noteType == NoteType.reply) S.current.replyNoteHint,
                    if (noteType == NoteType.reNote) S.current.reNoteHint,
                    S.current.createNoteHint
                  ][0],
                  isDense: true,
                ),
                minLines: isFullscreen ? 4 : 4,
                maxLines: isFullscreen ? 200 : 100,
                maxLength: meta?.maxNoteTextLength.toInt() ?? 300,

                // initialValue: state.text,
                onChanged: (value) {
                  ref
                      .read(noteCreateDialogStateProvider(noteId, noteType)
                          .notifier)
                      .setText(value);
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget buildReactionAcceptanceBottom(ThemeColorModel themes) {
    return HookConsumer(builder: (context, ref, child) {
      var stats = ref.watch(noteCreateDialogStateProvider(noteId, noteType));
      return Tooltip(
        message: S.current.reactionAccepting,
        child: SizedBox(
          width: 32,
          child: ContextMenuBuilder(
            maskColor: Colors.black.withAlpha(128),
            menu: ContextMenuCard(
              width: 250,
              menuListBuilder: () {
                return [
                  ContextMenuItem(
                      label: S.current.reactionAcceptingAll,
                      isActive: stats.reactionAcceptance == null,
                      onTap: () {
                        ref
                            .read(
                                noteCreateDialogStateProvider(noteId, noteType)
                                    .notifier)
                            .setReactionAcceptance(null);
                        return false;
                      }),
                  ContextMenuItem(
                      label: S.current.reactionAcceptingLikeOnlyRemote,
                      isActive: stats.reactionAcceptance ==
                          NoteReactionAcceptance.likeOnlyForRemote,
                      onTap: () {
                        ref
                            .read(
                                noteCreateDialogStateProvider(noteId, noteType)
                                    .notifier)
                            .setReactionAcceptance(
                                NoteReactionAcceptance.likeOnlyForRemote);
                        return false;
                      }),
                  ContextMenuItem(
                      label: S.current.reactionAcceptingNoneSensitive,
                      isActive: stats.reactionAcceptance ==
                          NoteReactionAcceptance.nonSensitiveOnly,
                      onTap: () {
                        ref
                            .read(
                                noteCreateDialogStateProvider(noteId, noteType)
                                    .notifier)
                            .setReactionAcceptance(
                                NoteReactionAcceptance.nonSensitiveOnly);
                        return false;
                      }),
                  ContextMenuItem(
                      label: S.current.reactionAcceptingNoneSensitiveOrLocal,
                      isActive: stats.reactionAcceptance ==
                          NoteReactionAcceptance
                              .nonSensitiveOnlyForLocalLikeOnlyForRemote,
                      onTap: () {
                        ref
                            .read(
                                noteCreateDialogStateProvider(noteId, noteType)
                                    .notifier)
                            .setReactionAcceptance(NoteReactionAcceptance
                                .nonSensitiveOnlyForLocalLikeOnlyForRemote);
                        return false;
                      }),
                  ContextMenuItem(
                      label: S.current.reactionAcceptingLikeOnly,
                      isActive: stats.reactionAcceptance ==
                          NoteReactionAcceptance.likeOnly,
                      onTap: () {
                        ref
                            .read(
                                noteCreateDialogStateProvider(noteId, noteType)
                                    .notifier)
                            .setReactionAcceptance(
                                NoteReactionAcceptance.likeOnly);
                        return false;
                      }),
                ];
              },
            ),
            child: Builder(
              builder: (context) {
                return TextButton(
                  onPressed: () {
                    RenderBox box = context.findRenderObject() as RenderBox;
                    var y = box.localToGlobal(Offset.zero).dy + box.size.height;
                    var x = box.localToGlobal(Offset.zero).dx -
                        125 +
                        box.size.width / 2;
                    context
                        .findAncestorStateOfType<ContextMenuBuilderState>()
                        ?.show(Offset(x, y));
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(themes.fgColor),
                    shape: WidgetStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    ),
                  ),
                  child: Icon(
                    TablerIcons.icons,
                    color: themes.fgColor,
                    size: 16,
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }

  Widget buildLocalOnlyBottom(ThemeColorModel themes) {
    return HookConsumer(
      builder: (context, ref, child) {
        var state = ref.watch(noteCreateDialogStateProvider(noteId, noteType));
        return Tooltip(
          message: S.current.noteLocalOnly,
          child: SizedBox(
            width: 32,
            child: TextButton(
              onPressed: () {
                if (state.visibility == NoteVisibility.specified) return;
                ref
                    .read(noteCreateDialogStateProvider(noteId, noteType)
                        .notifier)
                    .setLocalOnly(!state.localOnly);
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(
                    state.localOnly ? themes.errorColor : themes.fgColor),
                shape: WidgetStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.fromLTRB(0, 0, 0, 0),
                ),
              ),
              child: Opacity(
                opacity: state.visibility == NoteVisibility.specified ? 0.5 : 1,
                child: Icon(
                  state.localOnly ? TablerIcons.rocket_off : TablerIcons.rocket,
                  color: themes.fgColor,
                  size: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildVisibilityBottomList(ThemeColorModel themes) {
    return HookConsumer(builder: (context, ref, child) {
      var state = ref.watch(noteCreateDialogStateProvider(noteId, noteType));
      var icon = switch (state.visibility) {
        NoteVisibility.public => TablerIcons.world,
        NoteVisibility.home => TablerIcons.home,
        NoteVisibility.followers => TablerIcons.lock,
        NoteVisibility.specified => TablerIcons.mail,
      };
      return Tooltip(
        message: S.current.noteVisibility,
        child: SizedBox(
          width: 32,
          child: ContextMenuBuilder(
              maskColor: Colors.black.withAlpha(128),
              menu: ContextMenuCard(
                width: 250,
                widgetBuilder: ({required onHidden, required bool large}) {
                  return HookConsumer(
                    builder: (context, ref, child) {
                      var state = ref.watch(
                          noteCreateDialogStateProvider(noteId, noteType));
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!large)
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 14, top: 8, bottom: 4),
                              child: Opacity(
                                opacity: 0.7,
                                child: Text(
                                  S.current.noteVisibility,
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ),
                          buildVisibilityBottom(
                              state,
                              themes,
                              S.current.noteVisibilityPublic,
                              S.current.noteVisibilityPublicText,
                              TablerIcons.world,
                              NoteVisibility.public,
                              state.visibility,
                              onHidden,
                              large),
                          buildVisibilityBottom(
                              state,
                              themes,
                              S.current.noteVisibilityHome,
                              S.current.noteVisibilityHomeText,
                              TablerIcons.home,
                              NoteVisibility.home,
                              state.visibility,
                              onHidden,
                              large),
                          buildVisibilityBottom(
                              state,
                              themes,
                              S.current.noteVisibilityFollowers,
                              S.current.noteVisibilityFollowersText,
                              TablerIcons.lock,
                              NoteVisibility.followers,
                              state.visibility,
                              onHidden,
                              large),
                          buildVisibilityBottom(
                              state,
                              themes,
                              S.current.noteVisibilitySpecified,
                              S.current.noteVisibilitySpecifiedText,
                              TablerIcons.mail,
                              NoteVisibility.specified,
                              state.visibility,
                              onHidden,
                              large),
                        ],
                      );
                    },
                  );
                },
              ),
              mode: const [ContextMenuMode.onTap],
              alignmentChild: true,
              child: Builder(builder: (context) {
                return TextButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(themes.fgColor),
                    shape: WidgetStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    ),
                  ),
                  onPressed: () {
                    context
                        .findAncestorStateOfType<ContextMenuBuilderState>()
                        ?.show(Offset.zero);
                  },
                  child: Icon(
                    icon,
                    size: 16,
                    color: themes.fgColor,
                  ),
                );
              })),
        ),
      );
    });
  }

  Widget buildVisibilityBottom(
    NoteCreateDialogStateModel state,
    ThemeColorModel themes,
    String title,
    String desc,
    IconData icon,
    value,
    currentValue,
    onHidden,
    bool large,
  ) {
    return HookConsumer(
      builder: (context, ref, child) {
        return HoverBuilder(
          builder: (context, isHover) {
            return DefaultTextStyle(
              style: DefaultTextStyle.of(context).style.copyWith(
                  color: value == currentValue
                      ? themes.accentColor
                      : themes.fgColor),
              child: GestureDetector(
                onTap: () {
                  ref
                      .read(noteCreateDialogStateProvider(noteId, noteType)
                          .notifier)
                      .setVisibility(value);
                  onHidden();
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  color:
                      isHover ? Colors.black.withAlpha(12) : Colors.transparent,
                  padding: EdgeInsets.symmetric(
                      horizontal: large ? 20 : 14, vertical: large ? 16 : 8),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        size: large ? 20 : 16,
                        color: value == currentValue
                            ? themes.accentColor
                            : themes.fgColor,
                      ),
                      SizedBox(
                        width: large ? 16 : 12,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: large ? 14 : 12),
                          ),
                          Text(
                            desc,
                            style: TextStyle(fontSize: large ? 13 : 12),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static open({
    required BuildContext context,
    String? noteId,
    NoteType type = NoteType.note,
    NoteModel? note,
    String? initText,
    List<DriveFileModel>? files,
  }) {
    showModel(
      context: context,
      builder: (p0) {
        return NoteCreateDialog(
          noteId: noteId,
          noteType: type,
          note: note,
          initText: initText,
          files: files,
        );
      },
    );
  }

  buildPreview(data) {
    return HookConsumer(
      builder: (context, ref, child) {
        var state = ref.watch(noteCreateDialogStateProvider(noteId, noteType));
        return Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (state.isCw) ...[
                MFMText(text: state.cw),
                const Divider(),
              ],
              MFMText(text: state.text ?? ""),
            ],
          ),
        );
      },
    );
  }
}

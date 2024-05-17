import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/context_menu.dart';
import 'package:moekey/widgets/hover_builder.dart';
import 'package:path/path.dart';

import '../../apis/models/drive.dart';
import '../../status/drive.dart';
import '../mk_dialog.dart';
import '../mk_image.dart';

class DriveImageThumbnail extends HookConsumerWidget {
  DriveImageThumbnail(
      {super.key, required data, this.isSelect = false, this.onRemove}) {
    this.data = data["data"];
    type = data["type"];
  }

  late final dynamic data;
  late final String type;
  final bool isSelect;
  final void Function()? onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);

    return ContextMenuBuilder(
        mode: const [
          ContextMenuMode.onSecondaryTap,
          ContextMenuMode.onLongPress
        ],
        menu: ContextMenuCard(
          initialChildSize: type == "folder" ? 0.3 : 0.6,
          maxChildSize: type == "folder" ? 0.3 : 0.6,
          minChildSize: type == "folder" ? 0.3 : 0.6,
          width: 200,
          menuListBuilder: () {
            return [
              if (type == "folder") ...[
                ContextMenuItem(
                  label: "重命名",
                  icon: TablerIcons.forms,
                  divider: true,
                  onTap: () {
                    Timer(
                      const Duration(milliseconds: 150),
                      () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return getRenameDialog(themes);
                          },
                        );
                      },
                    );

                    return false;
                  },
                ),
                ContextMenuItem(
                    label: "删除",
                    icon: TablerIcons.trash,
                    danger: true,
                    onTap: () {
                      Timer(
                        const Duration(milliseconds: 150),
                        () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return getDeleteDialog(themes);
                            },
                          );
                        },
                      );

                      return false;
                    })
              ] else ...[
                ContextMenuItem(
                  label: "重命名",
                  icon: TablerIcons.forms,
                  onTap: () {
                    Timer(
                      const Duration(milliseconds: 150),
                      () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return getRenameDialog(themes);
                          },
                        );
                      },
                    );

                    return false;
                  },
                ),
                if (data.isSensitive)
                  ContextMenuItem(
                      label: "取消标记为敏感内容",
                      icon: TablerIcons.eye,
                      onTap: () {
                        ref
                            .read(driverUploaderProvider.notifier)
                            .updateFile(fileId: data.id, isSensitive: false);
                        return false;
                      })
                else
                  ContextMenuItem(
                    label: "标记为敏感内容",
                    icon: TablerIcons.eye_exclamation,
                    onTap: () {
                      ref
                          .read(driverUploaderProvider.notifier)
                          .updateFile(fileId: data.id, isSensitive: true);
                      return false;
                    },
                  ),
                ContextMenuItem(
                  label: "添加标题",
                  icon: TablerIcons.text_caption,
                  divider: true,
                  onTap: () {
                    Timer(
                      const Duration(milliseconds: 150),
                      () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return getCommentDialog(themes);
                          },
                        );
                      },
                    );

                    return false;
                  },
                ),
                ContextMenuItem(label: "从文件创建帖子", icon: TablerIcons.pencil),
                ContextMenuItem(label: "复制链接", icon: TablerIcons.link),
                ContextMenuItem(
                  label: "下载",
                  icon: TablerIcons.download,
                  divider: true,
                ),
                ContextMenuItem(
                  label: "删除",
                  icon: TablerIcons.trash,
                  danger: true,
                  onTap: () {
                    Timer(
                      const Duration(milliseconds: 150),
                      () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return getDeleteDialog(themes);
                          },
                        );
                      },
                    );

                    return false;
                  },
                )
              ]
            ];
          },
        ),
        child: GestureDetector(
          onTap: type == "folder"
              ? () {
                  ref
                      .read(drivePathProvider.notifier)
                      .push(name: data.name, id: data.id);
                }
              : null,
          behavior: HitTestBehavior.opaque,
          child: HoverBuilder(
            builder: (context, isHover) {
              Color? bgColor =
                  isHover ? themes.buttonHoverBgColor : Colors.transparent;
              if (isSelect) {
                bgColor = Color.lerp(
                    themes.accentColor.withOpacity(0.6), bgColor, 0.3);
              }
              return Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: [
                          if (type == "file")
                            DriverFileIcon(themes: themes, data: data)
                          else
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: themes.panelColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              ),
                              child: Icon(
                                TablerIcons.folder,
                                size: 48,
                                color: themes.fgColor,
                              ),
                            )
                        ][0],
                      ),
                    ),
                    Text(
                      data.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }

  Widget getRenameDialog(ThemeColorModel themes) {
    return HookConsumer(
      builder: (context, ref, child) {
        var name = useState(data.name);
        return MkDialog(
          padding: const EdgeInsets.all(32),
          child: SizedBox(
            width: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "重命名文件",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(width: 1, color: themes.fgColor)),
                      contentPadding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
                      isDense: true,
                      hintText: "请输入新文件名",
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(width: 1, color: themes.dividerColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(width: 1, color: themes.accentColor))),
                  style: const TextStyle(fontSize: 14),
                  cursorWidth: 1,
                  cursorColor: themes.fgColor,
                  maxLines: 2,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    name.value = value;
                  },
                  initialValue: name.value,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          var notifier =
                              ref.read(driverUploaderProvider.notifier);
                          if (type == "file") {
                            notifier.updateFile(
                                fileId: data.id, name: name.value);
                          } else {
                            notifier.updateFolders(
                                folderId: data.id, name: name.value);
                          }

                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(themes.accentColor),
                            foregroundColor: MaterialStateProperty.all(
                                themes.fgOnAccentColor),
                            elevation: MaterialStateProperty.all(0)),
                        child: const Text("OK"),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  themes.buttonBgColor),
                              foregroundColor:
                                  MaterialStateProperty.all(themes.fgColor),
                              elevation: MaterialStateProperty.all(0)),
                          child: const Text("取消")),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getCommentDialog(ThemeColorModel themes) {
    return HookConsumer(
      builder: (context, ref, child) {
        var name = useState(data.comment);
        return MkDialog(
          padding: const EdgeInsets.all(32),
          child: SizedBox(
            width: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "添加标题",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(width: 1, color: themes.fgColor)),
                      contentPadding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
                      isDense: true,
                      hintText: "请输入新标题",
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(width: 1, color: themes.dividerColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(width: 1, color: themes.accentColor))),
                  style: const TextStyle(fontSize: 14),
                  cursorWidth: 1,
                  cursorColor: themes.fgColor,
                  maxLines: 4,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    name.value = value;
                  },
                  initialValue: name.value,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          ref
                              .read(driverUploaderProvider.notifier)
                              .updateFile(fileId: data.id, comment: name.value);
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(themes.accentColor),
                            foregroundColor: MaterialStateProperty.all(
                                themes.fgOnAccentColor),
                            elevation: MaterialStateProperty.all(0)),
                        child: const Text("OK"),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: FilledButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  themes.buttonBgColor),
                              foregroundColor:
                                  MaterialStateProperty.all(themes.fgColor),
                              elevation: MaterialStateProperty.all(0)),
                          child: const Text("取消")),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getDeleteDialog(ThemeColorModel themes) {
    return HookConsumer(
      builder: (context, ref, child) {
        return MkDialog(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      TablerIcons.alert_triangle,
                      size: 28,
                      color: themes.warnColor,
                    ),
                  ),
                  if (type == "file")
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "要删除「${data.name}」文件吗？附加此文件的帖子也会被删除。",
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "要删除「${data.name}」 文件夹吗？ 如果文件夹中存在内容，请先删除文件夹中的内容。",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            var notifier =
                                ref.read(driverUploaderProvider.notifier);
                            if (type == "file") {
                              notifier.deleteFile(data.id);
                            } else {
                              notifier.deleteFolder(data.id);
                            }
                            if (onRemove != null) {
                              onRemove!();
                            }
                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(themes.accentColor),
                              foregroundColor: MaterialStateProperty.all(
                                  themes.fgOnAccentColor),
                              elevation: MaterialStateProperty.all(0)),
                          child: const Text("OK"),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: 100,
                        child: FilledButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    themes.buttonBgColor),
                                foregroundColor:
                                    MaterialStateProperty.all(themes.fgColor),
                                elevation: MaterialStateProperty.all(0)),
                            child: const Text("取消")),
                      )
                    ],
                  )
                ],
              )),
        );
      },
    );
  }
}

class DriverFileIcon extends StatelessWidget {
  const DriverFileIcon(
      {super.key,
      required this.themes,
      required this.data,
      this.fit = BoxFit.contain});

  final ThemeColorModel themes;
  final DriveFileModel data;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: themes.panelColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      child: [
        if (data.thumbnailUrl != null)
          Stack(
            children: [
              MkImage(
                data.thumbnailUrl!,
                fit: fit,
                width: double.infinity,
                height: double.infinity,
                blurHash: data.blurhash,
              ),
              if (data.isSensitive)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: const Text(
                    "NSFW",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
            ],
          )
        else if (extension(data.name) != "")
          Center(
            child: Text(extension(data.name).substring(1).toUpperCase(),
                style: const TextStyle(fontSize: 22)),
          )
        else
          Center(
            child: Icon(
              TablerIcons.file,
              size: 48,
              color: themes.fgColor,
            ),
          )
      ][0],
    );
  }
}

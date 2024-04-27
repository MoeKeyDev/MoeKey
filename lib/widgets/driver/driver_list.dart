import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_scaffold.dart';

import '../../main.dart';
import '../../networks/drive.dart';
import '../../state/themes.dart';
import '../context_menu.dart';
import '../hover_builder.dart';
import '../loading_weight.dart';
import '../mk_dialog.dart';
import '../mk_switch.dart';
import 'create_from_url_dialog.dart';
import 'drive_thumbnail.dart';
import 'driver_select_dialog/driver_select_dialog_state.dart';
import 'upload_file_dialog.dart';

class DriverList extends HookConsumerWidget {
  const DriverList(
      {super.key,
      this.selectModel = false,
      this.maxSelect = 16,
      required this.id});
  final bool selectModel;
  final int maxSelect;
  final String id;
  ContextMenuCard getContextMenu(BuildContext context, ThemeColorModel themes,
      WidgetRef ref, bool isOriginal, void Function(bool value) setIsOriginal) {
    return ContextMenuCard(
      initialChildSize: 0.6,
      minChildSize: 0.5,
      maxChildSize: 0.6,
      menuListBuilder: () {
        return [
          ContextMenuItem(
            widget: (context, large, isHover) {
              return HookConsumer(
                builder: (context, ref, child) {
                  var isOriginal1 = useState(isOriginal);
                  return GestureDetector(
                    onTap: () {
                      isOriginal1.value = !isOriginal1.value;
                      setIsOriginal(isOriginal1.value);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: large
                          ? const EdgeInsets.all(8)
                          : const EdgeInsets.all(6).copyWith(left: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            // 这里没有对齐，手动对齐
                            padding:
                                EdgeInsets.fromLTRB(4, large ? 7 : 2, 0, 0),
                            child: const Text("保留原图"),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: large ? 35 : 25,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: MkSwitch(
                                  value: isOriginal1.value,
                                  onChanged: (value) {
                                    isOriginal1.value = value;
                                    setIsOriginal(value);
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            divider: true,
          ),
          ContextMenuItem(
              label: "刷新",
              icon: TablerIcons.refresh,
              divider: true,
              onTap: () {
                ref.invalidate(driveListProvider);
                return false;
              }),
          ContextMenuItem(
            title: "添加文件",
            label: "本地上传",
            icon: TablerIcons.upload,
            onTap: () {
              logger.d("本地上传");
              DriverUploadFileDialog.showUploadDialog(
                  context: context, isOriginal: isOriginal, ref: ref);
              return false;
            },
          ),
          ContextMenuItem(
            label: "从URL",
            icon: TablerIcons.link,
            divider: true,
            onTap: () {
              Timer(
                const Duration(milliseconds: 150),
                () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const DriverCreateFromUrlDialog();
                    },
                  );
                },
              );
              return false;
            },
          ),
          ContextMenuItem(
            label: "新建文件夹",
            icon: TablerIcons.folder_plus,
            title: "网盘",
            onTap: () {
              Timer(
                const Duration(milliseconds: 150),
                () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return getCreateFolderDialog(themes);
                    },
                  );
                },
              );

              return false;
            },
          ),
        ];
      },
    );
  }

  Widget getCreateFolderDialog(ThemeColorModel themes) {
    return HookConsumer(
      builder: (context, ref, child) {
        var name = useState("");
        FocusNode focusNode = useMemoized(() => FocusNode());
        submit() {
          if (name.value.isNotEmpty) {
            ref.read(driverUploaderProvider.notifier).createFolder(name.value);
          }

          Navigator.of(context).pop();
        }

        Future(() {
          focusNode.requestFocus();
        }).then((value) => null);
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
                    "新建文件夹",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextField(
                  focusNode: focusNode,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6)),
                          borderSide:
                              BorderSide(width: 1, color: themes.fgColor)),
                      contentPadding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
                      isDense: true,
                      hintText: "文件夹名称",
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
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    name.value = value;
                  },
                  onEditingComplete: submit,
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
                        onPressed: submit,
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var data = ref.watch(driveListProvider);
    var path = ref.watch(drivePathProvider);
    var scrollController = useScrollController();
    var isOriginal = useState(false);
    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.offset >=
            scrollController.position.maxScrollExtent) {
          ref.read(driveListProvider.notifier).loadMore();
        }
      });
      return null;
    }, const []);
    var widget = MkScaffold(
      body: Builder(
        builder: (context) {
          var queryPadding = MediaQuery.of(context).padding;
          return ContextMenuBuilder(
            menu:
                getContextMenu(context, themes, ref, isOriginal.value, (value) {
              isOriginal.value = value;
            }),
            child: LoadingAndEmpty(
                loading: data.isLoading,
                empty: data.valueOrNull?.isEmpty ?? true,
                refresh: () {
                  ref.invalidate(driveListProvider);
                },
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        queryPadding.top,
                        16,
                        queryPadding.bottom,
                      ),
                      sliver: SliverAlignedGrid.extent(
                        itemBuilder: (context, index) {
                          return buildDriverListItem(data, index);
                        },
                        maxCrossAxisExtent: 150,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        itemCount: data.valueOrNull?.length ?? 0,
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
      header: MkAppbar(
        content:
            buildDriverTopBar(themes, path, ref, data, context, isOriginal),
      ),
    );
    if (selectModel) {
      return widget;
    }
    return PopScope(
      canPop: path.length < 2,
      onPopInvoked: (_) async {
        // 监听物理返回
        ref.read(drivePathProvider.notifier).backAt(index: path.length - 2);
      },
      child: widget,
    );
  }

  HookConsumer buildDriverListItem(AsyncValue<List<dynamic>> data, int index) {
    return HookConsumer(
      builder: (context, ref, child) {
        var selectList = ref.watch(driverSelectDialogStateProvider(this.id));
        var id = data.valueOrNull![index]["data"].id;
        var file = data.valueOrNull![index];
        var isSelect = useState(selectList.containsKey(id));
        if (selectModel) {
          return GestureDetector(
            onTap: () {
              // if (selectList.length >= maxSelect) return;
              var notifier =
                  ref.read(driverSelectDialogStateProvider(this.id).notifier);
              if (file["type"] == "file") {
                if (isSelect.value) {
                  notifier.remove(id);
                  isSelect.value = false;
                } else {
                  if (selectList.length >= maxSelect) return;
                  notifier.add(id, file["data"]);
                  isSelect.value = true;
                }
              }
            },
            child: DriveImageThumbnail(
              key: ValueKey(id),
              data: file,
              isSelect: isSelect.value,
              onRemove: () {
                if (isSelect.value) {
                  var notifier = ref
                      .read(driverSelectDialogStateProvider(this.id).notifier);
                  notifier.remove(id);
                  isSelect.value = false;
                }
              },
            ),
          );
        }
        return DriveImageThumbnail(
          key: ValueKey(id),
          data: file,
          isSelect: false,
        );
      },
    );
  }

  Widget buildDriverTopBar(
      ThemeColorModel themes,
      List<Map<dynamic, dynamic>> path,
      WidgetRef ref,
      AsyncValue<List<dynamic>> data,
      BuildContext context,
      ValueNotifier<bool> isOriginal) {
    return HookConsumer(builder: (context, ref, child) {
      var selectList = ref.watch(driverSelectDialogStateProvider(id));
      return Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          Icon(
            TablerIcons.cloud,
            size: 16,
            color: themes.fgColor,
          ),
          const SizedBox(
            width: 4,
          ),
          for (var (index, item) in path.indexed) ...[
            if (index != 0) ...[
              const Icon(
                TablerIcons.chevron_right,
                size: 16,
              ),
              const SizedBox(
                width: 4,
              ),
            ],
            HoverBuilder(builder: (context, isHover) {
              return GestureDetector(
                onTap: () {
                  if (index == path.length - 1) return;
                  ref.read(drivePathProvider.notifier).backAt(index: index);
                },
                child: Text(
                  item["name"],
                  style: TextStyle(
                      decoration: index != path.length - 1 && isHover
                          ? TextDecoration.underline
                          : null,
                      fontWeight:
                          index == path.length - 1 ? FontWeight.bold : null),
                ),
              );
            }),
            const SizedBox(
              width: 4,
            ),
          ],
          const Spacer(),
          if (selectModel)
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("确定(${selectList.length}/$maxSelect)")),
          if (data.isLoading)
            const LoadingCircularProgress(
              size: 18,
              strokeWidth: 3,
            )
          else
            ContextMenuBuilder(
                menu: getContextMenu(context, themes, ref, isOriginal.value,
                    (value) {
                  isOriginal.value = value;
                }),
                mode: const [
                  ContextMenuMode.onTap,
                  ContextMenuMode.onSecondaryTap
                ],
                child: const Icon(
                  TablerIcons.dots,
                  size: 18,
                )),
          const SizedBox(
            width: 16,
          ),
        ],
      );
    });
  }
}

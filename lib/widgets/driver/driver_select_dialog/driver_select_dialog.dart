import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/drive.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/context_menu.dart';
import 'package:moekey/widgets/driver/upload_file_dialog.dart';
import 'package:moekey/widgets/loading_weight.dart';

import '../../../generated/l10n.dart';
import '../../mk_card.dart';
import '../../mk_switch.dart';
import '../drive.dart';
import '../drive_thumbnail.dart';
import '../driver_list.dart';

class DriverSelectPanel extends HookConsumerWidget {
  const DriverSelectPanel({
    super.key,
    this.maxSelect,
    required this.initialSelectedFiles,
    required this.onCancel,
    required this.selectCallback,
  });

  final int? maxSelect;
  final List<DriveFileModel> initialSelectedFiles;
  final VoidCallback onCancel;
  final ValueChanged<List<DriveFileModel>> selectCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOriginal = useState(false);
    final initialSelectedIds = {
      for (final file in initialSelectedFiles) file.id,
    };
    final selectedFiles = useState(<String, DriveFileModel>{
      for (final file in initialSelectedFiles) file.id: file,
    });
    final themes = ref.watch(themeColorsProvider);
    final driveItems = ref.watch(driveListProvider);
    final drivePath = ref.watch(drivePathProvider);
    final scrollController = useScrollController();

    useEffect(() {
      void loadMore() {
        if (scrollController.hasClients &&
            scrollController.position.extentAfter < 120) {
          ref.read(driveListProvider.notifier).loadMore();
        }
      }

      scrollController.addListener(loadMore);
      return () => scrollController.removeListener(loadMore);
    }, [scrollController]);

    void selectFiles(List<DriveFileModel> files) {
      final candidates = files
          .where((file) => !selectedFiles.value.containsKey(file.id))
          .toList(growable: false);
      final inserted = maxSelect == null
          ? candidates
          : candidates
                .take(
                  (maxSelect! - selectedFiles.value.length).clamp(
                    0,
                    candidates.length,
                  ),
                )
                .toList(growable: false);
      if (inserted.isEmpty) return;
      selectedFiles.value = {
        ...selectedFiles.value,
        for (final file in inserted) file.id: file,
      };
    }

    void toggleFile(DriveFileModel file) {
      final next = Map<String, DriveFileModel>.of(selectedFiles.value);
      if (next.containsKey(file.id)) {
        next.remove(file.id);
      } else {
        if (maxSelect != null && next.length >= maxSelect!) return;
        next[file.id] = file;
      }
      selectedFiles.value = next;
    }

    final hasSelectionChanges =
        initialSelectedIds.length != selectedFiles.value.length ||
        !initialSelectedIds.every(selectedFiles.value.containsKey);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 36,
            child: Row(
              children: [
                if (drivePath.length > 1)
                  IconButton(
                    tooltip: S.current.back,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 32,
                      height: 32,
                    ),
                    onPressed: () {
                      ref
                          .read(drivePathProvider.notifier)
                          .backAt(index: drivePath.length - 2);
                    },
                    icon: Icon(
                      TablerIcons.chevron_left,
                      size: 18,
                      color: themes.fgColor,
                    ),
                  )
                else ...[
                  Icon(TablerIcons.cloud, size: 17, color: themes.fgColor),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(
                    drivePath.lastOrNull?['name'] ?? S.current.drive,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: themes.fgColor, fontSize: 13),
                  ),
                ),
                if (driveItems.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: LoadingCircularProgress(
                      size: 16,
                      strokeWidth: 2,
                    ),
                  )
                else
                  IconButton(
                    tooltip: S.current.refresh,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 32,
                      height: 32,
                    ),
                    onPressed: () => ref.invalidate(driveListProvider),
                    icon: Icon(
                      TablerIcons.refresh,
                      size: 17,
                      color: themes.fgColor,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(vertical: 6),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 104,
                mainAxisExtent: 120,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: (driveItems.value?.length ?? 0) + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _DriverPanelAction(
                    key: const ValueKey('inline-drive-upload'),
                    label: S.current.localUpload,
                    icon: TablerIcons.upload,
                    onTap: () async {
                      final files =
                          await DriverUploadFileDialog.showUploadDialog(
                            context: context,
                            isOriginal: isOriginal.value,
                            ref: ref,
                          );
                      if (context.mounted) selectFiles(files);
                    },
                  );
                }

                final item = driveItems.value![index - 1];
                if (item is DriverFolderModel) {
                  return DriveImageThumbnail(
                    key: ValueKey(item.id),
                    data: item,
                  );
                }

                final file = item as DriveFileModel;
                final isSelected = selectedFiles.value.containsKey(file.id);
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => toggleFile(file),
                      child: DriveImageThumbnail(
                        key: ValueKey(file.id),
                        data: file,
                        isSelect: isSelected,
                      ),
                    ),
                    if (isSelected)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          key: ValueKey('inline-drive-selected-${file.id}'),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: themes.accentColor,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            TablerIcons.check,
                            size: 14,
                            color: themes.fgOnAccentColor,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Divider(height: 1, color: themes.dividerColor),
          SizedBox(
            height: 52,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => isOriginal.value = !isOriginal.value,
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            S.current.keepOriginal,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: themes.fgColor),
                          ),
                        ),
                        const SizedBox(width: 6),
                        MkSwitch(
                          value: isOriginal.value,
                          onChanged: (value) => isOriginal.value = value,
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  key: const ValueKey('inline-drive-cancel'),
                  onPressed: onCancel,
                  child: Text(S.current.cancel),
                ),
                const SizedBox(width: 6),
                FilledButton(
                  key: const ValueKey('inline-drive-confirm'),
                  onPressed: hasSelectionChanges
                      ? () => selectCallback(
                          selectedFiles.value.values.toList(growable: false),
                        )
                      : null,
                  style: ButtonStyle(
                    elevation: WidgetStateProperty.all(0),
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    minimumSize: WidgetStateProperty.all(const Size(0, 34)),
                  ),
                  child: Text(
                    '${S.current.ok} (${selectedFiles.value.length})',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DriverPanelAction extends ConsumerWidget {
  const _DriverPanelAction({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themes = ref.watch(themeColorsProvider);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: DriveGridTile(
        label: label,
        labelKey: const ValueKey('inline-drive-upload-label'),
        thumbnail: DecoratedBox(
          key: const ValueKey('inline-drive-upload-thumbnail'),
          decoration: BoxDecoration(
            color: themes.buttonBgColor,
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          child: Icon(icon, size: 22, color: themes.fgColor),
        ),
      ),
    );
  }
}

class DriverSelectContextMenu extends HookConsumerWidget {
  const DriverSelectContextMenu({
    super.key,
    required this.builder,
    this.maxSelect,
    required this.selectCallback,
  });

  final int? maxSelect;
  final Widget Function(BuildContext context, void Function() open) builder;
  final Function(List<DriveFileModel> files) selectCallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isOriginal = useState(false);
    return ContextMenuBuilder(
      mode: const [],
      maskColor: Colors.black.withAlpha(102),
      alignmentChild: true,
      menu: ContextMenuCard(
        initialChildSize: 0.6,
        minChildSize: 0.5,
        maxChildSize: 0.6,
        menuListBuilder: () {
          return [
            ContextMenuItem(
              widget: (context, large, isHover) {
                return HookConsumer(
                  builder: (context, ref, child) {
                    var isOriginal1 = useState(isOriginal.value);
                    return GestureDetector(
                      onTap: () {
                        isOriginal1.value = !isOriginal1.value;
                        // setIsOriginal(isOriginal1.value);
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
                              child: Text(S.current.keepOriginal),
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
                                    // setIsOriginal(value);
                                  },
                                ),
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
              title: S.current.addFile,
              label: S.current.localUpload,
              icon: TablerIcons.upload,
              onTap: () {
                DriverUploadFileDialog.showUploadDialog(
                        context: context,
                        isOriginal: isOriginal.value,
                        ref: ref)
                    .then(
                  (value) {
                    selectCallback(value);
                  },
                );
                return false;
              },
            ),
            ContextMenuItem(
              label: S.current.fromCloud,
              icon: TablerIcons.cloud,
              onTap: () {
                Timer(
                  const Duration(milliseconds: 150),
                  () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DriverSelectDialog(maxSelect: maxSelect);
                      },
                    ).then((value) {
                      if (value != null) {
                        selectCallback(value);
                      }
                    });
                  },
                );
                return false;
              },
            ),
            // ContextMenuItem(
            //   label: "从URL",
            //   icon: TablerIcons.link,
            //   onTap: () {
            //     Timer(
            //       const Duration(milliseconds: 150),
            //       () {
            //         showDialog(
            //           context: context,
            //           builder: (context) {
            //             return const DriverCreateFromUrlDialog();
            //           },
            //         );
            //       },
            //     );
            //     return false;
            //   },
            // ),
          ];
        },
      ),
      child: Builder(
        builder: (context) {
          return builder(context, () {
            context
                .findAncestorStateOfType<ContextMenuBuilderState>()
                ?.show(Offset.zero);
          });
        },
      ),
    );
  }
}

class DriverSelectDialog extends HookConsumerWidget {
  const DriverSelectDialog({
    super.key,
    this.maxSelect,
  });

  final int? maxSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var isFullscreen = constraints.maxWidth < 580;
        var borderRadius = isFullscreen
            ? const BorderRadius.all(Radius.zero)
            : const BorderRadius.all(
                Radius.circular(12),
              );
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
                  Center(
                      // duration: const Duration(milliseconds: 500),
                      // top: isFullscreen ? 0 : 40,
                      child: GestureDetector(
                    onTap: () {},
                    child: AnimatedContainer(
                      width: isFullscreen ? constraints.maxWidth : 560,
                      height: isFullscreen ? constraints.maxHeight : 600,
                      duration: const Duration(milliseconds: 500),
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: MkCard(
                          padding: const EdgeInsets.all(0),
                          borderRadius: borderRadius,
                          child: DriverList(
                            selectModel: true,
                            maxSelect: maxSelect,
                          ),
                        ),
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
}

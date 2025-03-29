import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/drive.dart';
import 'package:moekey/widgets/context_menu.dart';
import 'package:moekey/widgets/driver/upload_file_dialog.dart';

import '../../../generated/l10n.dart';
import '../../mk_card.dart';
import '../../mk_switch.dart';
import '../driver_list.dart';

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

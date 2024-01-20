import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:misskey/widgets/driver/driver_upload_bar.dart';
import 'package:path/path.dart';

import '../../main.dart';
import '../../networks/drive.dart';
import '../mk_dialog.dart';

class DriverUploadFileDialog extends HookConsumerWidget {
  const DriverUploadFileDialog({
    super.key,
    required this.isOriginal,
    required this.files,
  });
  final bool isOriginal;
  final List<String> files;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var data = ref.watch(driverUploaderProvider);
    useEffect(() {
      var notifier = ref.read(driverUploaderProvider.notifier);
      notifier.createFiles(filesPath: files, compression: !isOriginal);
      return null;
    }, files);
    bool done = true;
    for (var item in data) {
      done &= item["done"];
    }
    return MkDialog(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var item in data)
              ListTile(
                leading: Image.file(File(item["path"]),
                    height: 50, width: 50, fit: BoxFit.cover),
                title: Text(
                  basename(item["path"]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: DefaultTextStyle.of(context).style,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: LinearProgressIndicator(
                    backgroundColor:
                        Theme.of(context).primaryColor.withAlpha(32),
                    color: Theme.of(context).primaryColor.withAlpha(200),
                    value: item["progress"] != 1
                        ? item["progress"]
                        : item["done"]
                            ? 1
                            : null,
                  ),
                ),
              )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        FilledButton(
          child: Text(done ? "完成" : '取消'),
          onPressed: () {
            globalNav.currentState?.pop();
          },
        )
      ],
    ));
  }

  static OverlayEntry? overlayEntry;
  static Future<List> showUploadDialog(
      {required BuildContext context,
      required bool isOriginal,
      required WidgetRef ref}) async {
    var result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      List<String> files = result.paths.map((path) => path!).toList();
      logger.d(files);
      if (context.mounted) {
        overlayEntry?.remove();
        overlayEntry = OverlayEntry(
          builder: (context) {
            return const DriverUploadBar();
          },
        );

        Overlay.of(context).insert(overlayEntry!);
      }

      var list = await ref
          .read(driverUploaderProvider.notifier)
          .createFiles(filesPath: files, compression: !isOriginal);
      overlayEntry?.remove();
      overlayEntry = null;
      return list;
      // imageCompression(files[0]);
    } else {
      // User canceled the picker
    }
    return [];
  }
}

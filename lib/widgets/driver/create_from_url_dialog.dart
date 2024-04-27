import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/widgets/input_decoration.dart';

import '../../networks/drive.dart';
import '../../state/themes.dart';
import '../mk_dialog.dart';

class DriverCreateFromUrlDialog extends HookConsumerWidget {
  const DriverCreateFromUrlDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var url = useState("");
    var themes = ref.watch(themeColorsProvider);
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
                "从网址上传",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              decoration: inputDecoration(
                themes,
                "请输入URL",
              ),
              style: const TextStyle(fontSize: 14),
              cursorWidth: 1,
              cursorColor: themes.fgColor,
              maxLines: 1,
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) {
                url.value = value;
              },
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
                          .uploadFromUrl(url.value);
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(themes.accentColor),
                        foregroundColor:
                            MaterialStateProperty.all(themes.fgOnAccentColor),
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
                          backgroundColor:
                              MaterialStateProperty.all(themes.buttonBgColor),
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
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/widgets/mk_input.dart';

import '../../status/themes.dart';
import '../mk_dialog.dart';
import 'drive.dart';

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
          mainAxisSize: MainAxisSize.min,
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
            MkInput(
              hintText: "请输入URL",
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
                            WidgetStateProperty.all(themes.accentColor),
                        foregroundColor:
                            WidgetStateProperty.all(themes.fgOnAccentColor),
                        elevation: WidgetStateProperty.all(0)),
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
                              WidgetStateProperty.all(themes.buttonBgColor),
                          foregroundColor:
                              WidgetStateProperty.all(themes.fgColor),
                          elevation: WidgetStateProperty.all(0)),
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

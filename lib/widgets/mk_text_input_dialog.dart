import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/widgets/loading_weight.dart';
import 'package:moekey/widgets/mk_button.dart';

import '../generated/l10n.dart';
import '../status/themes.dart';
import 'mk_dialog.dart';
import 'mk_input.dart';

class MkTextInputDialog extends HookConsumerWidget {
  const MkTextInputDialog({
    super.key,
    required this.title,
    this.initialValue,
    this.hintText,
    this.onConfirm,
    this.onCancel,
  });

  final String title;
  final String? initialValue;
  final String? hintText;
  final Future<bool> Function(String)? onConfirm;
  final Function()? onCancel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var text = useState(initialValue ?? '');
    var themes = ref.watch(themeColorsProvider);
    var loading = useState(false);
    return MkDialog(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          MkInput(
            maxLines: 2,
            onChanged: (value) {
              text.value = value;
            },
            initialValue: text.value,
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MkPrimaryButton(
                child: loading.value
                    ? LoadingCircularProgress(
                        strokeWidth: 3,
                        size: 18,
                        color: themes.fgOnAccentColor,
                        backgroundColor: themes.accentLightenColor,
                      )
                    : Text(S.current.ok),
                onPressed: () {
                  if (onConfirm != null) {
                    loading.value = true;
                    onConfirm!(text.value).then((value) {
                      loading.value = false;
                      if (value && context.mounted) {
                        Navigator.of(context).pop();
                      }
                    }).onError((error, stackTrace) {
                      loading.value = false;
                    });
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              MkSecondaryButton(
                child: Text(S.current.cancel),
                onPressed: () {
                  if (onCancel != null) {
                    onCancel!();
                  }

                  Navigator.of(context).pop();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}

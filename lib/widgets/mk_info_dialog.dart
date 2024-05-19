import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../main.dart';
import '../status/themes.dart';
import 'mk_dialog.dart';
import 'mk_modal.dart';

class MkInfoDialog extends HookConsumerWidget {
  const MkInfoDialog({
    super.key,
    required this.info,
    this.isError = false,
  });

  final String info;
  final bool isError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return MkDialog(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isError)
            Icon(
              TablerIcons.circle_x,
              size: 30,
              color: themes.errorColor,
            )
          else
            Icon(
              TablerIcons.alert_circle,
              size: 30,
              color: themes.warnColor,
            ),
          const SizedBox(
            height: 12,
          ),
          Text(
            info,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 12,
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(themes.accentColor),
                foregroundColor:
                    WidgetStateProperty.all(themes.fgOnAccentColor),
                elevation: WidgetStateProperty.all(0)),
            child: const Text("我知道了"),
          )
        ],
      ),
    );
  }

  static show({
    required String info,
    bool isError = false,
  }) {
    showModel(
      context: globalNav.currentContext!,
      builder: (context) {
        return MkInfoDialog(info: info);
      },
    );
  }
}

class MkConfirm extends ConsumerWidget {
  const MkConfirm({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return MkDialog(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...children,
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 120),
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
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
              const SizedBox(
                width: 12,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 120),
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(themes.buttonBgColor),
                      foregroundColor: WidgetStateProperty.all(themes.fgColor),
                      elevation: WidgetStateProperty.all(0)),
                  child: const Text("取消"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  static Future<bool?> show({required List<Widget> children}) {
    return showModel<bool?>(
      context: globalNav.currentContext!,
      builder: (context) {
        return MkConfirm(
          children: children,
        );
      },
    );
  }
}

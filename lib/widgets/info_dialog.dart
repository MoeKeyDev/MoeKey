import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../main.dart';
import '../status/themes.dart';
import 'mk_dialog.dart';

class InfoDialog extends HookConsumerWidget {
  const InfoDialog({
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
                  backgroundColor:
                      MaterialStateProperty.all(themes.accentColor),
                  foregroundColor:
                      MaterialStateProperty.all(themes.fgOnAccentColor),
                  elevation: MaterialStateProperty.all(0)),
              child: const Text("我知道了"))
        ],
      ),
    );
  }

  static show({
    required String info,
    bool isError = false,
  }) {
    showDialog(
      context: globalNav.currentContext!,
      builder: (context) {
        return InfoDialog(info: info);
      },
    );
  }
}

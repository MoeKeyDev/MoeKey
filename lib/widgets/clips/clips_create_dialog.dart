import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/widgets/mk_modal.dart';

import '../../state/themes.dart';

class ClipCreateDialog extends HookConsumerWidget {
  const ClipCreateDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return MkModal(
      body: Column(
        children: [],
      ),
      appbar: Row(
        children: [
          const SizedBox(
            width: 4,
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              TablerIcons.x,
              size: 18,
              color: themes.fgColor,
            ),
          ),
          const Text(
            "新建便签",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              TablerIcons.check,
              size: 18,
              color: themes.fgColor,
            ),
          )
        ],
      ),
      width: 450,
      height: 500,
      padding: EdgeInsets.all(12),
    );
  }
}

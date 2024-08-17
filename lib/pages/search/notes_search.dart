import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/utils/get_padding_note.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/mk_input.dart';

class NotesSearchPage extends HookConsumerWidget {
  const NotesSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.paddingOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        var padding = getPaddingForNote(constraints);
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                  padding, mediaPadding.top, padding, mediaPadding.bottom),
              sliver: SliverMainAxisGroup(slivers: [
                SliverToBoxAdapter(
                  child: NotesSearchPanel(),
                )
              ]),
            )
          ],
        );
      },
    );
  }
}

class NotesSearchPanel extends HookConsumerWidget {
  const NotesSearchPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    var widgetStateProperty = WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return themes.accentColor;
        }
        return themes.fgColor;
      },
    );
    return MkCard(
        shadow: false,
        child: Column(
          children: [
            MkInput(
              prefixIcon: Icon(TablerIcons.search),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Radio(
                  value: "true",
                  groupValue: "true",
                  fillColor: widgetStateProperty,
                  onChanged: (value) => {},
                ),
                Text("全部"),
                const SizedBox(width: 8),
                Radio(
                  value: "true1",
                  groupValue: "true",
                  fillColor: widgetStateProperty,
                  onChanged: (value) => {},
                ),
                Text("本地"),
                const SizedBox(width: 8),
                Radio(
                  value: "true1",
                  groupValue: "true",
                  fillColor: widgetStateProperty,
                  onChanged: (value) => {},
                ),
                Text("指定主机名")
              ],
            ),
            const SizedBox(height: 16),
            MkInput(
              prefixIcon: Icon(TablerIcons.server),
            ),
            const SizedBox(height: 16),
            FilledButton(
                onPressed: () {},
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(themes.accentColor),
                    foregroundColor: WidgetStateProperty.all(themes.bgColor),
                    elevation: WidgetStateProperty.all(0)),
                child: const Text("   搜索   "))
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/widgets/mk_input.dart';
import 'package:moekey/widgets/mk_scaffold.dart';

class SettingsProfile extends HookConsumerWidget {
  const SettingsProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.paddingOf(context);
    return MkScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          padding: mediaPadding,
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MkFormItem(
                label: "昵称",
                child: const MkInput(),
              ),
              MkFormItem(
                label: "个人简介",
                helperText: "你可以在个人简介中包含一些#标签。",
                child: const MkInput(
                  maxLines: 6,
                ),
              ),
              MkFormItem(
                label: "位置",
                child: const MkInput(
                  prefixIcon: Icon(TablerIcons.map_pin),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MkFormItem extends HookConsumerWidget {
  const MkFormItem({
    super.key,
    required this.label,
    required this.child,
    this.helperText,
  });

  final String label;
  final Widget child;
  final String? helperText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
        child,
        if (helperText != null)
          Opacity(
            opacity: 0.75,
            child: Text(
              helperText!,
              style: TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }
}

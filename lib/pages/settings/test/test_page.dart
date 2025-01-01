import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/widgets/mk_scaffold.dart';

class SettingsTestPage extends HookConsumerWidget {
  const SettingsTestPage({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MkScaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text(text),
          ),
          FilledButton(onPressed: () => context.pop(), child: Text("back"))
        ],
      ),
    );
  }
}

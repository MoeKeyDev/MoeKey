import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/splash_page/splash_page.dart';

import '../../main.dart';
import '../../pages/home/home_page.dart';
import '../../status/server.dart';
import '../../status/user_login.dart';
import '../mk_dialog.dart';

class LoginDialog extends HookConsumerWidget {
  const LoginDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var user = ref.watch(apiUserLoginProvider);
    var host = ref.watch(selectServerHostProvider);
    return MkDialog(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: switch (user) {
          AsyncData(:final valueOrNull) => [
              // logger.d(valueOrNull)
              Builder(
                builder: (context) {
                  Timer(
                    const Duration(seconds: 1),
                    () {
                      context.replace("/");
                    },
                  );
                  return const Text("登陆成功");
                },
              ),
              TextButton(
                child: const Text('确定'),
                onPressed: () {
                  context.pop();
                },
              )
            ],
          AsyncError(:final error, :final stackTrace) => [
              Text(error.toString()),
              Text(stackTrace.toString()),
              TextButton(
                child: const Text('确定'),
                onPressed: () {
                  context.pop();
                },
              )
            ],
          _ => [
              const SizedBox(
                height: 16,
              ),
              UnconstrainedBox(
                child: CircularProgressIndicator(
                  strokeCap: StrokeCap.round,
                  backgroundColor: Theme.of(context).primaryColor.withAlpha(32),
                  color: Theme.of(context).primaryColor.withAlpha(200),
                  strokeWidth: 6,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "正在登陆: $host",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton(
                child: const Text('取消'),
                onPressed: () {
                  context.pop();
                },
              )
            ]
        },
      ),
    );
  }
}

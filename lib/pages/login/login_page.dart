import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/router/router.dart';
import 'package:moekey/widgets/mk_scaffold.dart';

import '../../status/server.dart';
import '../../status/themes.dart';
import '../../widgets/login/servers_select.dart';

class Path1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2.0, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class Path2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width / 2.0, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: themes.themeColor.withAlpha(32),
          ),
          FractionallySizedBox(
            widthFactor: 0.38,
            heightFactor: 1,
            child: SizedBox(
              child: ClipPath(
                clipper: Path2(),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: themes.themeColor.withAlpha(128),
                  ),
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.45,
            heightFactor: 1,
            child: SizedBox(
              child: ClipPath(
                clipper: Path1(),
                child: DecoratedBox(
                  decoration:
                      BoxDecoration(color: themes.themeColor.withAlpha(255)),
                ),
              ),
            ),
          ),
          Positioned(
              top: 24 + MediaQuery.paddingOf(context).top,
              left: 24 + MediaQuery.paddingOf(context).left,
              child: SvgPicture.asset(
                "assets/misskey.svg",
                width: 150,
              )),
          const Center(
            child: SizedBox(
              width: 450,
              height: 600,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: ServersSelectCard(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LogoutPage extends HookConsumerWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var list = ref.watch(loginUserListProvider);
    Future.delayed(Duration.zero, () {
      ref.read(loginUserListProvider.notifier).removeUser(list.keys.first);
      if (context.mounted) {
        context.pushNamedAndRemoveUntil("login");
      }
    });
    return MkScaffold(body: SizedBox());
  }
}

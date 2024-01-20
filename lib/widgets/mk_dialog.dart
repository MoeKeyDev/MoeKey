import 'package:flutter/material.dart';

import 'mk_card.dart';

class MkDialog extends StatelessWidget {
  const MkDialog({super.key, required this.child, this.padding});
  final EdgeInsetsGeometry? padding;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    // 设置
    return SimpleDialog(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      children: [
        MkCard(
          padding: padding,
          child: child,
        )
      ],
    );
  }
}

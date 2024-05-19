import 'package:flutter/material.dart';
import 'package:moekey/widgets/mk_modal.dart';

import 'mk_card.dart';

class MkDialog extends StatelessWidget {
  const MkDialog({super.key, required this.child, this.padding});

  final EdgeInsetsGeometry? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // 设置
    return ModalWrapper(
        child: MkCard(
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      padding: padding,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, minWidth: 300),
        child: child,
      ),
    ));
  }
}

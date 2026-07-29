import 'package:flutter/widgets.dart';

/// Keeps a modal sheet above an already visible keyboard without changing the
/// keyboard focus while the route transition is running.
class KeyboardAwareBottomSheet extends StatelessWidget {
  const KeyboardAwareBottomSheet({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = (constraints.maxHeight - keyboardInset)
            .clamp(0.0, constraints.maxHeight)
            .toDouble();
        return Transform.translate(
          offset: Offset(0, -keyboardInset),
          child: SizedBox(height: availableHeight, child: child),
        );
      },
    );
  }
}

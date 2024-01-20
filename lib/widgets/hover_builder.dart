import 'dart:io';

import 'package:flutter/material.dart';

class HoverBuilder extends StatefulWidget {
  const HoverBuilder({super.key, required this.builder, this.onHover});
  final Widget Function(BuildContext context, bool isHover) builder;
  final void Function(bool isHover)? onHover;
  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}

class _HoverBuilderState extends State<HoverBuilder> {
  var isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) {
        setState(() {
          isHover = true;
        });
        if (widget.onHover != null) {
          widget.onHover!(true);
        }
      },
      onExit: (event) {
        setState(() {
          isHover = false;
        });
        if (widget.onHover != null) {
          widget.onHover!(false);
        }
      },
      child: Platform.isAndroid || Platform.isIOS
          ? Listener(
              onPointerDown: (event) {
                setState(() {
                  isHover = true;
                });
              },
              onPointerUp: (event) {
                setState(() {
                  isHover = false;
                });
              },
              // onPointerSignal: (event) {
              //   setState(() {
              //     isHover = false;
              //   });
              // },
              onPointerCancel: (event) {
                setState(() {
                  isHover = false;
                });
              },
              child: widget.builder(context, isHover),
            )
          : widget.builder(context, isHover),
    );
  }
}

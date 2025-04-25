import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../status/themes.dart';

inputDecoration(ThemeColorModel themes, String? hintText,
    {Widget? prefixIcon, Widget? suffixIcon}) {
  return InputDecoration(
      border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(width: 1, color: themes.fgColor)),
      contentPadding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
      isDense: true,
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(width: 1, color: themes.dividerColor)),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        borderSide: BorderSide(width: 1, color: themes.accentColor),
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon);
}

class MkInput extends ConsumerStatefulWidget {
  const MkInput({
    super.key,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.onChanged,
    this.value,
    this.maxLines,
    this.keyboardType,
    this.maxLength,
    this.minLines,
  });

  final String? label;
  final String? hintText;
  final Icon? prefixIcon;
  final void Function(String)? onChanged;
  final String? value;
  final int? maxLines;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int? minLines;

  @override
  ConsumerState<MkInput> createState() => _MkInputState();
}

class _MkInputState extends ConsumerState<MkInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _controller.addListener(() {
      if (widget.onChanged != null && _controller.text != widget.value) {
        widget.onChanged!(_controller.text);
      }
    });
  }

  @override
  void didUpdateWidget(MkInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value ?? "";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themes = ref.watch(themeColorsProvider);
    return Material(
      color: themes.panelColor,
      borderRadius: BorderRadius.circular(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(
              height: 6,
            ),
          ],
          TextFormField(
            controller: _controller,
            decoration: inputDecoration(
              themes,
              widget.hintText,
              prefixIcon: widget.prefixIcon,
            ),
            cursorWidth: 1,
            style: const TextStyle(fontSize: 14),
            cursorColor: themes.fgColor,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            keyboardType: widget.keyboardType,
            maxLength: widget.maxLength,
            textAlignVertical: TextAlignVertical.center,
          )
        ],
      ),
    );
  }
}

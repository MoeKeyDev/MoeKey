import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../status/themes.dart';

InputDecoration inputDecoration(
  ThemeColorModel themes,
  String? hintText, {
  Widget? prefixIcon,
  Widget? suffixIcon,
  bool compact = false,
  double borderRadius = 6,
  Color? fillColor,
  bool borderless = false,
}) {
  return InputDecoration(
    filled: fillColor != null,
    fillColor: fillColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: borderless
          ? BorderSide.none
          : BorderSide(width: 1, color: themes.fgColor),
    ),
    contentPadding: compact
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
        : const EdgeInsets.fromLTRB(14, 11, 14, 11),
    isDense: true,
    hintText: hintText,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: borderless
          ? BorderSide.none
          : BorderSide(width: 1, color: themes.dividerColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      borderSide: BorderSide(width: 1, color: themes.accentColor),
    ),
    prefixIcon: prefixIcon,
    prefixIconConstraints: compact
        ? const BoxConstraints(minWidth: 38, minHeight: 36)
        : null,
    suffixIcon: suffixIcon,
  );
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
    this.onSubmitted,
    this.textInputAction,
    this.backgroundColor,
    this.compact = false,
    this.borderRadius = 6,
    this.fillColor,
    this.borderless = false,
    this.autofocus = false,
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
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final Color? backgroundColor;
  final bool compact;
  final double borderRadius;
  final Color? fillColor;
  final bool borderless;
  final bool autofocus;

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
      color: widget.backgroundColor ?? themes.panelColor,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Text(widget.label!, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 6),
          ],
          TextFormField(
            controller: _controller,
            autofocus: widget.autofocus,
            decoration: inputDecoration(
              themes,
              widget.hintText,
              prefixIcon: widget.prefixIcon,
              compact: widget.compact,
              borderRadius: widget.borderRadius,
              fillColor: widget.fillColor,
              borderless: widget.borderless,
            ),
            cursorWidth: 1,
            style: const TextStyle(fontSize: 14),
            cursorColor: themes.fgColor,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            keyboardType: widget.keyboardType,
            maxLength: widget.maxLength,
            textAlignVertical: TextAlignVertical.center,
            onFieldSubmitted: widget.onSubmitted,
            textInputAction: widget.textInputAction,
          ),
        ],
      ),
    );
  }
}

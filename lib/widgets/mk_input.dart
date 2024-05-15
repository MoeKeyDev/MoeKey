import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../state/themes.dart';

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

class MkInput extends ConsumerWidget {
  const MkInput({
    super.key,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.onChanged,
    this.initialValue,
    this.maxLines,
  });

  final String? label;
  final String? hintText;
  final Icon? prefixIcon;
  final void Function(String)? onChanged;
  final String? initialValue;
  final int? maxLines;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.read(themeColorsProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!),
          const SizedBox(
            height: 4,
          ),
        ],
        TextFormField(
          decoration: inputDecoration(
            themes,
            hintText,
            prefixIcon: prefixIcon,
          ),
          cursorWidth: 1,
          style: const TextStyle(fontSize: 14),
          cursorColor: themes.fgColor,
          maxLines: maxLines ?? 1,
          textAlignVertical: TextAlignVertical.center,
          onChanged: onChanged,
          initialValue: initialValue,
        )
      ],
    );
  }
}

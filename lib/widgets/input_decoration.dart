import 'package:flutter/material.dart';
import 'package:misskey/state/themes.dart';

inputDecoration(ThemeColorModel themes, String hintText,
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

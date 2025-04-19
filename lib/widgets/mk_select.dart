import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../status/themes.dart';
import 'mk_input.dart'; // 导入 inputDecoration

// 定义选项的数据结构
class MkSelectItem<T> {
  final T value;
  final String label; // 用于显示的文本

  const MkSelectItem({required this.value, required this.label});
}

class MkSelect<T> extends ConsumerWidget {
  const MkSelect({
    super.key,
    this.label,
    this.hintText,
    this.prefixIcon,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.disabledHint,
    this.elevation = 8,
    this.style,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = true,
    this.isExpanded = false,
    this.itemHeight,
    this.focusColor,
    this.focusNode,
    this.autofocus = false,
    this.dropdownColor,
    this.menuMaxHeight,
    this.enableFeedback,
    this.alignment = AlignmentDirectional.centerStart,
    this.borderRadius,
  });

  final String? label;
  final String? hintText;
  final Icon? prefixIcon;
  final List<MkSelectItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final Widget? disabledHint;
  final int elevation;
  final TextStyle? style;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double iconSize;
  final bool isDense;
  final bool isExpanded;
  final double? itemHeight;
  final Color? focusColor;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? dropdownColor;
  final double? menuMaxHeight;
  final bool? enableFeedback;
  final AlignmentGeometry alignment;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themes = ref.watch(themeColorsProvider);
    final effectiveStyle =
        style ?? TextStyle(fontSize: 14, color: themes.fgColor);
    final effectiveDropdownColor = dropdownColor ?? themes.panelColor;

    return Material(
      color: Colors.transparent, // Make material transparent
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: TextStyle(fontSize: 13, color: themes.fgColor),
            ),
            const SizedBox(height: 6),
          ],
          DropdownButtonFormField<T>(
            value: value,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item.value,
                child: Text(item.label, style: effectiveStyle),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
            hint: hintText != null
                ? Text(hintText!,
                    style: effectiveStyle.copyWith(
                        color: themes.fgColor.withOpacity(0.6)))
                : null,
            disabledHint: disabledHint,
            elevation: elevation,
            style: effectiveStyle,
            decoration: inputDecoration(
              themes,
              null, // Hint text is handled by DropdownButtonFormField's hint property
              prefixIcon: prefixIcon,
            ).copyWith(
              fillColor: themes.panelColor, // Set background color
              filled: true,
            ),
            icon: icon,
            iconDisabledColor: iconDisabledColor,
            iconEnabledColor:
                iconEnabledColor ?? themes.fgColor.withOpacity(0.6),
            iconSize: iconSize,
            isDense: isDense,
            isExpanded: isExpanded,
            itemHeight: itemHeight,
            focusColor: focusColor,
            focusNode: focusNode,
            autofocus: autofocus,
            dropdownColor: effectiveDropdownColor,
            menuMaxHeight: menuMaxHeight,
            enableFeedback: enableFeedback,
            alignment: alignment,
            borderRadius: borderRadius,
          ),
        ],
      ),
    );
  }
}

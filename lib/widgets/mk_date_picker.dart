import 'package:date_picker_plus/date_picker_plus.dart'; // 导入 date_picker_plus
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart'; // 需要添加 intl 依赖
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/widgets/mk_dialog.dart';

import '../status/themes.dart';
import 'mk_input.dart'; // 导入 inputDecoration

/// 一个显示日期选择器的文本输入框。
///
/// 点击该输入框会弹出一个日期选择对话框。
class MkDatePicker extends ConsumerStatefulWidget {
  /// 创建一个 MkDatePicker 实例。
  const MkDatePicker({
    super.key,
    this.label,
    this.hintText,
    this.prefixIcon,
    this.onChanged,
    this.value,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.dateFormat,
  });

  /// 输入框上方的标签文本。
  final String? label;

  /// 输入框为空时显示的提示文本。
  final String? hintText;

  /// 显示在输入框前缀位置的图标。
  final Icon? prefixIcon;

  /// 当选择的日期发生变化时调用的回调函数。
  /// 如果用户清除了日期，则返回 `null`。
  final void Function(DateTime?)? onChanged;

  /// 当前选定的日期值。
  final DateTime? value;

  /// 日期选择器中允许选择的最早日期。
  /// 默认为 1900 年。
  final DateTime? firstDate;

  /// 日期选择器中允许选择的最晚日期。
  /// 默认为 2100 年。
  final DateTime? lastDate;

  /// 打开日期选择器时默认显示的日期。
  /// 如果未提供，则默认为当前日期。
  final DateTime? initialDate;

  /// 用于格式化和显示日期的格式字符串。
  /// 默认为 'yyyy-MM-dd'。
  /// 示例: 'yyyy/MM/dd', 'dd-MM-yyyy'。
  final String? dateFormat;

  @override
  ConsumerState<MkDatePicker> createState() => _MkDatePickerState();
}

class _MkDatePickerState extends ConsumerState<MkDatePicker> {
  late TextEditingController _controller;
  late DateFormat _formatter;
  DateTime? _selectedDate; // Add state to hold the selected date temporarily

  @override
  void initState() {
    super.initState();
    _formatter = DateFormat(widget.dateFormat ?? 'yyyy-MM-dd');
    _controller = TextEditingController(
        text: widget.value != null ? _formatter.format(widget.value!) : '');
  }

  @override
  void didUpdateWidget(MkDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      // Update controller text only if the value actually changed in the parent
      final newText =
          widget.value != null ? _formatter.format(widget.value!) : '';
      if (_controller.text != newText) {
        _controller.text = newText;
      }
    }
    if (oldWidget.dateFormat != widget.dateFormat) {
      _formatter = DateFormat(widget.dateFormat ?? 'yyyy-MM-dd');
      // Reformat if date exists
      if (widget.value != null) {
        _controller.text = _formatter.format(widget.value!);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, ThemeColorModel themes) async {
    // Initialize _selectedDate before showing the dialog
    _selectedDate = widget.value ?? widget.initialDate ?? DateTime.now();
    // Re-add styling using the correct parameters
    final DateTime? picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MkDialog(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DatePicker(
              initialDate: widget.value,
              onDateSelected: (value) {
                // Update the temporary selected date when a date is picked in the calendar
                _selectedDate = value;
              },
              minDate: widget.firstDate ?? DateTime(1900),
              maxDate: widget.lastDate ?? DateTime(2100),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 12,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context)
                      .pop(null), // Return null when Clear is pressed
                  child: Text(S.of(context).clear,
                      style: TextStyle(color: themes.fgColor)),
                ),
                Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(
                    widget.initialDate,
                  ), // Return null when Cancel is pressed
                  child: Text(S.of(context).cancel,
                      style: TextStyle(color: themes.fgColor)),
                ),
                FilledButton(
                  onPressed: () {
                    // Return the selected date
                    // Return the temporarily selected date when OK is pressed
                    Navigator.of(context).pop(_selectedDate);
                  },
                  child: Text(S.of(context).ok),
                ),
              ],
            ),
          ],
        ));
      },
    );

    // Check if a date was picked or cleared (picked can be null for clear)
    if (picked != widget.value) {
      //
      if (widget.onChanged != null) {
        widget.onChanged!(
            picked); // Pass the picked date (or null) to the callback
      }
      // didUpdateWidget will handle controller update if picked is not null
      // If picked is null (cleared), update controller manually
      if (picked == null) {
        _controller.clear();
      }
    }
  }

  // _clearDate might need a dedicated button now, removing for simplicity
  // void _clearDate() { ... }

  @override
  Widget build(BuildContext context) {
    final themes = ref.watch(themeColorsProvider);

    return Material(
      color: Colors.transparent, // Make material transparent
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: TextStyle(fontSize: 13, color: themes.fgColor),
            ),
            const SizedBox(height: 6),
          ],
          // Replace InkWell with GestureDetector for main area tap
          GestureDetector(
            // Make the hit testing opaque to prevent taps falling through to widgets below if any
            behavior: HitTestBehavior.opaque,
            onTap: () => _selectDate(context, themes),
            child: AbsorbPointer(
              // Prevent keyboard from appearing
              child: TextFormField(
                controller: _controller,
                readOnly: true, // Make text field read-only
                decoration: inputDecoration(
                  themes,
                  widget.hintText,
                  prefixIcon: widget.prefixIcon,
                  // Simplified suffix icon logic using a single IconButton
                ).copyWith(
                  fillColor: themes.panelColor,
                  filled: true,
                ),
                cursorWidth: 1,
                style: TextStyle(fontSize: 14, color: themes.fgColor),
                cursorColor: themes.fgColor,
                textAlignVertical: TextAlignVertical.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

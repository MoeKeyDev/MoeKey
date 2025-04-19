import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/settings/member_info_state.dart';
import 'package:moekey/widgets/mk_date_picker.dart';
import 'package:moekey/widgets/mk_input.dart';
import 'package:moekey/widgets/mk_select.dart';

class MkSettingSaveButton extends HookConsumerWidget {
  const MkSettingSaveButton({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var isLoading = useState(false);
    return FilledButton(
      onPressed: isLoading.value
          ? null
          : () async {
              isLoading.value = true;
              try {
                await ref
                    .read(memberInfoStateProvider.notifier)
                    .updateApi(data);
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("保存失败: $e"),
                  ),
                );
              } finally {
                // Use finally to ensure isLoading is always reset
                isLoading.value = false;
              }
            },
      child: isLoading.value
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text("保存"), // Use const
    );
  }
}

class MkFormItem extends StatelessWidget {
  // Changed to StatelessWidget as it has no state
  const MkFormItem({
    super.key,
    required this.label,
    required this.child,
    this.helperText,
  });

  final String label;
  final Widget child;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    // Removed WidgetRef ref
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // spacing: 8, // Use SizedBox for spacing if needed
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12), // Use const
        ),
        const SizedBox(height: 8), // Add spacing manually
        child,
        if (helperText != null) ...[
          const SizedBox(height: 8), // Add spacing manually
          Opacity(
            opacity: 0.75,
            child: Text(
              helperText!,
              style: const TextStyle(fontSize: 12), // Use const
            ),
          ),
        ]
      ],
    );
  }
}

// 可编辑日期字段 Widget
class MkSettingEditableDateField extends HookConsumerWidget {
  const MkSettingEditableDateField({
    super.key,
    required this.label,
    required this.value, // DateTime?
    required this.originalValue, // DateTime?
    required this.onChanged, // ValueChanged<DateTime?>
    required this.saveKey,
    this.prefixIcon,
  });

  final String label;
  final DateTime? value;
  final DateTime? originalValue;
  final ValueChanged<DateTime?> onChanged;
  final String saveKey;
  final Icon? prefixIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isModified = value != originalValue;

    // 将 DateTime? 转换为 YYYY-MM-DD 格式的 String? 以便保存
    String? valueString;
    if (value != null) {
      valueString =
          "${value!.year.toString().padLeft(4, '0')}-${value!.month.toString().padLeft(2, '0')}-${value!.day.toString().padLeft(2, '0')}";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MkDatePicker(
          label: label,
          value: value,
          prefixIcon: prefixIcon,
          onChanged: onChanged,
          initialDate: value,
        ),
        if (isModified)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: MkSettingSaveButton(
              data: {saveKey: valueString}, // 保存格式化后的字符串
            ),
          ),
      ],
    );
  }
}

class MkSettingEditableSelectField<T> extends HookConsumerWidget {
  const MkSettingEditableSelectField({
    this.prefixIcon,
    required this.label,
    required this.value,
    required this.originalValue,
    required this.onChanged,
    required this.saveKey,
    required this.items,
  });

  final String label;
  final String? value;
  final String? originalValue;
  final ValueChanged<String> onChanged;
  final String saveKey;
  final Icon? prefixIcon;
  final List<MkSelectItem<T>> items;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MkFormItem(
          label: label,
          child: MkSelect(
            prefixIcon: prefixIcon,
            value: value,
            items: items,
            onChanged: (v) {
              if (v != null) {
                onChanged(v.toString());
              }
            },
          ),
        ),
        if (value != originalValue)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: MkSettingSaveButton(
              data: {saveKey: value},
            ),
          ),
      ],
    );
  }
}

// 可编辑文本字段 Widget
class MkSettingEditableTextField extends HookConsumerWidget {
  const MkSettingEditableTextField({
    super.key,
    required this.label,
    required this.value,
    required this.originalValue,
    required this.onChanged,
    required this.saveKey,
    this.prefixIcon,
    this.minLines,
    this.helperText,
  });

  final String label;
  final String? value;
  final String? originalValue;
  final ValueChanged<String> onChanged;
  final String saveKey;
  final Icon? prefixIcon; // Changed type from Widget? to Icon?
  final int? minLines;
  final String? helperText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Normalize empty strings to null for comparison
    final String? normalizedValue =
        (value == null || value!.isEmpty) ? null : value;
    final String? normalizedOriginalValue =
        (originalValue == null || originalValue!.isEmpty)
            ? null
            : originalValue;
    final bool isModified = normalizedValue != normalizedOriginalValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // spacing: 8, // Use SizedBox for spacing if needed, or rely on parent Column spacing
      children: [
        MkFormItem(
          label: label,
          helperText: helperText,
          child: MkInput(
            prefixIcon: prefixIcon,
            value: value,
            minLines: minLines,
            onChanged: onChanged,
          ),
        ),
        if (isModified)
          Padding(
            padding: const EdgeInsets.only(
                top: 8.0), // Add some space before the button
            child: MkSettingSaveButton(
              data: {saveKey: value},
            ),
          ),
      ],
    );
  }
}

// 可编辑Switch字段 Widget
class MkSettingEditableSwitchField extends HookConsumerWidget {
  const MkSettingEditableSwitchField({
    super.key,
    required this.label,
    required this.value,
    required this.originalValue,
    required this.onChanged,
    required this.saveKey,
  });

  final String label;
  final bool value;
  final bool originalValue;
  final ValueChanged<bool> onChanged;
  final String saveKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MkFormItem(
          label: label,
          child: Switch(
            value: value,
            onChanged: (v) {
              onChanged(v);
            },
          ),
        ),
        if (value != originalValue)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: MkSettingSaveButton(
              data: {saveKey: value},
            ),
          ),
      ],
    );
  }
}

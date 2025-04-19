import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/settings/member_info_state.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/mk_image.dart';
import 'package:moekey/widgets/mk_date_picker.dart';
import 'package:moekey/widgets/mk_input.dart';
import 'package:moekey/widgets/mk_scaffold.dart';
import 'package:moekey/widgets/mk_select.dart';
import 'package:moekey/constants/languages.dart';

import '../../../apis/models/drive.dart';
import '../../../widgets/driver/driver_select_dialog/driver_select_dialog.dart';

// 可编辑文本字段 Widget
class _EditableTextField extends HookConsumerWidget {
  const _EditableTextField({
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
            child: _SaveButton(
              data: {saveKey: value},
            ),
          ),
      ],
    );
  }
}

// 可编辑日期字段 Widget
class _EditableDateField extends HookConsumerWidget {
  const _EditableDateField({
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
            child: _SaveButton(
              data: {saveKey: valueString}, // 保存格式化后的字符串
            ),
          ),
      ],
    );
  }
}

class _EditableSelectField<T> extends HookConsumerWidget {
  const _EditableSelectField({
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
            child: _SaveButton(
              data: {saveKey: value},
            ),
          ),
      ],
    );
  }
}

class SettingsProfile extends HookConsumerWidget {
  const SettingsProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.paddingOf(context);
    var meDetail = ref.watch(memberInfoStateProvider).valueOrNull;
    if (meDetail == null) {
      return const MkScaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 解析生日字符串为 DateTime?
    DateTime? currentBirthday;
    DateTime? originalBirthday;
    try {
      if (meDetail.user.birthday != null &&
          meDetail.user.birthday!.isNotEmpty) {
        currentBirthday = DateTime.tryParse(meDetail.user.birthday!);
      }
      if (meDetail.originalUser.birthday != null &&
          meDetail.originalUser.birthday!.isNotEmpty) {
        originalBirthday = DateTime.tryParse(meDetail.originalUser.birthday!);
      }
    } catch (e) {
      // Handle potential parse errors if needed
    }

    return MkScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          padding: mediaPadding,
          child: Column(
            spacing: 16,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProfileMemberCard(),
              _EditableTextField(
                label: "昵称",
                value: meDetail.user.name,
                originalValue: meDetail.originalUser.name,
                prefixIcon: const Icon(TablerIcons.user),
                saveKey: "name",
                onChanged: (value) {
                  ref
                      .read(memberInfoStateProvider.notifier)
                      .updateUser(meDetail.user.copyWith(name: value));
                },
              ),
              _EditableTextField(
                label: "个人简介",
                helperText: "你可以在个人简介中包含一些#标签。",
                value: meDetail.user.description,
                originalValue: meDetail.originalUser.description,
                minLines: 3,
                saveKey: "description",
                onChanged: (value) {
                  ref
                      .read(memberInfoStateProvider.notifier)
                      .updateUser(meDetail.user.copyWith(description: value));
                },
              ),
              _EditableTextField(
                label: "位置",
                value: meDetail.user.location,
                originalValue: meDetail.originalUser.location,
                prefixIcon: const Icon(TablerIcons.map_pin),
                saveKey: "location",
                onChanged: (value) {
                  ref
                      .read(memberInfoStateProvider.notifier)
                      .updateUser(meDetail.user.copyWith(location: value));
                },
              ),
              // 使用新的 _EditableBirthdayField 组件
              _EditableDateField(
                label: "生日",
                value: currentBirthday,
                originalValue: originalBirthday,
                prefixIcon: const Icon(TablerIcons.cake),
                saveKey: "birthday",
                onChanged: (date) {
                  String? dateString;
                  if (date != null) {
                    // Format date back to YYYY-MM-DD string or keep null
                    dateString =
                        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                  }
                  ref
                      .read(memberInfoStateProvider.notifier)
                      .updateUser(meDetail.user.copyWith(birthday: dateString));
                },
              ),
              _EditableSelectField(
                label: "语言",
                value: meDetail.user.lang,
                originalValue: meDetail.originalUser.lang,
                prefixIcon: const Icon(TablerIcons.language),
                saveKey: "lang",
                onChanged: (value) {
                  ref
                      .read(memberInfoStateProvider.notifier)
                      .updateUser(meDetail.user.copyWith(lang: value));
                },
                items: langmap.entries.map((entry) {
                  final String code = entry.key;
                  final String nativeName = entry.value['nativeName'] ?? code;
                  return MkSelectItem<String>(
                    label: nativeName,
                    value: code,
                  );
                }).toList()
                  ..sort((a, b) =>
                      a.label.compareTo(b.label)), // Sort by native name
              ),
              _EditableTextField(
                label: "被关注时的消息",
                value: meDetail.user.followedMessage,
                originalValue: meDetail.originalUser.followedMessage,
                helperText: "可以设置被关注时向对方显示的短消息。\n需要批准才能关注的情况下，消息是在请求被批准后显示。",
                saveKey: "followedMessage",
                onChanged: (value) {
                  ref.read(memberInfoStateProvider.notifier).updateUser(
                      meDetail.user.copyWith(followedMessage: value));
                },
              ),
            ],
          ),
        ),
      ),
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

class _ProfileMemberCard extends HookConsumerWidget {
  const _ProfileMemberCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var meDetail = ref.watch(memberInfoStateProvider).valueOrNull;
    if (meDetail == null) return const SizedBox.shrink();
    return SizedBox(
      height: 216,
      child: MkCard(
        padding: EdgeInsets.zero,
        child: SizedBox(
          height: 130,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: [
                  // This array access seems unusual, but kept as original
                  if (meDetail.user.bannerUrl != null)
                    MkImage(
                      meDetail.user.bannerUrl!,
                      fit: BoxFit.cover,
                      blurHash: meDetail.user.bannerBlurhash,
                      width: double.infinity,
                      height: 130,
                    )
                  else
                    Container(
                      color: const Color.fromARGB(40, 0, 0, 0),
                      height: 130,
                    ),
                ][0],
              ),
              Positioned(
                right: 10,
                top: 10,
                child: DriverSelectContextMenu(
                  builder: (context, open) {
                    return FilledButton(
                      onPressed: open,
                      child: const Text(
                        "修改横幅",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    );
                  },
                  maxSelect: 1,
                  selectCallback: (List<DriveFileModel> files) {
                    if (files.isNotEmpty) {
                      ref
                          .read(memberInfoStateProvider.notifier)
                          .setBanner(files.first.id);
                    }
                  },
                ),
              ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing:
                      16, // Column doesn't have spacing, use SizedBox if needed
                  children: [
                    MkImage(
                      meDetail.user.avatarUrl ?? "",
                      width: 72,
                      height: 72,
                      shape: BoxShape.circle,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16), // Added SizedBox for spacing
                    DriverSelectContextMenu(
                      builder: (context, open) {
                        return FilledButton(
                          onPressed: open,
                          child: const Text("修改头像"), // Use const
                        );
                      },
                      maxSelect: 1,
                      selectCallback: (List<DriveFileModel> files) {
                        if (files.isNotEmpty) {
                          ref
                              .read(memberInfoStateProvider.notifier)
                              .setAvatar(files.first.id);
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends HookConsumerWidget {
  const _SaveButton({required this.data});

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

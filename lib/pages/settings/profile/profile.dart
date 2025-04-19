import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/settings/member_info_state.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/mk_image.dart';
import 'package:moekey/widgets/mk_scaffold.dart';
import 'package:moekey/widgets/mk_select.dart';
import 'package:moekey/constants/languages.dart';
import 'package:moekey/widgets/settings/fields.dart';
import 'package:moekey/widgets/settings/folder.dart';

import '../../../apis/models/drive.dart';
import '../../../widgets/driver/driver_select_dialog/driver_select_dialog.dart';

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
              MkSettingEditableTextField(
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
              MkSettingEditableTextField(
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
              MkSettingEditableTextField(
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
              MkSettingEditableDateField(
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
              MkSettingEditableSelectField(
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
              MkSettingEditableTextField(
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
              MkFolder(
                title: "更多附加信息",
                icon: TablerIcons.list,
                child: Column(),
              ),
            ],
          ),
        ),
      ),
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

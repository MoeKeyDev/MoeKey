import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/settings/member_info_state.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/mk_image.dart';
import 'package:moekey/widgets/mk_input.dart';
import 'package:moekey/widgets/mk_scaffold.dart';

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
              _ProfileMemberCard(),
              MkFormItem(
                label: "昵称",
                child: MkInput(
                  prefixIcon: const Icon(TablerIcons.user),
                  value: meDetail.originalUser.name,
                  onChanged: (value) {
                    ref
                        .read(memberInfoStateProvider.notifier)
                        .updateUser(meDetail.user.copyWith(name: value));
                  },
                ),
              ),
              if (meDetail.user.name != meDetail.originalUser.name)
                SaveButton(
                  data: {
                    "name": meDetail.originalUser.name,
                  },
                ),
              MkFormItem(
                label: "个人简介",
                helperText: "你可以在个人简介中包含一些#标签。",
                child: MkInput(
                  value: meDetail.originalUser.description,
                  minLines: 3,
                  onChanged: (value) {
                    ref
                        .read(memberInfoStateProvider.notifier)
                        .updateUser(meDetail.user.copyWith(description: value));
                  },
                ),
              ),
              if (meDetail.user.description !=
                  meDetail.originalUser.description)
                SaveButton(
                  data: {
                    "description": meDetail.user.description,
                  },
                ),
              MkFormItem(
                label: "位置",
                child: MkInput(
                  prefixIcon: Icon(TablerIcons.map_pin),
                  value: meDetail.originalUser.location,
                  onChanged: (value) {
                    ref
                        .read(memberInfoStateProvider.notifier)
                        .updateUser(meDetail.user.copyWith(location: value));
                  },
                ),
              ),
              if (meDetail.user.location != meDetail.originalUser.location)
                SaveButton(
                  data: {
                    "location": meDetail.user.location,
                  },
                ),
              MkFormItem(
                label: "生日",
                child: InkWell(
                  onTap: () async {
                    DateTime? initialDate;
                    try {
                      if (meDetail.user.birthday != null &&
                          meDetail.user.birthday!.isNotEmpty) {
                        initialDate = DateTime.parse(meDetail.user.birthday!);
                      }
                    } catch (e) {
                      // Ignore parse error, use default initial date
                    }
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: initialDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      // Format date as YYYY-MM-DD
                      String formattedDate =
                          "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                      ref.read(memberInfoStateProvider.notifier).updateUser(
                          meDetail.user.copyWith(birthday: formattedDate));
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      prefixIcon: Icon(TablerIcons.calendar),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        // Also set enabled border color
                        borderSide: BorderSide(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.6)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 12, horizontal: 10), // Adjust padding
                    ),
                    child: Text(
                      meDetail.user.birthday?.isNotEmpty == true
                          ? meDetail.user.birthday!
                          : '选择日期', // Show placeholder if empty
                      style: TextStyle(
                        color: meDetail.user.birthday?.isNotEmpty == true
                            ? null
                            : Theme.of(context).hintColor,
                      ),
                    ),
                  ),
                ),
              ),
              if (meDetail.user.birthday !=
                  meDetail
                      .originalUser.birthday) // Assuming birthday field exists
                SaveButton(
                  data: {
                    "birthday": meDetail
                        .user.birthday, // Assuming birthday field exists
                  },
                ),
              MkFormItem(
                label: "语言",
                child: MkInput(
                  prefixIcon: Icon(TablerIcons.language),
                  value: meDetail
                      .originalUser.lang, // Use 'lang' instead of 'language'
                  onChanged: (value) {
                    ref.read(memberInfoStateProvider.notifier).updateUser(
                        meDetail.user.copyWith(
                            lang: value)); // Use 'lang' instead of 'language'
                  },
                ),
              ),
              if (meDetail.user.lang !=
                  meDetail
                      .originalUser.lang) // Use 'lang' instead of 'language'
                SaveButton(
                  data: {
                    "lang":
                        meDetail.user.lang, // Use 'lang' instead of 'language'
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MkFormItem extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
        child,
        if (helperText != null)
          Opacity(
            opacity: 0.75,
            child: Text(
              helperText!,
              style: TextStyle(fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class _ProfileMemberCard extends HookConsumerWidget {
  const _ProfileMemberCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var meDetail = ref.watch(memberInfoStateProvider).valueOrNull;
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
                  if (meDetail!.user.bannerUrl != null)
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
                      onPressed: () {
                        open();
                      },
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
                  spacing: 16,
                  children: [
                    MkImage(
                      meDetail.user.avatarUrl ?? "",
                      width: 72,
                      height: 72,
                      shape: BoxShape.circle,
                      fit: BoxFit.cover,
                    ),
                    DriverSelectContextMenu(
                      builder: (context, open) {
                        return FilledButton(
                          onPressed: () {
                            open();
                          },
                          child: Text("修改头像"),
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

class SaveButton extends HookConsumerWidget {
  const SaveButton({super.key, required this.data});

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
                // Handle error
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("保存失败: $e"),
                  ),
                );
              }
              isLoading.value = false;
            },
      child: Text("保存"),
    );
  }
}

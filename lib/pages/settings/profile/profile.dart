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
import '../../../status/me_detailed.dart';
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
  const _ProfileMemberCard({super.key});

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

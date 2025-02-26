import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/mk_image.dart';
import 'package:moekey/widgets/mk_input.dart';
import 'package:moekey/widgets/mk_scaffold.dart';

import '../../../status/me_detailed.dart';

class SettingsProfile extends HookConsumerWidget {
  const SettingsProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.paddingOf(context);

    var meDetail = ref.watch(currentMeDetailedProvider).valueOrNull;
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
                  value: meDetail.name,
                ),
              ),
              MkFormItem(
                label: "个人简介",
                helperText: "你可以在个人简介中包含一些#标签。",
                child: MkInput(
                  value: meDetail.description,
                  minLines: 3,
                ),
              ),
              MkFormItem(
                label: "位置",
                child: const MkInput(
                  prefixIcon: Icon(TablerIcons.map_pin),
                ),
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
    var meDetail = ref.watch(currentMeDetailedProvider).valueOrNull;
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
                  if (meDetail?.bannerUrl != null)
                    MkImage(
                      meDetail!.bannerUrl!,
                      fit: BoxFit.cover,
                      blurHash: meDetail.bannerBlurhash,
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
                child: FilledButton(
                  onPressed: () {},
                  child: const Text(
                    "修改横幅",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
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
                      meDetail?.avatarUrl ?? "",
                      width: 72,
                      height: 72,
                      shape: BoxShape.circle,
                      fit: BoxFit.cover,
                    ),
                    FilledButton(onPressed: () {}, child: Text("修改头像")),
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

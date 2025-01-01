import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/pages/settings/two_panel_layout.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/mk_header.dart';
import 'package:moekey/widgets/mk_scaffold.dart';

import '../../logger.dart';
import '../../main.dart';

var settingList = [
  {
    "label": "基本设置",
    "child": [
      {
        'label': '个人资料',
        'icon': TablerIcons.user,
        'routerId': 'settingsTest1',
      },
      {
        'label': '隐私',
        'icon': TablerIcons.lock_open,
        'routerId': 'settingsTest2',
      },
      {
        'label': '账户管理',
        'icon': TablerIcons.users,
        'routerId': 'settingsAccountManager',
      },
    ]
  },
];

class SettingBodyWide extends HookConsumerWidget {
  const SettingBodyWide({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.paddingOf(context);
    var currentId = GoRouter.of(context).state?.name;
    return Row(
      children: [
        SizedBox(width: 32),
        SizedBox(
          width: 220,
          child: ListView(
            padding: EdgeInsets.only(top: mediaPadding.top),
            children: [
              for (var item in settingList)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SettingsMenuLabel(label: item["label"] as String),
                    for (var child in item['child'] as List)
                      _SettingsMenuItem(
                        label: child['label'],
                        icon: child['icon'],
                        routerId: child['routerId'],
                        currentId: currentId ?? "",
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettingBodyNarrow extends HookConsumerWidget {
  const SettingBodyNarrow({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.paddingOf(context);
    var currentId = GoRouter.of(context).state?.name;
    var isWide = WindowSize.of(context)!.isWide;
    if (isWide) {
      return SizedBox();
    }
    return ListView(
      padding: EdgeInsets.only(
          top: 16 + mediaPadding.top,
          left: 16,
          right: 16,
          bottom: mediaPadding.bottom),
      children: [
        for (var item in settingList)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SettingsMenuLabel(label: item["label"] as String),
              for (var child in item['child'] as List)
                _SettingsMenuItem(
                  label: child['label'],
                  icon: child['icon'],
                  routerId: child['routerId'],
                  currentId: currentId ?? '',
                  isPush: true,
                ),
            ],
          ),
      ],
    );
  }
}

class _SettingsMenuLabel extends ConsumerWidget {
  const _SettingsMenuLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = ref.watch(themeColorsProvider);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 13),
      ),
    );
  }
}

class _SettingsMenuItem extends ConsumerWidget {
  const _SettingsMenuItem({
    super.key,
    required this.label,
    required this.icon,
    required this.routerId,
    this.isPush = false,
    required this.currentId,
  });

  final String label;
  final IconData icon;
  final String routerId;
  final bool isPush;
  final String currentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var theme = ref.watch(themeColorsProvider);
    var isActive = currentId == routerId;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Material(
          color: isActive ? theme.accentedBgColor : theme.bgColor,
          child: InkWell(
            onTap: () {
              if (isPush) {
                context.pushNamed(routerId);
                return;
              }
              context.goNamed(routerId);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: isActive ? theme.accentColor : theme.fgColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: TextStyle(
                      color: isActive ? theme.accentColor : theme.fgColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/utils/get_padding_note.dart';
import 'package:moekey/widgets/mfm_text/mfm_text.dart';
import 'package:moekey/widgets/mk_card.dart';
import 'package:moekey/widgets/mk_image.dart';
import 'package:moekey/widgets/mk_refresh_load.dart';
import 'package:moekey/widgets/mk_tabbar_list.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../apis/models/announcement.dart';
import '../../status/themes.dart';
import '../../utils/time_to_desired_format.dart';

part 'announcements.g.dart';

class AnnouncementsPage extends HookConsumerWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return MkTabBarRefreshScroll(
      items: [
        MkTabBarItem(
            label: const Tab(
              child: Row(
                children: [
                  Icon(
                    TablerIcons.bolt,
                    size: 14,
                  ),
                  Text("现在的公告", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            child: const AnnouncementsList(
              isActive: true,
            )),
        MkTabBarItem(
            label: const Tab(
              child: Row(
                children: [
                  Icon(
                    TablerIcons.point,
                    size: 14,
                  ),
                  Text("过去的公告", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            child: const AnnouncementsList(
              isActive: false,
            ))
      ],
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(TablerIcons.speakerphone, color: themes.fgColor, size: 18),
            const SizedBox(width: 8),
            const Text("公告")
          ],
        ),
      ),
      tabAlignment: TabAlignment.center,
      offset: 100,
    );
  }
}

@riverpod
class _Announcements extends _$Announcements {
  @override
  FutureOr<MkLoadMoreListModel<Announcement>> build(
      {bool isActive = true}) async {
    var model = MkLoadMoreListModel<Announcement>();
    model.list = await api();
    // page = 0;
    return model;
  }

  int page = 0;

  Future<List<Announcement>> api({int limit = 10, String? untilId}) {
    var api = ref.watch(misskeyApisProvider);
    return api.meta
        .announcements(limit: limit, isActive: isActive, untilId: untilId);
  }

  read({required String announcementId}) async {
    var api = ref.read(misskeyApisProvider);
    api.meta.readAnnouncement(announcementId: announcementId);
    var model = state.valueOrNull ?? MkLoadMoreListModel<Announcement>();
    for (var value in model.list) {
      if (value.id == announcementId) {
        value.isRead = true;
      }
    }
    state = AsyncData(model);
  }

  loadMore() async {
    if (state.isLoading) return;
    state = const AsyncValue.loading();
    var model = state.valueOrNull ?? MkLoadMoreListModel<Announcement>();
    try {
      page++;
      var list = await api(limit: 10, untilId: model.list.lastOrNull?.id);
      print(list);
      model.list += list;
      if (list.isEmpty) {
        model.hasMore = false;
      }
    } finally {
      state = AsyncData(model);
    }
  }
}

class AnnouncementsList extends HookConsumerWidget {
  const AnnouncementsList({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var provider = _announcementsProvider(isActive: isActive);
    var data = ref.watch(provider);
    return LayoutBuilder(
      builder: (context, constraints) {
        var padding = getPaddingForNote(constraints);
        return MkRefreshLoadList(
            onLoad: () => ref.read(provider.notifier).loadMore(),
            onRefresh: () => ref.refresh(provider.future),
            hasMore: data.valueOrNull?.hasMore,
            padding: EdgeInsets.symmetric(horizontal: padding),
            slivers: [
              SliverList.separated(
                itemBuilder: (context, index) => AnnouncementsCard(
                  announcement: data.valueOrNull!.list[index],
                  onRead: isActive
                      ? () => ref.read(provider.notifier).read(
                          announcementId: data.valueOrNull!.list[index].id)
                      : null,
                ),
                itemCount: data.valueOrNull?.list.length ?? 0,
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 10,
                  );
                },
              )
            ]);
      },
    );
  }
}

class AnnouncementsCard extends HookConsumerWidget {
  const AnnouncementsCard({
    super.key,
    required this.announcement,
    this.onRead,
  });

  final Announcement announcement;
  final Future Function()? onRead;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return MkCard(
      shadow: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                [
                  if (announcement.icon == AnnouncementIcon.ERROR)
                    TablerIcons.circle_x
                  else if (announcement.icon == AnnouncementIcon.INFO)
                    TablerIcons.info_circle
                  else if (announcement.icon == AnnouncementIcon.SUCCESS)
                    TablerIcons.check
                  else if (announcement.icon == AnnouncementIcon.WARNING)
                    TablerIcons.alert_triangle
                ][0],
                size: 18,
                color: [
                  if (announcement.icon == AnnouncementIcon.ERROR)
                    themes.errorColor
                  else if (announcement.icon == AnnouncementIcon.INFO)
                    themes.accentColor
                  else if (announcement.icon == AnnouncementIcon.SUCCESS)
                    themes.successColor
                  else if (announcement.icon == AnnouncementIcon.WARNING)
                    themes.warnColor
                ][0],
              ),
              const SizedBox(width: 8),
              Text(
                announcement.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(height: 16),
          MFMText(text: announcement.text),
          const SizedBox(height: 16),
          if (announcement.imageUrl != null) MkImage(announcement.imageUrl!),
          const SizedBox(height: 16),
          Opacity(
            opacity: 0.7,
            child: Text(
              "创建时间:${timeToDesiredFormat(announcement.createdAt)}\r\n${announcement.updatedAt != null ? "更新时间:${timeToDesiredFormat(announcement.updatedAt!)}" : ""}",
              style: const TextStyle(fontSize: 13),
            ),
          ),
          if (!announcement.isRead &&
              !announcement.silence &&
              onRead != null) ...[
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                onRead!();
              },
              style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(themes.accentColor),
                  foregroundColor:
                      WidgetStateProperty.all(themes.fgOnAccentColor),
                  elevation: WidgetStateProperty.all(0)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(TablerIcons.check, size: 18),
                  SizedBox(width: 4),
                  Text("好"),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}

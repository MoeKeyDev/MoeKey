import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/state/themes.dart';
import 'package:moekey/widgets/mk_header.dart';

import '../../networks/user.dart';
import '../../widgets/loading_weight.dart';
import '../../widgets/notes/note_card.dart';

List<Map<String, bool>> _noteFilter = [
  {
    "withRenotes": false,
    "withChannelNotes": false,
    "withFiles": false,
    "withReplies": false,
    "withFeatured": true,
  },
  {
    "withRenotes": false,
    "withChannelNotes": false,
    "withFiles": false,
    "withReplies": false,
    "withFeatured": false,
  },
  {
    "withRenotes": true,
    "withChannelNotes": true,
    "withFiles": false,
    "withReplies": true,
    "withFeatured": false,
  },
  {
    "withRenotes": false,
    "withChannelNotes": false,
    "withFiles": true,
    "withReplies": false,
    "withFeatured": false,
  }
];

class UserNotesPage extends HookConsumerWidget {
  const UserNotesPage({
    super.key,
    required this.userId,
  });
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.paddingOf(context);
    var themes = ref.watch(themeColorsProvider);
    var select = useState(2);
    var dataProvider = userNotesListProvider(
      userId: userId,
      withRenotes: _noteFilter[select.value]["withRenotes"]!,
      withChannelNotes: _noteFilter[select.value]["withChannelNotes"]!,
      withFiles: _noteFilter[select.value]["withFiles"]!,
      withReplies: _noteFilter[select.value]["withReplies"]!,
      withFeatured: _noteFilter[select.value]["withFeatured"]!,
      key: 1,
    );
    var data = ref.watch(dataProvider);
    print(data.error);
    return LayoutBuilder(
      builder: (context, constraints) {
        double padding = 0;
        if (constraints.maxWidth > 860) {
          padding = (constraints.maxWidth - 800) / 2;
        } else if (constraints.maxWidth > 500) {
          padding = 30;
        } else if (constraints.maxWidth > 400) {
          padding = 8;
        } else {
          padding = 0;
        }

        return Stack(
          children: [
            RefreshIndicator.adaptive(
              onRefresh: () => ref.refresh(dataProvider.future),
              edgeOffset: mediaPadding.top,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: MediaQuery.paddingOf(context)
                          .copyWith(left: padding, right: padding),
                      sliver: SliverMainAxisGroup(
                        slivers: [
                          const SliverPadding(
                              padding: EdgeInsets.only(top: 40)),
                          SliverList.separated(
                            addAutomaticKeepAlives: true,
                            itemBuilder: (BuildContext context, int index) {
                              BorderRadius borderRadius;
                              if (index == 0) {
                                borderRadius = const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12));
                              } else {
                                borderRadius =
                                    const BorderRadius.all(Radius.zero);
                              }
                              return NoteCard(
                                  key: ValueKey(
                                      data.valueOrNull!.list[index].id),
                                  borderRadius: borderRadius,
                                  data: data.valueOrNull!.list[index]);
                              // return KeepAliveWrapper(
                              //     child: TimelineCardComponent(
                              //   data: data.valueOrNull![index],
                              //   borderRadius: borderRadius,
                              // ));
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                width: double.infinity,
                                height: 1,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: themes.dividerColor,
                                  ),
                                ),
                              );
                            },
                            itemCount: (data.valueOrNull?.list.length ?? 0),
                          ),
                          SliverLayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.remainingPaintExtent > 0 &&
                                  (data.valueOrNull?.hasMore ?? false)) {
                                ref.read(dataProvider.notifier).load();
                              }
                              if (!(data.valueOrNull?.hasMore ?? true)) {
                                return const SliverToBoxAdapter(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: Text("暂无更多"),
                                    ),
                                  ),
                                );
                              }
                              return const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                    child: LoadingCircularProgress(),
                                  ),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: mediaPadding.top - 8,
              left: 0,
              right: 0,
              child: MediaQuery(
                data: const MediaQueryData(padding: EdgeInsets.zero),
                child: MkToolBar(
                  height: 50,
                  border: 0,
                  // color: themes.bgColor,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: Row(
                      children: [
                        Expanded(
                            child: _NotesSelectButton(
                          active: select.value == 0,
                          text: "热门",
                          onTap: () {
                            select.value = 0;
                          },
                        )),
                        Expanded(
                            child: _NotesSelectButton(
                          active: select.value == 1,
                          text: "帖子",
                          onTap: () {
                            select.value = 1;
                          },
                        )),
                        Expanded(
                            child: _NotesSelectButton(
                          active: select.value == 2,
                          text: "全部",
                          onTap: () {
                            select.value = 2;
                          },
                        )),
                        Expanded(
                            child: _NotesSelectButton(
                          active: select.value == 3,
                          text: "附件",
                          onTap: () {
                            select.value = 3;
                          },
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class _NotesSelectButton extends HookConsumerWidget {
  const _NotesSelectButton({
    super.key,
    required this.active,
    required this.text,
    required this.onTap,
  });
  final bool active;
  final String text;
  final void Function() onTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themes = ref.watch(themeColorsProvider);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
            color: active ? themes.accentedBgColor : Colors.transparent,
            borderRadius: const BorderRadius.all(Radius.circular(100))),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(
          text,
          style: TextStyle(
              color: active ? themes.accentColor : themes.fgColor,
              fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

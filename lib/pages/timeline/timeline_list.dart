import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:misskey/networks/timeline.dart';
import 'package:misskey/state/themes.dart';

import '../../widgets/loading_weight.dart';
import '../../widgets/notes/note_card.dart';

class TimeLineListPage extends HookConsumerWidget {
  const TimeLineListPage({
    Key? key,
    required this.api,
    this.selectHttp = false,
    this.nestedScroll = false,
  }) : super(key: key);
  final String api;
  final bool selectHttp;
  final bool nestedScroll;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.of(context).padding;
    var dataProvider =
        timelineProvider(api: api, selectHttpProvider: selectHttp);
    var data = ref.watch(dataProvider);
    var themes = ref.watch(themeColorsProvider);
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
        return RefreshIndicator.adaptive(
          onRefresh: () => ref.refresh(dataProvider.future),
          edgeOffset: mediaPadding.top,
          child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
              ),
              child: LoadingAndEmpty(
                loading: data.isLoading,
                empty: data.valueOrNull?.isEmpty ?? true,
                refresh: () {
                  ref.invalidate(dataProvider);
                },
                child: CustomScrollView(
                  // controller: scrollController,
                  slivers: [
                    if (nestedScroll)
                      SliverOverlapInjector(
                        // This is the flip side of the SliverOverlapAbsorber
                        // above.
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(padding, mediaPadding.top,
                          padding, mediaPadding.bottom),
                      sliver: SliverMainAxisGroup(
                        slivers: [
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
                                  key: ValueKey(data.valueOrNull![index].id),
                                  borderRadius: borderRadius,
                                  data: data.valueOrNull![index]);
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
                            itemCount: data.valueOrNull?.length ?? 0,
                          ),
                          SliverLayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.remainingPaintExtent > 0) {
                                ref.read(dataProvider.notifier).load(api: api);
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
              )),
        );
      },
    );
  }
}

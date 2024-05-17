import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/themes.dart';

import '../../status/user.dart';
import '../../widgets/loading_weight.dart';
import '../../widgets/notes/note_card.dart';

class UserReactionsPage extends HookConsumerWidget {
  const UserReactionsPage({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var mediaPadding = MediaQuery.paddingOf(context);
    var themes = ref.watch(themeColorsProvider);
    var dataProvider = userReactionsListProvider(
      userId: userId,
    );
    var data = ref.watch(dataProvider);
    print(data.error);
    print(data.stackTrace);
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
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: MediaQuery.paddingOf(context)
                      .copyWith(left: padding, right: padding),
                  sliver: SliverMainAxisGroup(
                    slivers: [
                      const SliverPadding(padding: EdgeInsets.only(top: 0)),
                      SliverList.separated(
                        addAutomaticKeepAlives: true,
                        itemBuilder: (BuildContext context, int index) {
                          BorderRadius borderRadius;
                          if (index == 0) {
                            borderRadius = const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12));
                          } else {
                            borderRadius = const BorderRadius.all(Radius.zero);
                          }
                          return NoteCard(
                              key: ValueKey(data.valueOrNull!.list[index].id),
                              borderRadius: borderRadius,
                              data: data.valueOrNull!.list[index]);
                        },
                        separatorBuilder: (BuildContext context, int index) {
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
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/loading_weight.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:twemoji_v2/twemoji_v2.dart';

import '../apis/models/emojis.dart';
import 'mk_image.dart';

class EmojiList extends HookConsumerWidget {
  const EmojiList({super.key, this.scrollController, required this.onInsert});

  final ScrollController? scrollController;
  final void Function(Map data) onInsert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var data = ref.watch(apiEmojisByCategoryProvider);
    var list = data.valueOrNull?.keys.toList() ?? [];
    ScrollController scrollController1 =
        scrollController ?? useScrollController();
    var a = useMemoized<ListObserverController>(
        () => ListObserverController(controller: scrollController1));
    if (data.isLoading) {
      return const LoadingWidget();
    }
    if (list.isEmpty) {
      return const EmptyWidget();
    }
    var tabController = useTabController(initialLength: list.length);
    return LayoutBuilder(
      builder: (context, constraints) {
        int colCount = ((constraints.maxWidth - 16) / 52).truncate();
        var margin = 4.0;
        return Stack(
          children: [
            TabBar(
              tabs: [
                for (var item in list)
                  Tab(
                    child: Tooltip(
                      message: item,
                      child: [
                        if (data.valueOrNull![item]?[0].code == false)
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: MkImage(
                              data.valueOrNull![item]![0].url,
                            ),
                          )
                        else
                          Twemoji(
                            emoji: data.valueOrNull![item]![0].url,
                            width: 30,
                            height: 30,
                          )
                      ][0],
                    ),
                  )
              ],
              controller: tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: const EdgeInsets.symmetric(horizontal: 8),
              onTap: (value) {
                a.animateTo(
                    index: value,
                    duration: const Duration(milliseconds: 300),
                    curve: Easing.emphasizedDecelerate);
              },
            ),
            Positioned(
              top: 48,
              child: SizedBox(
                width: constraints.maxWidth,
                height: (constraints.maxHeight - 48).clamp(0, double.infinity),
                child: ListViewObserver(
                  onObserve: (p0) {
                    tabController.animateTo(p0.displayingChildIndexList[0]);
                  },
                  controller: a,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: list.length,
                    controller: scrollController1,
                    itemBuilder: (context, index) {
                      var item = list[index];
                      var i = data.valueOrNull![item];
                      var rowCount = ((i?.length ?? 0) / colCount).ceil();
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Text(item),
                          const SizedBox(
                            height: 8,
                          ),
                          for (int i1 = 0; i1 < rowCount; i1++) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (int i2 = 0; i2 < colCount; i2++)
                                  if ((colCount * i1 + i2) < (i?.length ?? 0))
                                    RepaintBoundary(
                                      child: _EmojiTile(
                                          item: i![colCount * i1 + i2],
                                          onInsert: onInsert),
                                    )
                                  else
                                    const SizedBox(
                                      width: 44,
                                      height: 44,
                                    )
                              ],
                            ),
                            const SizedBox(height: 8)
                          ],
                        ],
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  static showBottomSheet(BuildContext context,
      {required void Function(Map data, BuildContext context) onInsert}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) {
        return HookConsumer(
          builder: (context, ref, child) {
            var themes = ref.watch(themeColorsProvider);
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              behavior: HitTestBehavior.opaque,
              child: DraggableScrollableSheet(
                initialChildSize: 0.4,
                //set this as you want
                maxChildSize: 0.8,
                //set this as you want
                minChildSize: 0.4,
                //set this as you want
                expand: true,
                builder: (context, scrollController) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                    decoration: BoxDecoration(
                        color: themes.panelColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24))),
                    height: 1000,
                    child: GestureDetector(
                      onTap: () {},
                      child: EmojiList(
                        scrollController: scrollController,
                        onInsert: (data) {
                          onInsert(data, context);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _EmojiTile extends StatelessWidget {
  const _EmojiTile({super.key, required this.item, required this.onInsert});

  final EmojiSimple item;
  final void Function(Map data) onInsert;

  @override
  Widget build(BuildContext context) {
    if (item.code == false) {
      return Tooltip(
        message: item.name,
        child: GestureDetector(
          onTap: () {
            var item1 = Map.from(item.toMap());
            item1["name"] = ":${item1["name"]}:";
            onInsert(item1);
          },
          child: MkImage(
            item.url,
            fit: BoxFit.contain,
            width: 44,
            height: 44,
          ),
        ),
      );
    } else {
      return Tooltip(
        message: item.name,
        child: GestureDetector(
          onTap: () {
            var item1 = Map.from(item.toMap());
            item1["name"] = item1["url"];
            onInsert(item1);
          },
          child: Twemoji(
            width: 44,
            height: 44,
            emoji: item.url,
          ),
        ),
      );
    }
  }
}

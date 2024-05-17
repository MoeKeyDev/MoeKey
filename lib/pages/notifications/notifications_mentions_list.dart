import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/status/notifications.dart';
import 'package:moekey/utils/get_padding_note.dart';

import '../../main.dart';
import '../../status/themes.dart';
import '../../widgets/loading_weight.dart';
import '../../widgets/mk_card.dart';
import '../../widgets/notes/note_card.dart';

class MentionsList extends HookConsumerWidget {
  const MentionsList({
    super.key,
    this.specified = false,
  });

  final bool specified;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var res = ref.watch(mentionsNotificationsProvider(specified: specified));
    var themes = ref.watch(themeColorsProvider);
    var mediaPadding = MediaQuery.of(context).padding;
    logger.d(mediaPadding);
    // logger.d(res);
    var scrollController = useScrollController();
    useEffect(() {
      scrollController.addListener(() {
        if (scrollController.offset + 1000 >=
            scrollController.position.maxScrollExtent) {
          ref
              .read(
                  mentionsNotificationsProvider(specified: specified).notifier)
              .loadMore();
        }
      });
      return null;
    }, const []);
    return RefreshIndicator.adaptive(
      onRefresh: () => ref.refresh(notificationsProvider.future),
      edgeOffset: mediaPadding.top - 8,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: LoadingAndEmpty(
          loading: res.isLoading,
          empty: res.valueOrNull?.isEmpty ?? true,
          refresh: () {
            ref.invalidate(notificationsProvider);
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              var padding = getPaddingForNote(constraints);
              return ListView.separated(
                itemCount: res.valueOrNull?.length ?? 0,
                controller: scrollController,
                itemBuilder: (context, index) {
                  BorderRadius borderRadius;
                  if (index == 0) {
                    borderRadius = const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12));
                  } else {
                    borderRadius = const BorderRadius.all(Radius.zero);
                  }

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: MkCard(
                        shadow: false,
                        borderRadius: borderRadius,
                        child: NoteCard(
                          data: res.valueOrNull![index],
                          borderRadius: borderRadius,
                        )),
                  );
                  // return SizedBox();
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: SizedBox(
                      width: double.infinity,
                      height: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: themes.dividerColor,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

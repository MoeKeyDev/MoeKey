import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/apis/models/hashtag_trend.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/themes.dart';
import 'package:moekey/widgets/loading_weight.dart';
import 'package:moekey/widgets/mk_refresh_indicator.dart';

final searchTrendsProvider = FutureProvider<List<HashtagTrendModel>>((ref) {
  return ref.watch(misskeyApisProvider).hashtags.trend();
});

class SearchTrendsPage extends ConsumerWidget {
  const SearchTrendsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trends = ref.watch(searchTrendsProvider);
    return trends.when(
      loading: () => const Center(child: LoadingCircularProgress()),
      error: (_, _) => Center(
        child: IconButton(
          onPressed: () => ref.invalidate(searchTrendsProvider),
          tooltip: S.current.refresh,
          icon: const Icon(Icons.refresh),
        ),
      ),
      data: (items) => _TrendList(
        items: items,
        onRefresh: () => ref.refresh(searchTrendsProvider.future),
      ),
    );
  }
}

class _TrendList extends ConsumerWidget {
  const _TrendList({required this.items, required this.onRefresh});

  final List<HashtagTrendModel> items;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themes = ref.watch(themeColorsProvider);
    final mediaPadding = MediaQuery.paddingOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = math.max(
          16.0,
          (constraints.maxWidth - 800) / 2,
        );
        return MkRefreshIndicator(
          key: const ValueKey('search-trends-refresh'),
          onRefresh: onRefresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              mediaPadding.top,
              horizontalPadding,
              mediaPadding.bottom + 24,
            ),
            children: [
              if (items.isEmpty)
                SizedBox(
                  height: 300,
                  child: Center(child: Text(S.current.noLists)),
                )
              else
                Material(
                  key: const ValueKey('search-trends-card'),
                  color: themes.panelColor,
                  borderRadius: BorderRadius.circular(12),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (final (index, item) in items.indexed) ...[
                        if (index > 0)
                          Divider(height: 1, color: themes.dividerColor),
                        InkWell(
                          onTap: () => context.push(
                            '/tags/${Uri.encodeComponent(item.tag)}',
                          ),
                          child: SizedBox(
                            height: 62,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '#${item.tag}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: themes.fgColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${MaterialLocalizations.of(context).formatDecimal(item.usersCount)} · ${S.current.usersCount}',
                                          style: TextStyle(
                                            color: themes.fgColor.withValues(
                                              alpha: 0.65,
                                            ),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  SizedBox(
                                    width: 48,
                                    height: 30,
                                    child: CustomPaint(
                                      painter: _TrendChartPainter(
                                        values: item.chart,
                                        color: themes.accentColor.withValues(
                                          alpha: 0.7,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  const _TrendChartPainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) {
      return;
    }

    final maxValue = values.reduce(math.max);
    final scale = maxValue <= 0 ? 1.0 : maxValue;
    final path = Path();
    for (final (index, value) in values.indexed) {
      final x = values.length == 1
          ? size.width
          : size.width * index / (values.length - 1);
      final y = size.height - 1 - (value / scale) * (size.height - 2);
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, paint);

    final lastValue = values.last;
    final lastY = size.height - 1 - (lastValue / scale) * (size.height - 2);
    canvas.drawCircle(Offset(size.width, lastY), 1.7, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_TrendChartPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.color != color;
  }
}

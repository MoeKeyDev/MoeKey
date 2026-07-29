import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/status/apis.dart';
import 'package:moekey/widgets/loading_weight.dart';
import 'package:moekey/widgets/mk_refresh_load.dart';
import 'package:moekey/widgets/sliver_load_more.dart';

void main() {
  testWidgets('initial list errors replace the pagination spinner with retry', (
    tester,
  ) async {
    var retryCount = 0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [instanceMetaProvider.overrideWith((ref) async => null)],
        child: MaterialApp(
          locale: const Locale('zh', 'CN'),
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: Scaffold(
            body: MkRefreshLoadList<String>(
              onLoad: () async {},
              onRefresh: () async {},
              hasMore: true,
              empty: true,
              initialError: Exception('server error'),
              onRetry: () => retryCount++,
              slivers: const [],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MkErrorState), findsOneWidget);
    expect(find.byType(SliverLoadMore), findsNothing);
    expect(find.text('操作失败，请稍后重试'), findsOneWidget);

    await tester.tap(find.text('刷新'));
    expect(retryCount, 1);
  });

  testWidgets(
    'load-more errors keep existing content and replace only footer',
    (tester) async {
      var retryCount = 0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [instanceMetaProvider.overrideWith((ref) async => null)],
          child: MaterialApp(
            locale: const Locale('zh', 'CN'),
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: Scaffold(
              body: MkRefreshLoadList<String>(
                onLoad: () async {},
                onRefresh: () async {},
                hasMore: true,
                empty: false,
                loadMoreError: Exception('server error'),
                onRetryLoadMore: () => retryCount++,
                slivers: const [
                  SliverToBoxAdapter(child: Text('existing content')),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('existing content'), findsOneWidget);
      expect(find.byType(MkErrorState), findsOneWidget);
      expect(find.byType(SliverLoadMore), findsNothing);

      await tester.tap(find.text('刷新'));
      expect(retryCount, 1);
    },
  );

  testWidgets('pagination waits for a user scroll before loading', (
    tester,
  ) async {
    var loadCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MkRefreshLoadList<String>(
            onLoad: () async => loadCount++,
            onRefresh: () async {},
            hasMore: true,
            empty: false,
            slivers: const [SliverToBoxAdapter(child: SizedBox(height: 1200))],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(loadCount, 0);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -1000));
    await tester.pumpAndSettle();

    expect(loadCount, 1);
  });

  testWidgets('short lists provide a manual load-more action', (tester) async {
    var loadCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh', 'CN'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: Scaffold(
          body: MkRefreshLoadList<String>(
            onLoad: () async => loadCount++,
            onRefresh: () async {},
            hasMore: true,
            empty: false,
            slivers: const [SliverToBoxAdapter(child: SizedBox(height: 20))],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('查看更多'));
    await tester.pumpAndSettle();

    expect(loadCount, 1);
  });
}

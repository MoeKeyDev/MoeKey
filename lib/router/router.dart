import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/logger.dart';
import 'package:moekey/pages/hashtag/hashtag_page.dart';
import 'package:moekey/pages/login/login_page.dart';
import 'package:moekey/pages/notes/note_page.dart';
import 'package:moekey/pages/notifications/notifications_page.dart';
import 'package:moekey/pages/users/user_page.dart';
import 'package:moekey/status/mk_tabbar_refresh_scroll_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';
import '../pages/announcements/announcements.dart';
import '../pages/clips/clips_notes.dart';
import '../pages/clips/clips_page.dart';
import '../pages/drive/drive_page.dart';
import '../pages/explore/explore.dart';
import '../pages/home/home_page.dart';
import '../pages/image_preview/image_preview.dart';
import '../pages/search/search_page.dart';
import '../pages/settings/router.dart';
import '../pages/splash_page/splash_page.dart';
import '../pages/timeline/timeline_page.dart';
import '../pages/users/user_follow.dart';

part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(initialLocation: '/SplashPage', routes: [
    GoRoute(path: "/", redirect: (_, __) => "/timeline"),
    GoRoute(
      name: 'splash',
      path: '/SplashPage',
      builder: (_, __) => const SplashPage(),
    ),
    ShellRoute(
      builder: (context, status, child) => PopScope(
          canPop: GoRouter.of(context).state.name == "timeline",
          onPopInvokedWithResult: (bool didPop, Object? result) async {
            if (didPop) {
              return;
            }
            logger.d(GoRouter.of(context).state.name);
            // if (status.name != "timeline") {
            context.goNamed('timeline');
            // }
          },
          child: HomePage(
            child: child,
          )),
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, status, child) => child,
          branches: [
            StatefulShellBranch(routes: [
              GoRoute(
                name: "timeline",
                path: "/timeline",
                builder: (_, __) => Consumer(builder: (context, ref, _) {
                  var key =
                      ref.read(mkTabBarRefreshScrollStatusProvider("timeline"));
                  return TimelinePage(
                    mkTabBarListKey: key,
                  );
                }),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                name: "notifications",
                path: "/notifications",
                builder: (_, __) => Consumer(builder: (context, ref, _) {
                  var key = ref.read(
                      mkTabBarRefreshScrollStatusProvider("notifications"));
                  return NotificationsPage(
                    mkTabBarListKey: key,
                  );
                }),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                name: "clips",
                path: "/clips",
                builder: (_, __) => const ClipsPage(),
                routes: [
                  GoRoute(
                    path: ":id",
                    builder: (_, status) {
                      return ClipsNotes(status.pathParameters['id']!);
                    },
                  ),
                ],
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                name: "drives",
                path: "/drives",
                builder: (_, __) => const DrivePage(),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                name: "explore",
                path: "/explore",
                builder: (_, __) => const ExplorePage(),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                name: "announcements",
                path: "/announcements",
                builder: (_, __) => const AnnouncementsPage(),
              ),
            ]),
            StatefulShellBranch(routes: [
              GoRoute(
                name: "search",
                path: "/search",
                builder: (_, __) => const SearchPage(),
              )
            ]),
            StatefulShellBranch(
              routes: [settingsRouter],
            ),
          ],
        ),
        GoRoute(
          path: "/notes/:id",
          builder: (_, status) => NotesPage(
            noteId: status.pathParameters['id']!,
            previewNote: status.extra as NoteModel?,
          ),
        ),
        GoRoute(
            path: "/user/:id",
            builder: (_, status) => UserPage(
                  userId: status.pathParameters['id']!,
                ),
            routes: [
              GoRoute(
                path: 'following',
                builder: (_, status) => UserFollowPage(
                  userId: status.pathParameters['id']!,
                  type: 'following',
                ),
              ),
              GoRoute(
                path: 'followers',
                builder: (_, status) => UserFollowPage(
                  userId: status.pathParameters['id']!,
                  type: 'followers',
                ),
              ),
            ]),
        GoRoute(
          path: "/user/null/:username",
          builder: (_, status) => UserPage(
            host: null,
            username: status.pathParameters['username']!,
          ),
        ),
        GoRoute(
          path: "/user/:host/:username",
          builder: (_, status) => UserPage(
            host: status.pathParameters['host']!,
            username: status.pathParameters['username']!,
          ),
        ),
        GoRoute(
          path: "/tags/:name",
          builder: (_, status) => HashtagPage(
            name: status.pathParameters['name']!,
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/image-preview',
      pageBuilder: (_, status) {
        var params = status.extra as Map<String, dynamic>;
        return CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          opaque: false,
          child: ImagePreviewPage(
            initialIndex: params['initialIndex'],
            galleryItems: params['galleryItems'],
            heroKeys: params['heroKeys'],
            backgroundDecoration: null,
          ),
        );
      },
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (_, __) => const LoginPage(),
      routes: [],
    ),
    GoRoute(
      name: 'logout',
      path: '/logout',
      builder: (_, __) => const LogoutPage(),
      routes: [],
    )
  ]);
}

extension NavigatorExt on BuildContext {
  /// Performs a [GoRouter.of(context).pushNamedAndRemoveUntil] action with given [routeName]
  Future<dynamic> pushNamedAndRemoveUntil(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) async {
    while (canPop()) {
      pop();
    }
    pushReplacementNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }
}

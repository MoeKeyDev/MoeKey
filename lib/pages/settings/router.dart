import 'package:go_router/go_router.dart';
import 'package:moekey/pages/settings/account_manager/account_manager_page.dart';
import 'package:moekey/pages/settings/profile/profile.dart';
import 'package:moekey/pages/settings/settings_page.dart';
import 'package:moekey/pages/settings/two_panel_layout.dart';

var settingsRouter = ShellRoute(
  builder: (context, status, child) => SettingsTwoPanelLayout(
    leftPanel: SettingBodyWide(),
    rightPanel: child,
  ),
  routes: [
    GoRoute(
      name: "settings",
      path: "/settings",
      builder: (_, __) => const SettingBodyNarrow(),
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, status, child) => child,
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: 'account_manager',
                  name: "settingsAccountManager",
                  builder: (_, __) {
                    return AccountManagerPage();
                  },
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: 'profile',
                  name: "settingProfile",
                  builder: (_, __) {
                    return SettingsProfile();
                  },
                ),
              ],
            ),
          ],
        )
      ],
    )
  ],
);

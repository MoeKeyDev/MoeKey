import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../widgets/mk_tabbar_list.dart';

part 'mk_tabbar_refresh_scroll_state.g.dart';

@Riverpod(keepAlive: true)
GlobalKey<MkTabBarRefreshScrollState> mkTabBarRefreshScrollStatus(
    Ref ref, String label) {
  return GlobalKey<MkTabBarRefreshScrollState>(debugLabel: label);
}

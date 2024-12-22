import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../widgets/mk_refresh_load.dart';

MkRefreshLoadListController useMkRefreshLoadListController() {
  return use(_MkRefreshLoadListControllerHook());
}

class _MkRefreshLoadListControllerHook
    extends Hook<MkRefreshLoadListController> {
  @override
  HookState<MkRefreshLoadListController, Hook<MkRefreshLoadListController>>
      createState() {
    return _MkRefreshLoadListControllerHookState();
  }
}

class _MkRefreshLoadListControllerHookState extends HookState<
    MkRefreshLoadListController, _MkRefreshLoadListControllerHook> {
  late final controller = MkRefreshLoadListController();

  @override
  MkRefreshLoadListController build(BuildContext context) {
    return controller;
  }

  @override
  void dispose() {
    controller.dispose();
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_snackbar.g.dart';

@riverpod
class GlobalSnackbar extends _$GlobalSnackbar {
  @override
  String? build() {
    return null;
  }

  show(String message) {
    state = message;
    // 触发监听器
    ref.notifyListeners();
  }

  hide() {
    state = null;
    ref.notifyListeners();
  }
}

import 'dart:collection';

import 'package:moekey/apis/models/drive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'driver_select_dialog_state.g.dart';

@Riverpod(keepAlive: true)
class DriverSelectDialogState extends _$DriverSelectDialogState {
  @override
  LinkedHashMap build(String id) {
    return LinkedHashMap<String, DriveModel>();
  }

  add(String id, DriveModel data) {
    state[id] = data;
    ref.notifyListeners();
  }

  remove(String id) {
    if (state[id] != null) {
      state.remove(id);
      ref.notifyListeners();
    }
  }

  clear() {
    state.clear();
    ref.notifyListeners();
  }
}

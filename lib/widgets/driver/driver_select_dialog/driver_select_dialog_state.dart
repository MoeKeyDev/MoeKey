import 'dart:collection';

import 'package:moekey/apis/models/drive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'driver_select_dialog_state.g.dart';

@Riverpod(keepAlive: true)
class DriverSelectDialogState extends _$DriverSelectDialogState {
  @override
  LinkedHashMap build() {
    return LinkedHashMap<String, DriveFileModel>();
  }

  add(String id, DriveFileModel data) {
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

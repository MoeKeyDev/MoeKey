import 'dart:async';

import 'package:moekey/status/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../apis/models/user_full.dart';
import '../../status/server.dart';
import '../../status/user.dart';

part 'user_select_dialog_state.g.dart';

@riverpod
class UserSelectDialogState extends _$UserSelectDialogState {
  String name = "";
  String host = "";
  Timer? timer;

  @override
  FutureOr<List<UserFullModel>> build() async {
    return loadFollowing();
  }

  FutureOr<List<UserFullModel>> loadFollowing() async {
    var user = await ref.read(currentLoginUserProvider.future);
    var userList = await ref.read(userFollowingProvider(user?.id ?? "").future);
    var list = <UserFullModel>[];
    for (var item in userList) {
      if (item.followee != null) {
        list.add(item.followee!);
      }
    }
    return list;
  }

  search({String? name, String? host}) {
    // 防抖
    timer?.cancel();
    state = const AsyncLoading();
    timer = Timer(const Duration(seconds: 1), () {
      _search(name: name, host: host);
    });
  }

  _search({String? name, String? host}) async {
    if (name != null) {
      this.name = name;
    }
    if (host != null) {
      this.host = host;
    }

    if (this.host != "" || this.name != "") {
      var http = await ref.read(httpProvider.future);
      var user = await ref.read(currentLoginUserProvider.future);
      var data =
          await http.post<List>("/users/search-by-username-and-host", data: {
        "username": this.name,
        "host": this.host,
        "limit": 30,
        "detail": true,
        "i": user!.token
      });

      state = AsyncData(List<UserFullModel>.from(
          data.data!.map((e) => UserFullModel.fromMap(e))));
    } else {
      var data = await loadFollowing();
      state = AsyncData(data);
    }
  }
}

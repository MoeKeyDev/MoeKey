import 'package:moekey/models/clips.dart';
import 'package:moekey/networks/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../state/server.dart';

part 'clips.g.dart';

@riverpod
class Clips extends _$Clips {
  @override
  FutureOr<List<ClipsModel>> build() async {
    return clipsList();
  }

  Future<List<ClipsModel>> clipsList(
      {num? limit = 10, bool? allowPartial = true}) async {
    try {
      // 获取httpProvider和currentLoginUserProvider的实例
      var http = await ref.watch(httpProvider.future);
      var user = await ref.watch(currentLoginUserProvider.future);
      // 发送post请求，获取数据
      var res = await http.post("/clips/list", data: {
        "allowPartial": allowPartial,
        "i": user?.token,
        "limit": limit,
      });

      // 将数据转换为ClipsModel列表
      List<ClipsModel> list = [];
      for (var item in res.data) {
        var data = ClipsModel.fromMap(item);
        list.add(data);
      }
      // 将list反序排列
      list = list.reversed.toList();
      
      return list;
    } finally {
      // 设置加载状态为false
      loading = false;
    }
  }

  var loading = false;

  load() async {
    if (loading) return;
    loading = true;
    try {
      state = AsyncData((state.valueOrNull ?? []) + await clipsList());
    } finally {
      loading = false;
    }
  }
}

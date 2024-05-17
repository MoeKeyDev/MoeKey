import 'package:moekey/status/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'servers_select_state.g.dart';

@riverpod
class InstanceListState extends _$InstanceListState {
  @override
  FutureOr<List<dynamic>> build() async {
    var http = await ref.watch(httpProvider.future);
    var response =
        await http.get("https://instanceapp.misskey.page/instances.json");
    return response.data['instancesInfos'];
  }
}

List instanceListFilter(List list, String filter) {
  var res = [];
  for (var element in list) {
    if (element["url"].toString().contains(filter) ||
        element["name"].toString().contains(filter)) {
      res.add(element);
    }
  }
  return res;
}

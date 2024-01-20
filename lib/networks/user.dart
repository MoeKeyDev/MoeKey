import 'package:misskey/models/user_full.dart';
import 'package:misskey/networks/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../state/server.dart';

part 'user.g.dart';

@riverpod
class UserFollowing extends _$UserFollowing {
  @override
  FutureOr<List> build(String userId) async {
    return load();
  }

  // users/following

  Future<List> load() async {
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);
    var res = await http.post("/users/following", data: {
      "userId": userId,
      "limit": 50,
      "i": user!.token,
    });
    return res.data;
  }
}

@riverpod
Future<UserFullModel> userInfo(UserInfoRef ref,
    {required String userId}) async {
  var http = await ref.read(httpProvider.future);
  var user = await ref.read(currentLoginUserProvider.future);
  var res = await http
      .post("/users/show", data: {"userId": userId, "i": user?.token});
  return UserFullModel.fromMap(res.data);
}

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../apis/models/me_detailed.dart';
import '../../status/me_detailed.dart';
import '../../status/misskey_api.dart';

part 'member_info_state.g.dart';

class MemberInfoStateModel {
  MeDetailed originalUser;
  MeDetailed user;

  MemberInfoStateModel(this.originalUser, this.user);
}

@riverpod
class MemberInfoState extends _$MemberInfoState {
  @override
  FutureOr<MemberInfoStateModel> build() async {
    var meDetail = await ref.watch(currentMeDetailedProvider.future);
    return MemberInfoStateModel(meDetail!, meDetail);
  }

  void setBanner(String id) {
    updateUser(state.value!.user.copyWith(bannerId: id));
    updateApi({
      "bannerId": id,
    });
  }

  void setAvatar(String id) {
    updateUser(state.value!.user.copyWith(avatarId: id));
    updateApi({
      "avatarId": id,
    });
  }

  void updateUser(MeDetailed user) {
    // 加入一个延迟，避免在更新时直接使用state.value
    // 导致状态不一致的问题
    Future(() {
      state = AsyncData(MemberInfoStateModel(state.value!.originalUser, user));
    });
  }

  Future<void> updateApi(Map<String, dynamic> data) async {
    var api = ref.watch(misskeyApisProvider);
    // 如果字段的value是空字符串，则设置为null
    data.forEach((key, value) {
      if (value == "") {
        data[key] = null;
      }
    });
    var res = await api.account.update(data: data);
    state = AsyncData(MemberInfoStateModel(res, res));
  }
}

import 'package:moekey/apis/models/user_lite.dart';
import 'package:moekey/apis/services/services.dart';

class AccountService extends MisskeyApiServices {
  AccountService({required super.client});

  Future<UserLiteModel?> i() async {
    var data = await client.post("/i");
    if (data != null) {
      return UserLiteModel.fromMap(data);
    }
    return null;
  }
}

import 'package:moekey/apis/services/services.dart';

class HashtagsService extends MisskeyApiServices {
  HashtagsService({required super.client});

  search({String? query}) async {
    var list = await client
        .post<List>("/hashtags/search", data: {"query": query, "limit": 30});
    return List<String>.from(list.map(
      (e) => e,
    ));
  }
}

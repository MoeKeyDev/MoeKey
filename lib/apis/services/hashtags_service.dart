import 'package:moekey/apis/models/hashtag_trend.dart';
import 'package:moekey/apis/services/services.dart';

class HashtagsService extends MisskeyApiServices {
  HashtagsService({required super.client});

  Future<List<String>> search({String? query}) async {
    var list = await client.post<List>(
      "/hashtags/search",
      data: {"query": query, "limit": 30},
    );
    return List<String>.from(list.map((e) => e));
  }

  Future<List<HashtagTrendModel>> trend() async {
    var list = await client.post<List>("/hashtags/trend", auth: false);
    return [
      for (final item in list)
        HashtagTrendModel.fromJson(Map<String, dynamic>.from(item as Map)),
    ];
  }
}

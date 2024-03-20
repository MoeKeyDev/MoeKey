import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:moekey/networks/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../state/server.dart';
import '../state/themes.dart';

part 'apis.g.dart';

@Riverpod(keepAlive: true)
Future<Map> apiMeta(ApiMetaRef ref) async {
  var http = await ref.watch(httpProvider.future);
  var data = await http.post("/meta", data: {
    "detail": true,
  });
  return data.data;
}

@Riverpod(keepAlive: true)
class ServerInfoState extends _$ServerInfoState {
  @override
  FutureOr<Map> build() async {
    var colors = ref.read(themeColorsProvider.notifier);
    var meta = await ref.watch(apiMetaProvider.future);
    colors.updateThemes(meta);
    return meta;
  }
}

@Riverpod(keepAlive: true)
Future<List> apiEmojisList(ApiEmojisListRef ref) async {
  var http = await ref.watch(httpProvider.future);
  var data = await http.get("/emojis");
  return data.data["emojis"];
}

@Riverpod(keepAlive: true)
Future<Map> apiEmojisByCategory(ApiEmojisByCategoryRef ref) async {
  var data = await ref.watch(apiEmojisListProvider.future);
  LinkedHashMap<String, List> emojiMap = LinkedHashMap();
  var user = [
    ["👍", "good"],
    ["❤️", "heart"],
    ["😆", "laughing"],
    ["🤔", "thinking"],
    ["😮", "open_mouth"],
    ["🎉", "tada"],
    ["💢", "anger"],
    ["😥", "disappointed_relieved"],
    ["😇", "innocent"],
    ["🍮", "custard"],
  ];
  for (var item in user) {
    var cate = "用户";
    if (emojiMap[cate] == null) {
      emojiMap[cate] = [];
    }
    emojiMap[cate]!.add({"emoji": item[0], "name": item[1]});
  }

  for (var item in data) {
    var cate = item["category"] ?? "未分类";
    if (emojiMap[cate] == null) {
      emojiMap[cate] = [];
    }
    emojiMap[cate]!.add(item);
  }
  var emojiListJson = await rootBundle.loadString("assets/emoji_list.json");
  var emojiList = jsonDecode(emojiListJson);

  ///{
  //     "aliases": [],
  //     "name": "anenw01",
  //     "category": "AmashiroNatsukiEars",
  //     "url": "https://ca.nfs.pub/nyaone/1fa90197-dd0f-4488-abe0-1db01d9e243c.png"
  // }
  var names = [
    "face",
    "people",
    "animals_and_nature",
    "food_and_drink",
    "activity",
    "travel_and_places",
    "objects",
    "symbols",
    "flags"
  ];

  for (var item in emojiList) {
    var cate = names[item[2]];
    if (emojiMap[cate] == null) {
      emojiMap[cate] = [];
    }
    emojiMap[cate]!.add({"emoji": item[0], "name": item[1]});
  }
  return emojiMap;
}

@Riverpod(keepAlive: true)
Future<Map> apiEmojis(ApiEmojisRef ref) async {
  var data = await ref.watch(apiEmojisListProvider.future);
  Map emojiMap = {};
  for (var item in data) {
    emojiMap[item["name"]] = item;
  }
  return emojiMap;
}

@Riverpod(keepAlive: true)
Future<dynamic> getUriInfo(GetUriInfoRef ref, String url) async {
  String myLocale = Platform.localeName;

  var user = await ref.watch(currentLoginUserProvider.future);
  var host = user?.serverUrl;
  var http = await ref.watch(httpProvider.future);
  // http.
  var res = await http.get("$host/url", queryParameters: {
    "url": url,
    "lang": myLocale,
  });

  return res.data;
}

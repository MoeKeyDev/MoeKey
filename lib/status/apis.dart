import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:moekey/apis/models/meta.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/generated/l10n.dart';
import 'package:moekey/status/server.dart';
import 'package:moekey/status/themes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/emojis.dart';
import '../database/instance.dart';
import '../database/link_preview.dart';
import '../logger.dart';
import 'misskey_api.dart';

part 'apis.g.dart';

@Riverpod(keepAlive: true)
Future<InstanceDatabase> instanceDatabase(Ref ref) async {
  var user = ref.watch(currentLoginUserProvider);
  var instance = user?.serverUrl;
  return InstanceDatabase(server: instance ?? "default");
}

@Riverpod(keepAlive: true)
Future<MetaDetailedModel?> instanceMeta(Ref ref) async {
  var apis = ref.watch(misskeyApisProvider);

  var colors = ref.read(themeColorsProvider.notifier);

  var instance = await ref.watch(instanceDatabaseProvider.future);
  // 优先从数据库中读取
  var meta = await instance.getMeta();
  if (meta == null) {
    meta = await apis.meta.meta();
    await instance.setMeta(meta!);
  }
  var brightness = ref.watch(systemBrightnessProvider);

  colors.updateThemes(meta, brightness);
  return meta;
}

@Riverpod(keepAlive: true)
Future<List<EmojiSimple>> apiEmojisList(Ref ref) async {
  try {
    var apis = ref.watch(misskeyApisProvider);

    var instance = await ref.watch(instanceDatabaseProvider.future);

    // 优先从数据库中读取
    var emojis = await instance.getEmojis();

    if (emojis == null) {
      emojis = await apis.meta.emojis();
      await instance.setEmojis(emojis);
    } else {
      // 更新
      Future.delayed(Duration.zero, () async {
        var emojis = await apis.meta.emojis();
        await instance.setEmojis(emojis);
        ref.notifyListeners();
      });
    }

    return emojis;
  } catch (e, t) {
    logger.e(e);
    logger.e(t);
  }
  return [];
}

@Riverpod(keepAlive: true)
Future<Map<String, List<EmojiSimple>>> apiEmojisByCategory(Ref ref) async {
  var data = await ref.watch(apiEmojisListProvider.future);
  LinkedHashMap<String, List<EmojiSimple>> emojiMap = LinkedHashMap();
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
    var cate = S.current.user;
    if (emojiMap[cate] == null) {
      emojiMap[cate] = [];
    }
    emojiMap[cate]!.add(EmojiSimple(
        aliases: [], category: cate, name: item[1], url: item[0], code: true));
  }

  for (var item in data) {
    var cate = item.category ?? S.current.uncategorized;
    if (emojiMap[cate] == null) {
      emojiMap[cate] = [];
    }
    emojiMap[cate]!.add(item);
  }
  var emojiListJson = await rootBundle.loadString("assets/emoji_list.json");
  var emojiList = jsonDecode(emojiListJson);

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
    emojiMap[cate]!.add(EmojiSimple(
        aliases: [],
        category: S.current.user,
        name: item[1],
        url: item[0],
        code: true));
  }
  return emojiMap;
}

@Riverpod(keepAlive: true)
Future<Map<String, EmojiSimple>> apiEmojis(Ref ref) async {
  var data = await ref.watch(apiEmojisListProvider.future);
  Map<String, EmojiSimple> emojiMap = {};
  for (var item in data) {
    emojiMap[item.name] = item;
  }
  return emojiMap;
}

@Riverpod(keepAlive: true)
Future<LinkPreviewDatabase> linkPreview(Ref ref) async {
  return LinkPreviewDatabase();
}

@riverpod
Future<LinkPreview?> getUriInfo(Ref ref, String url) async {
  var apis = ref.watch(misskeyApisProvider);
  var db = await ref.watch(linkPreviewProvider.future);
  var item = await db.get(url);
  if (item == null) {
    item = await apis.notes.linkPreview(url: url);
    await db.put(url, item!);
  }
  return item;
}

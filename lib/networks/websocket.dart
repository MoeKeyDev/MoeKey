import 'dart:async';
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../main.dart';
import '../state/server.dart';

part 'websocket.g.dart';

@Riverpod(keepAlive: true)
class MisskeyWebSocket extends _$MisskeyWebSocket {
  @override
  FutureOr<WebSocketChannel> build() async {
    var user = await ref.watch(currentLoginUserProvider.future);
    var host = user!.serverUrl;
    var scheme = "wss";
    if (Uri.parse(host).scheme == "http") {
      scheme = "ws";
    }
    logger.d("==============hosts=============");
    logger.d(host);
    var uri = Uri.parse(host);
    logger.d(uri.port);
    logger.d(uri.host);
    uri = Uri.parse(
        "$scheme://${uri.host}:${uri.port}/streaming?i=${user?.token ?? ""}");
    var channel = WebSocketChannel.connect(uri);
    ref.onDispose(() {
      channel.sink.close();
    });
    await channel.ready;
    return channel;
  }
}

class MisskeyEvent {
  late Map data;
  late MisskeyEventType type;

  MisskeyEvent({required this.data, required this.type});

  MisskeyEvent copyWith({
    Map? data,
    MisskeyEventType? type,
  }) {
    return MisskeyEvent(
      data: data ?? this.data,
      type: type ?? this.type,
    );
  }
}

enum MisskeyEventType {
  /// 数据事件
  data,

  /// 重置事件
  load;
}

StreamController<MisskeyEvent> misskeyStreamController =
    StreamController.broadcast();

@Riverpod(keepAlive: true)
class MisskeyGlobalEvent extends _$MisskeyGlobalEvent {
  @override
  FutureOr build() async {
    var channel = await ref.watch(misskeyWebSocketProvider.future);
    misskeyStreamController.sink.add(MisskeyEvent(
      type: MisskeyEventType.load,
      data: {},
    ));
    channel.stream.listen((data) {
      logger.d("=========emit MisskeyEvent=======");
      logger.d(data);
      var event = MisskeyEvent(
        type: MisskeyEventType.data,
        data: jsonDecode(data),
      );
      misskeyStreamController.sink.add(event);
    }, onDone: () {
      ref.invalidate(misskeyWebSocketProvider);
      misskeyStreamController.sink.add(MisskeyEvent(
        type: MisskeyEventType.load,
        data: {},
      ));
    }, onError: (error) {
      logger.d(error);
    });
  }

  send(Map data) async {
    try {
      var json = jsonEncode(data);
      var channel = await ref.read(misskeyWebSocketProvider.future);
      channel.sink.add(json);
    } catch (e) {
      logger.d(e);
      ref.invalidate(misskeyWebSocketProvider);
    }
  }
}

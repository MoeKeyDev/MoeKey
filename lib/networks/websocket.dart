import 'dart:async';
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../main.dart';
import '../state/server.dart';

part 'websocket.g.dart';

@Riverpod(keepAlive: true)
class moekeyWebSocket extends _$moekeyWebSocket {
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

class moekeyEvent {
  late Map data;
  late moekeyEventType type;

  moekeyEvent({required this.data, required this.type});

  moekeyEvent copyWith({
    Map? data,
    moekeyEventType? type,
  }) {
    return moekeyEvent(
      data: data ?? this.data,
      type: type ?? this.type,
    );
  }
}

enum moekeyEventType {
  /// 数据事件
  data,

  /// 重置事件
  load;
}

StreamController<moekeyEvent> moekeyStreamController =
    StreamController.broadcast();

@Riverpod(keepAlive: true)
class moekeyGlobalEvent extends _$moekeyGlobalEvent {
  @override
  FutureOr build() async {
    var channel = await ref.watch(moekeyWebSocketProvider.future);
    moekeyStreamController.sink.add(moekeyEvent(
      type: moekeyEventType.load,
      data: {},
    ));
    channel.stream.listen((data) {
      logger.d("=========emit moekeyEvent=======");
      logger.d(data);
      var event = moekeyEvent(
        type: moekeyEventType.data,
        data: jsonDecode(data),
      );
      moekeyStreamController.sink.add(event);
    }, onDone: () {
      ref.invalidate(moekeyWebSocketProvider);
      moekeyStreamController.sink.add(moekeyEvent(
        type: moekeyEventType.load,
        data: {},
      ));
    }, onError: (error) {
      logger.d(error);
    });
  }

  send(Map data) async {
    try {
      var json = jsonEncode(data);
      var channel = await ref.read(moekeyWebSocketProvider.future);
      channel.sink.add(json);
    } catch (e) {
      logger.d(e);
      ref.invalidate(moekeyWebSocketProvider);
    }
  }
}

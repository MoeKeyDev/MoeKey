import 'dart:async';
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../main.dart';
import '../state/server.dart';

part 'websocket.g.dart';

@Riverpod(keepAlive: true)
class MoekeyWebSocket extends _$MoekeyWebSocket {
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
        "$scheme://${uri.host}:${uri.port}/streaming?i=${user.token ?? ""}");
    var channel = WebSocketChannel.connect(uri);
    ref.onDispose(() {
      channel.sink.close();
    });
    await channel.ready;
    return channel;
  }
}

class MoekeyEvent {
  late Map data;
  late MoekeyEventType type;

  MoekeyEvent({required this.data, required this.type});

  MoekeyEvent copyWith({
    Map? data,
    MoekeyEventType? type,
  }) {
    return MoekeyEvent(
      data: data ?? this.data,
      type: type ?? this.type,
    );
  }
}

enum MoekeyEventType {
  /// 数据事件
  data,

  /// 重置事件
  load;
}

StreamController<MoekeyEvent> moekeyStreamController =
    StreamController.broadcast();

@Riverpod(keepAlive: true)
class MoekeyGlobalEvent extends _$MoekeyGlobalEvent {
  @override
  FutureOr build() async {
    var channel = await ref.watch(moekeyWebSocketProvider.future);
    var timer = Timer.periodic(const Duration(seconds: 60), (t) {
      sendString("h");

      // t.cancel(); //关闭定时器
    });
    moekeyStreamController.sink.add(MoekeyEvent(
      type: MoekeyEventType.load,
      data: {},
    ));
    channel.stream.listen(
      (data) {
        logger.d("=========emit moekeyEvent=======");
        logger.d(data);
        var event = MoekeyEvent(
          type: MoekeyEventType.data,
          data: jsonDecode(data),
        );
        moekeyStreamController.sink.add(event);
      },
      onDone: () {
        ref.invalidate(moekeyWebSocketProvider);
        moekeyStreamController.sink.add(MoekeyEvent(
          type: MoekeyEventType.load,
          data: {},
        ));
        if (timer.isActive) {
          timer.cancel();
        }
      },
      onError: (error) {
        logger.d(error);
        if (timer.isActive) {
          timer.cancel();
        }
      },
      cancelOnError: true,
    );
  }

  send(Map data) async {
    var json = jsonEncode(data);
    sendString(json);
  }

  sendString(String data) async {
    try {
      var channel = await ref.read(moekeyWebSocketProvider.future);
      channel.sink.add(data);
    } catch (e) {
      logger.d(e);
      ref.invalidate(moekeyWebSocketProvider);
    }
  }
}

StreamController<Map> moekeyStreamMainChannelController =
    StreamController.broadcast();

@Riverpod(keepAlive: true)
class MoekeyMainChannel extends _$MoekeyMainChannel {
  StreamSubscription<MoekeyEvent>? listen;

  @override
  FutureOr build() async {
    try {
      ref.onDispose(() {
        listen?.cancel();
        listen = null;
      });
      listen?.cancel();
      listen = null;
      listen = moekeyStreamController.stream.listen(
        (event) async {
          logger.d("========= event channel main===================");
          logger.d(event);
          if (event.type == MoekeyEventType.load) {
            logger.d("========= NotesListener load ===================");
            ref.read(moekeyGlobalEventProvider.notifier).send({
              "type": "connect",
              "body": {"channel": "main", "id": "1"}
            });
          }
          if (event.type == MoekeyEventType.data &&
              event.data["type"] == "channel" &&
              event.data["body"]["id"] == "1") {
            logger.d(event.data);
            moekeyStreamMainChannelController.sink.add(event.data["body"]);
          }
        },
      );
    } catch (e) {
      logger.d(e);
    }
  }
}

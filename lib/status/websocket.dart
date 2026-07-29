import 'dart:async';
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../logger.dart';
import 'server.dart';

part 'websocket.g.dart';

@Riverpod(keepAlive: true)
class MoekeyWebSocket extends _$MoekeyWebSocket {
  @override
  FutureOr<WebSocketChannel?> build() async {
    var user = ref.watch(currentLoginUserProvider);
    var host = user?.serverUrl;
    var scheme = "wss";
    if (host == null) {
      return null;
    }
    if (Uri.parse(host).scheme == "http") {
      scheme = "ws";
    }
    logger.d("==============hosts=============");
    logger.d(host);
    var uri = Uri.parse(host);
    logger.d(uri.port);
    logger.d(uri.host);
    uri = Uri.parse(
      "$scheme://${uri.host}:${uri.port}/streaming?i=${user?.token ?? ""}",
    );
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

  MoekeyEvent copyWith({Map? data, MoekeyEventType? type}) {
    return MoekeyEvent(data: data ?? this.data, type: type ?? this.type);
  }
}

enum MoekeyEventType {
  /// 数据事件
  data,

  /// 重置事件
  load,
}

StreamController<MoekeyEvent> moekeyStreamController =
    StreamController.broadcast();

@Riverpod(keepAlive: true)
class MoekeyGlobalEvent extends _$MoekeyGlobalEvent {
  Timer? _heartbeatTimer;
  StreamSubscription<dynamic>? _channelSubscription;
  Object? _activeConnectionGeneration;
  bool _reconnectScheduled = false;

  @override
  Future<void> build() async {
    final connectionGeneration = Object();
    _activeConnectionGeneration = connectionGeneration;
    ref.onDispose(() {
      if (identical(_activeConnectionGeneration, connectionGeneration)) {
        _activeConnectionGeneration = null;
      }
      _heartbeatTimer?.cancel();
      _heartbeatTimer = null;
      _channelSubscription?.cancel();
      _channelSubscription = null;
    });

    var channel = await ref.watch(moekeyWebSocketProvider.future);
    if (channel == null) return;

    _heartbeatTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      sendString("h");
    });
    moekeyStreamController.sink.add(
      MoekeyEvent(type: MoekeyEventType.load, data: {}),
    );
    _channelSubscription = channel.stream.listen(
      (data) {
        logger.d("=========emit moekeyEvent=======");
        logger.d(data);
        var event = MoekeyEvent(
          type: MoekeyEventType.data,
          data: jsonDecode(data),
        );
        moekeyStreamController.sink.add(event);
      },
      onDone: () => _handleDisconnect(connectionGeneration),
      onError: (error) {
        logger.d(error);
        _handleDisconnect(connectionGeneration);
      },
      cancelOnError: true,
    );
  }

  void _handleDisconnect(Object connectionGeneration) {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _scheduleReconnect(connectionGeneration);
  }

  void _scheduleReconnect([Object? connectionGeneration]) {
    if (_reconnectScheduled) return;
    _reconnectScheduled = true;
    scheduleMicrotask(() {
      _reconnectScheduled = false;
      if (!ref.mounted) return;
      if (connectionGeneration != null &&
          !identical(_activeConnectionGeneration, connectionGeneration)) {
        return;
      }
      ref.invalidate(moekeyWebSocketProvider);
    });
  }

  Future<void> send(Map data) async {
    var json = jsonEncode(data);
    sendString(json);
  }

  Future<void> sendString(String data) async {
    try {
      var channel = await ref.read(moekeyWebSocketProvider.future);
      channel?.sink.add(data);
    } catch (e) {
      logger.d(e);
      _scheduleReconnect();
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
      listen = moekeyStreamController.stream.listen((event) async {
        logger.d("========= event channel main===================");
        logger.d(event);
        if (event.type == MoekeyEventType.load) {
          logger.d("========= Main channel connected ===================");
          ref.read(moekeyGlobalEventProvider.notifier).send({
            "type": "connect",
            "body": {"channel": "main", "id": "1"},
          });
        }
        if (event.type == MoekeyEventType.data &&
            event.data["type"] == "channel" &&
            event.data["body"]["id"] == "1") {
          logger.d(event.data);
          moekeyStreamMainChannelController.sink.add(event.data["body"]);
        }
      });
    } catch (e) {
      logger.d(e);
    }
  }
}

import 'dart:async';
import 'package:moekey_video_pool/moekey_video_pool.dart';

class FakePlayback extends VideoPlayback {
  bool ready = false;
  bool active = false;
  bool ended = false;
  bool released = false;
  double rate = 1;
  Duration time = Duration.zero;
  Completer<void>? initialization;
  Completer<void>? disposal;
  final void Function()? onPlay;
  FakePlayback({this.onPlay});
  @override
  bool get initialized => ready;
  @override
  bool get playing => active;
  @override
  bool get completed => ended;
  @override
  double get speed => rate;
  @override
  Duration get position => time;
  @override
  Duration get duration => const Duration(seconds: 10);
  @override
  Future<void> initialize() async {
    await initialization?.future;
    ready = true;
    notifyListeners();
  }

  @override
  Future<void> play() async {
    active = true;
    onPlay?.call();
    notifyListeners();
  }

  @override
  Future<void> pause() async {
    active = false;
    notifyListeners();
  }

  @override
  Future<void> seek(Duration value) async {
    time = value;
    ended = false;
    notifyListeners();
  }

  @override
  Future<void> setSpeed(double value) async {
    rate = value;
    notifyListeners();
  }

  @override
  Future<void> setMuted(bool value) async {}
  @override
  Future<void> release() async {
    await disposal?.future;
    active = false;
    released = true;
    super.dispose();
  }

  void finish() {
    ended = true;
    active = false;
    notifyListeners();
  }
}

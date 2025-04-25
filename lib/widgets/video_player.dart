import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_player.g.dart';

@riverpod
VideoController videoPlayerState(VideoPlayerStateRef ref,
    {required String url, bool play = false}) {
  var player = Player();
  var controller = VideoController(player);
  player.open(Media(url), play: false);
  ref.onDispose(() {
    player.dispose();
  });
  return controller;
}

Future<void> enterNativeFullscreen() async {
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      await Future.wait(
        [
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.immersiveSticky,
            overlays: [],
          ),
          // SystemChrome.setPreferredOrientations(
          //   [
          //     DeviceOrientation.landscapeLeft,
          //     DeviceOrientation.landscapeRight,
          //   ],
          // ),
        ],
      );
    } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      await const MethodChannel('com.alexmercerind/media_kit_video')
          .invokeMethod(
        'Utils.EnterNativeFullscreen',
      );
    }
  } catch (exception, stacktrace) {
    debugPrint(exception.toString());
    debugPrint(stacktrace.toString());
  }
}

/// Makes the native window exit fullscreen.
Future<void> exitNativeFullscreen() async {
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      await Future.wait(
        [
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual,
            overlays: SystemUiOverlay.values,
          ),
          // SystemChrome.setPreferredOrientations(
          //   [],
          // ),
        ],
      );
    } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
      await const MethodChannel('com.alexmercerind/media_kit_video')
          .invokeMethod(
        'Utils.ExitNativeFullscreen',
      );
    }
  } catch (exception, stacktrace) {
    debugPrint(exception.toString());
    debugPrint(stacktrace.toString());
  }
}

class VideoPlayerComponent extends HookConsumerWidget {
  const VideoPlayerComponent({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = ref.watch(videoPlayerStateProvider(url: url));
    return Video(
      controller: controller,
      onEnterFullscreen: enterNativeFullscreen,
      onExitFullscreen: exitNativeFullscreen,
    );
  }
}

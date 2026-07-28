import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/widgets/video_player.dart';

void main() {
  test('macOS video configuration avoids the native hardware output path', () {
    final configuration = videoControllerConfiguration(isMacOS: true);

    expect(configuration.enableHardwareAcceleration, isFalse);
    expect(configuration.hwdec, 'no');
  });

  test('other platforms retain hardware acceleration defaults', () {
    final configuration = videoControllerConfiguration(isMacOS: false);

    expect(configuration.enableHardwareAcceleration, isTrue);
    expect(configuration.hwdec, isNull);
  });
}

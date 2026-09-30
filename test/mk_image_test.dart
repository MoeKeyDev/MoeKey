import 'package:extended_image/extended_image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/widgets/mk_image.dart';

void main() {
  const serverUrl = 'https://dvd.chat';
  const remoteEmojiUrl =
      'https://ovo.wxw.media/custom_emojis/images/000/037/479/original/emoji.png';

  test('leaves URLs unchanged when image proxying is disabled', () {
    expect(
      resolveMkImageUrl(remoteEmojiUrl, serverUrl: serverUrl),
      remoteEmojiUrl,
    );
  });

  test('proxies a remote emoji through the current instance', () {
    final url = Uri.parse(
      resolveMkImageUrl(
        remoteEmojiUrl,
        serverUrl: serverUrl,
        proxy: const MkImageProxyOptions(type: MkImageProxyType.emoji),
      ),
    );

    expect(url.origin, serverUrl);
    expect(url.path, '/proxy/image.webp');
    expect(url.queryParameters, {'url': remoteEmojiUrl, 'emoji': '1'});
  });

  test('does not proxy a URL from the current instance', () {
    const localUrl = 'https://dvd.chat/files/emoji.png';

    expect(
      resolveMkImageUrl(
        localUrl,
        serverUrl: serverUrl,
        proxy: const MkImageProxyOptions(type: MkImageProxyType.emoji),
      ),
      localUrl,
    );
  });

  test('post media proxy forwards original video without image flags', () {
    const video = 'https://video.twimg.com/path/video.mp4?token=a%2Bb';
    final resolved = Uri.parse(
      resolvePostMediaUrl(video, serverUrl: serverUrl),
    );
    expect(resolved.path, '/proxy/image.webp');
    expect(resolved.queryParameters, {'url': video});
  });

  test('preserves an existing external proxy and its host parameter', () {
    const proxied =
        'https://r.n1mp.org/image.webp?url=https%3A%2F%2Fvideo.twimg.com%2Fvideo.mp4&host=bird.makeup';
    expect(resolvePostMediaUrl(proxied, serverUrl: serverUrl), proxied);
  });

  test('local media and missing login retain original URL', () {
    const local = 'https://dvd.chat/files/video.mp4';
    expect(resolvePostMediaUrl(local, serverUrl: serverUrl), local);
    expect(resolvePostMediaUrl(remoteEmojiUrl), remoteEmojiUrl);
  });

  test('handles failed external image decoding without console spam', () {
    final resized = getExtendedResizeImage(remoteEmojiUrl);
    final network =
        (resized as ExtendedResizeImage).imageProvider
            as ExtendedNetworkImageProvider;

    expect(network.printError, isFalse);
  });
}

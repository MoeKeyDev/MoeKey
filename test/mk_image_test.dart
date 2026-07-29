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

  test('handles failed external image decoding without console spam', () {
    final resized = getExtendedResizeImage(remoteEmojiUrl);
    final network =
        (resized as ExtendedResizeImage).imageProvider
            as ExtendedNetworkImageProvider;

    expect(network.printError, isFalse);
  });
}

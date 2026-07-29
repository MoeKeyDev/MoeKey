import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moekey/widgets/hashtag/hashtag_select_dialog_state.dart';

void main() {
  test('disposing the hashtag search cancels its pending debounce', () async {
    final container = ProviderContainer();
    final subscription = container.listen(
      hashtagSelectDialogStateProvider,
      (_, _) {},
      fireImmediately: true,
    );

    await container.read(hashtagSelectDialogStateProvider.future);
    container
        .read(hashtagSelectDialogStateProvider.notifier)
        .search(query: 'flutter');

    subscription.close();
    await container.pump();
    await Future<void>.delayed(const Duration(milliseconds: 1100));

    container.dispose();
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:moekey/widgets/notes/note_children.dart';

void main() {
  test('reply placeholders follow the root reply count with a small cap', () {
    expect(replyPlaceholderCount(0), 0);
    expect(replyPlaceholderCount(1), 1);
    expect(replyPlaceholderCount(2), 2);
    expect(replyPlaceholderCount(30), 3);
  });

  test('pagination can keep one placeholder for a stale reply count', () {
    expect(replyPlaceholderCount(0, minimum: 1), 1);
    expect(replyPlaceholderCount(-1, minimum: 1), 1);
  });

  test('reply section is hidden when it has no rows or placeholders', () {
    expect(
      replyThreadHasVisibleContent(
        isInitialPending: true,
        entryCount: 0,
        initialPlaceholderCount: 0,
        hasInitialError: false,
        showPagination: false,
      ),
      isFalse,
    );
    expect(
      replyThreadHasVisibleContent(
        isInitialPending: false,
        entryCount: 0,
        initialPlaceholderCount: 0,
        hasInitialError: false,
        showPagination: false,
      ),
      isFalse,
    );
  });

  test('any reply section content keeps the separator visible', () {
    expect(
      replyThreadHasVisibleContent(
        isInitialPending: true,
        entryCount: 0,
        initialPlaceholderCount: 1,
        hasInitialError: false,
        showPagination: false,
      ),
      isTrue,
    );
    expect(
      replyThreadHasVisibleContent(
        isInitialPending: false,
        entryCount: 1,
        initialPlaceholderCount: 0,
        hasInitialError: false,
        showPagination: false,
      ),
      isTrue,
    );
  });
}

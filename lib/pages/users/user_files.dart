import '../../video/app_video_pool.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moekey/apis/models/drive.dart';
import 'package:moekey/apis/models/note.dart';
import 'package:moekey/status/misskey_api.dart';
import 'package:moekey/status/user.dart';
import 'package:moekey/widgets/loading_weight.dart';
import 'package:moekey/widgets/mk_refresh_load.dart';
import 'package:moekey/widgets/notes/note_image.dart';

final userRecentMediaFilesProvider = FutureProvider.autoDispose
    .family<List<UserMediaFile>, String>((ref, userId) async {
      final notes = await ref
          .watch(misskeyApisProvider)
          .user
          .notes(userId: userId, withFiles: true, limit: 10);
      return mediaFilesFromNotes(notes).take(8).toList();
    });

class UserMediaFile {
  const UserMediaFile({
    required this.noteId,
    required this.file,
    this.noteIndex = 0,
    this.attachmentIndex = 0,
  });

  final String noteId;
  final DriveFileModel file;
  final int noteIndex;
  final int attachmentIndex;
}

Iterable<UserMediaFile> mediaFilesFromNotes(Iterable<NoteModel> notes) {
  return notes.indexed.expand((entry) {
    final (noteIndex, note) = entry;
    return note.files.indexed
        .where(
          (file) =>
              file.$2.type.startsWith('image/') ||
              file.$2.type.startsWith('video/'),
        )
        .map(
          (file) => UserMediaFile(
            noteId: note.id,
            file: file.$2,
            noteIndex: noteIndex,
            attachmentIndex: file.$1,
          ),
        );
  });
}

class UserFilesPage extends HookConsumerWidget {
  const UserFilesPage({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = userNotesListProvider(
      userId: userId,
      withFiles: true,
      key: 2,
    );
    final state = ref.watch(provider);
    final files = mediaFilesFromNotes(state.value?.list ?? const []);
    final media = files.toList();

    return MkRefreshLoadList<UserMediaFile>(
      videoEnabled: true,
      padding: const EdgeInsets.all(16),
      onLoad: () => ref.read(provider.notifier).load(),
      onRefresh: () => ref.refresh(provider.future),
      hasMore: state.value?.hasMore ?? true,
      empty: media.isEmpty,
      loading: state.isLoading,
      initialLoading: state.isLoading && state.value == null,
      initialError: state.hasError && state.value == null ? state.error : null,
      onRetry: () => ref.invalidate(provider),
      loadMoreError: state.value?.loadMoreError,
      onRetryLoadMore: () => ref.read(provider.notifier).load(),
      slivers: [
        if (state.isLoading && media.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: LoadingCircularProgress(size: 28)),
          )
        else
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 190,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => UserMediaTile(media: media[index]),
              childCount: media.length,
            ),
          ),
      ],
    );
  }
}

class UserMediaTile extends StatelessWidget {
  const UserMediaTile({super.key, required this.media});

  final UserMediaFile media;

  @override
  Widget build(BuildContext context) {
    final identity = NoteVideoContext.of(context, media.noteId);
    final origin = NoteVideoContext(
      listKey: identity.listKey,
      noteId: media.noteId,
      listIndex: media.noteIndex,
    );
    return NoteImage(
      videoContext: origin,
      videoSubIndex: media.attachmentIndex,
      imageFile: media.file,
      heroKey: null,
      fit: BoxFit.cover,
      showHideButton: false,
      onClick: () => context.push(
        '/notes/${media.noteId}',
        extra: {'videoContext': origin},
      ),
    );
  }
}

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
  const UserMediaFile({required this.noteId, required this.file});

  final String noteId;
  final DriveFileModel file;
}

Iterable<UserMediaFile> mediaFilesFromNotes(Iterable<NoteModel> notes) {
  return notes.expand(
    (note) => note.files
        .where(
          (file) =>
              file.type.startsWith('image/') || file.type.startsWith('video/'),
        )
        .map((file) => UserMediaFile(noteId: note.id, file: file)),
  );
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
      padding: const EdgeInsets.all(16),
      onLoad: () => ref.read(provider.notifier).load(),
      onRefresh: () => ref.refresh(provider.future),
      hasMore: state.value?.hasMore ?? true,
      empty: !state.isLoading && media.isEmpty,
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
    return NoteImage(
      imageFile: media.file,
      heroKey: null,
      fit: BoxFit.cover,
      showHideButton: false,
      onClickForVideo: true,
      onClick: () => context.push('/notes/${media.noteId}'),
    );
  }
}

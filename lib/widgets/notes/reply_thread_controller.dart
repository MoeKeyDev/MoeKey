import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../apis/models/note.dart';

typedef ReplyChildrenLoader =
    Future<List<NoteModel>> Function(String noteId, int limit, String? untilId);

class ReplyThreadEntry {
  const ReplyThreadEntry({
    required this.note,
    required this.depth,
    required this.isFirstSibling,
    required this.isLastSibling,
    required this.hasVisibleChildren,
    required this.hasHiddenChildren,
    required this.isLoadingChildren,
    required this.childLoadError,
  });

  final NoteModel note;
  final int depth;
  final bool isFirstSibling;
  final bool isLastSibling;
  final bool hasVisibleChildren;
  final bool hasHiddenChildren;
  final bool isLoadingChildren;
  final Object? childLoadError;
}

class ReplyThreadController extends ChangeNotifier {
  ReplyThreadController({
    required this.rootNoteId,
    required this.loadChildren,
    required Stream<NoteModel> postedNotes,
    this.maxDepth = 5,
    this.rootLimit = 30,
    this.childLimit = 5,
  }) : assert(maxDepth > 0) {
    _postedSubscription = postedNotes.listen(_handlePostedNote);
  }

  final String rootNoteId;
  final ReplyChildrenLoader loadChildren;
  final int maxDepth;
  final int rootLimit;
  final int childLimit;
  late final StreamSubscription<NoteModel> _postedSubscription;

  final Map<String, List<NoteModel>> _childrenByParent = {};
  final Set<String> _loadedParents = {};
  final Set<String> _loadingParents = {};
  final Map<String, Object> _loadErrors = {};
  String? _rootUntilId;
  bool _hasMoreRootReplies = false;
  bool _isLoadingMoreRoot = false;
  Object? _rootPaginationError;
  bool _disposed = false;

  bool get isInitialLoading => _loadingParents.contains(rootNoteId);
  bool get isInitialLoaded => _loadedParents.contains(rootNoteId);
  Object? get initialLoadError => _loadErrors[rootNoteId];
  bool get hasMoreRootReplies => _hasMoreRootReplies;
  bool get isLoadingMoreRoot => _isLoadingMoreRoot;
  Object? get rootPaginationError => _rootPaginationError;

  List<ReplyThreadEntry> get entries {
    return entriesExcluding(const <String>{});
  }

  List<ReplyThreadEntry> entriesExcluding(Set<String> deletedNoteIds) {
    final result = <ReplyThreadEntry>[];
    _appendEntries(result, rootNoteId, 0, deletedNoteIds);
    return result;
  }

  Future<void> loadInitial() {
    return _loadRootPage(initial: true);
  }

  Future<void> retryInitial() => loadInitial();

  Future<void> loadMoreRoot() => _loadRootPage(initial: false);

  Future<void> retryChildren(ReplyThreadEntry entry) {
    return _loadBranch(
      entry.note.id,
      depth: entry.depth + 1,
      limit: childLimit,
    );
  }

  Future<void> _loadRootPage({required bool initial}) async {
    if (_disposed) return;
    if (initial) {
      if (_loadedParents.contains(rootNoteId) ||
          !_loadingParents.add(rootNoteId)) {
        return;
      }
      _loadErrors.remove(rootNoteId);
    } else {
      if (!_loadedParents.contains(rootNoteId) ||
          !_hasMoreRootReplies ||
          _isLoadingMoreRoot) {
        return;
      }
      _isLoadingMoreRoot = true;
      _rootPaginationError = null;
    }
    _notify();

    try {
      final fetched = await loadChildren(
        rootNoteId,
        rootLimit,
        initial ? null : _rootUntilId,
      );
      if (_disposed) return;

      final existing = _childrenByParent[rootNoteId] ?? const <NoteModel>[];
      _childrenByParent[rootNoteId] = initial
          ? mergeReplyNotes(fetched, existing)
          : appendReplyNotes(existing, fetched);
      if (fetched.isNotEmpty) _rootUntilId = fetched.last.id;
      _hasMoreRootReplies = fetched.length >= rootLimit;

      if (initial) {
        _loadedParents.add(rootNoteId);
        _loadingParents.remove(rootNoteId);
      } else {
        _isLoadingMoreRoot = false;
      }
      _notify();

      if (maxDepth <= 1) return;
      await Future.wait([
        for (final note in fetched)
          if (note.repliesCount > 0)
            _loadBranch(note.id, depth: 1, limit: childLimit),
      ]);
    } catch (error) {
      if (_disposed) return;
      if (initial) {
        _loadingParents.remove(rootNoteId);
        _loadErrors[rootNoteId] = error;
      } else {
        _isLoadingMoreRoot = false;
        _rootPaginationError = error;
      }
      _notify();
    }
  }

  Future<void> _loadBranch(
    String parentId, {
    required int depth,
    required int limit,
  }) async {
    if (_disposed ||
        depth >= maxDepth ||
        _loadedParents.contains(parentId) ||
        !_loadingParents.add(parentId)) {
      return;
    }
    _loadErrors.remove(parentId);
    _notify();

    try {
      final fetched = await loadChildren(parentId, limit, null);
      if (_disposed) return;
      _childrenByParent[parentId] = mergeReplyNotes(
        fetched,
        _childrenByParent[parentId] ?? const [],
      );
      _loadedParents.add(parentId);
      _loadingParents.remove(parentId);
      _notify();

      if (depth + 1 >= maxDepth) return;
      await Future.wait([
        for (final note in _childrenByParent[parentId]!)
          if (note.repliesCount > 0)
            _loadBranch(note.id, depth: depth + 1, limit: childLimit),
      ]);
    } catch (error) {
      if (_disposed) return;
      _loadingParents.remove(parentId);
      _loadErrors[parentId] = error;
      _notify();
    }
  }

  void _handlePostedNote(NoteModel note) {
    final parentId = note.replyId;
    if (_disposed || parentId == null || !_isKnownParent(parentId)) return;

    final existing = _childrenByParent[parentId] ?? const <NoteModel>[];
    _childrenByParent[parentId] = mergeReplyNotes(existing, [note]);
    _notify();
  }

  bool _isKnownParent(String noteId) {
    if (noteId == rootNoteId || _childrenByParent.containsKey(noteId)) {
      return true;
    }
    return _childrenByParent.values.any(
      (notes) => notes.any((note) => note.id == noteId),
    );
  }

  void _appendEntries(
    List<ReplyThreadEntry> result,
    String parentId,
    int depth,
    Set<String> deletedNoteIds,
  ) {
    if (depth >= maxDepth) return;
    final children = (_childrenByParent[parentId] ?? const <NoteModel>[])
        .where((note) => !deletedNoteIds.contains(note.id))
        .toList();
    for (var index = 0; index < children.length; index++) {
      final note = children[index];
      final visibleChildren =
          (_childrenByParent[note.id] ?? const <NoteModel>[])
              .where((child) => !deletedNoteIds.contains(child.id))
              .toList();
      result.add(
        ReplyThreadEntry(
          note: note,
          depth: depth,
          isFirstSibling: index == 0,
          isLastSibling: index == children.length - 1,
          hasVisibleChildren: visibleChildren.isNotEmpty,
          hasHiddenChildren: depth + 1 >= maxDepth && note.repliesCount > 0,
          isLoadingChildren: _loadingParents.contains(note.id),
          childLoadError: _loadErrors[note.id],
        ),
      );
      _appendEntries(result, note.id, depth + 1, deletedNoteIds);
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_postedSubscription.cancel());
    super.dispose();
  }
}

List<NoteModel> mergeReplyNotes(
  List<NoteModel> fetched,
  List<NoteModel> locallyPosted,
) {
  final ids = <String>{};
  return [
    for (final note in [...locallyPosted, ...fetched])
      if (ids.add(note.id)) note,
  ];
}

List<NoteModel> appendReplyNotes(
  List<NoteModel> existing,
  List<NoteModel> fetched,
) {
  final ids = existing.map((note) => note.id).toSet();
  return [
    ...existing,
    for (final note in fetched)
      if (ids.add(note.id)) note,
  ];
}

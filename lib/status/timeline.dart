import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:moekey/status/server.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../apis/models/note.dart';
import '../database/timeline.dart';
import '../logger.dart';
import 'misskey_api.dart';
import 'websocket.dart';

part 'timeline.g.dart';

@riverpod
Future<TimelineDatabase> timelineDatabase(Ref ref) async {
  var user = ref.watch(currentLoginUserProvider);
  var instance = user?.serverUrl;
  return TimelineDatabase(
    server: instance ?? "default",
    userId: user?.id ?? "default",
  );
}

@riverpod
class Timeline extends _$Timeline {
  bool _isLoadingMore = false;
  Future<void>? _refreshLatestOperation;
  Future<void>? _replaceLatestOperation;
  bool _streamActive = false;
  bool _streamConnected = false;
  Future<void> Function(int changeCount)? _beforeStreamPrepend;
  Future<void> _streamInsertQueue = Future.value();
  StreamSubscription<MoekeyEvent>? _streamSubscription;

  String get _streamId => 'timeline-$api';

  String get _streamChannel => switch (api) {
    'local-timeline' => 'localTimeline',
    'hybrid-timeline' => 'hybridTimeline',
    'global-timeline' => 'globalTimeline',
    _ => 'homeTimeline',
  };

  @override
  FutureOr<NoteListModel> build({String api = "timeline"}) async {
    final globalEventNotifier = ref.read(moekeyGlobalEventProvider.notifier);
    _streamSubscription = moekeyStreamController.stream.listen(
      _handleStreamEvent,
    );
    ref.onDispose(() {
      if (_streamConnected) {
        final streamId = _streamId;
        _streamConnected = false;
        // Riverpod forbids reading/modifying another provider directly from
        // an onDispose callback. Defer the socket command until this provider
        // lifecycle callback has completed.
        scheduleMicrotask(() {
          globalEventNotifier.send({
            'type': 'disconnect',
            'body': {'id': streamId},
          });
        });
      }
      _streamSubscription?.cancel();
      _streamSubscription = null;
    });

    TimelineCacheData? cache;
    TimelineDatabase? db;
    try {
      db = await ref.watch(timelineDatabaseProvider.future);
      cache = await db?.getTimeline(api);
    } catch (e) {
      logger.e(e);
      db?.cleanTimeline(api);
    }
    var model = NoteListModel();
    if (cache != null && cache.notes.isNotEmpty) {
      model.list = cache.notes;
    } else {
      var list = await timeline();
      model.list = list;
      model.isLatestLoaded = true;
      db?.setTimeline(api, list);
    }

    return model;
  }

  Future<List<NoteModel>> timeline({
    String? untilId,
    String? sinceId,
    int limit = 30,
  }) async {
    var apis = ref.read(misskeyApisProvider);
    var list = await apis.notes.timeline(
      limit: limit,
      untilId: untilId,
      api: api,
      sinceId: sinceId,
    );
    return list;
  }

  void setStreamActive(bool active) {
    _streamActive = active;
    if (active) {
      if (state.value?.isLatestLoaded == true) {
        _connectStream();
      }
    } else if (_streamConnected) {
      _sendStreamCommand('disconnect');
      _streamConnected = false;
    }
  }

  void setBeforeStreamPrepend(
    Future<void> Function(int changeCount)? callback,
  ) {
    _beforeStreamPrepend = callback;
  }

  void _handleStreamEvent(MoekeyEvent event) {
    if (event.type == MoekeyEventType.load) {
      _streamConnected = false;
      if (_streamActive) _connectStream();
      return;
    }
    if (!_streamActive || event.type != MoekeyEventType.data) return;

    final data = event.data;
    if (data['type'] != 'channel') return;
    final body = data['body'];
    if (body is! Map || body['id'] != _streamId || body['type'] != 'note') {
      return;
    }
    final noteJson = body['body'];
    if (noteJson is! Map) return;
    try {
      final note = NoteModel.fromJson(Map<String, dynamic>.from(noteJson));
      _streamInsertQueue = _streamInsertQueue
          .then((_) => _insertStreamNote(note))
          .catchError((Object error, StackTrace stackTrace) {
            logger.e(error);
            logger.e(stackTrace);
          });
    } catch (error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);
    }
  }

  void _connectStream() {
    if (!_streamActive || _streamConnected || !ref.mounted) return;
    _streamConnected = true;
    ref.read(moekeyGlobalEventProvider.notifier).send({
      'type': 'connect',
      'body': {
        'channel': _streamChannel,
        'id': _streamId,
        'params': <String, dynamic>{},
      },
    });
  }

  void _sendStreamCommand(String type) {
    if (!ref.mounted) return;
    ref.read(moekeyGlobalEventProvider.notifier).send({
      'type': type,
      'body': {'id': _streamId},
    });
  }

  Future<void> _insertStreamNote(NoteModel note) async {
    var model = state.value;
    if (model == null) return;
    if (model.list.any((item) => item.id == note.id)) {
      return;
    }
    await _beforeStreamPrepend?.call(1);
    if (!ref.mounted) return;

    // Re-read after awaiting the observer because another refresh may have
    // replaced the model while the visible anchor was being recorded.
    model = state.value;
    if (model == null || model.list.any((item) => item.id == note.id)) return;
    model.list = [note, ...model.list];
    state = AsyncData(model);
    ref.notifyListeners();
    unawaited(_saveCache(model));
    // Do not let the next streamed Note record an anchor before this prepend
    // has completed layout and scroll compensation.
    await SchedulerBinding.instance.endOfFrame;
  }

  Future<void> refreshLatest({
    Future<void> Function(int changeCount)? beforePrepend,
  }) {
    final activeOperation = _refreshLatestOperation;
    if (activeOperation != null) return activeOperation;

    final model = state.value;
    if (model == null || model.isLatestLoaded) {
      return Future.value();
    }

    final operation = _performRefreshLatest(
      model,
      beforePrepend: beforePrepend,
    );
    _refreshLatestOperation = operation;
    return operation.whenComplete(() {
      if (identical(_refreshLatestOperation, operation)) {
        _refreshLatestOperation = null;
      }
    });
  }

  Future<void> _performRefreshLatest(
    NoteListModel model, {
    Future<void> Function(int changeCount)? beforePrepend,
  }) async {
    state = AsyncData(model);
    ref.notifyListeners();
    try {
      final latest = await timeline();
      if (latest.isEmpty) {
        model.isLatestLoaded = true;
        return;
      }

      final current = model.list;
      final merged = _deduplicate([...latest, ...current]);
      final structureChanged = !_sameIds(current, merged);

      if (structureChanged) {
        final prependedEntryCount = merged.length - current.length;
        if (prependedEntryCount > 0) {
          await beforePrepend?.call(prependedEntryCount);
        }
      }
      // Even when ids are unchanged, prefer the freshly fetched Note objects
      // so edited text and server-side counters are refreshed.
      model.list = merged;
      model.isLatestLoaded = true;
      await _saveCache(model);
    } catch (error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);
      rethrow;
    } finally {
      state = AsyncData(model);
      ref.notifyListeners();
      if (_streamActive && model.isLatestLoaded) _connectStream();
    }
  }

  Future<void> replaceWithLatest() async {
    final activeReplacement = _replaceLatestOperation;
    if (activeReplacement != null) return activeReplacement;

    final operation = _performReplaceWithLatest();
    _replaceLatestOperation = operation;
    return operation.whenComplete(() {
      if (identical(_replaceLatestOperation, operation)) {
        _replaceLatestOperation = null;
      }
    });
  }

  Future<void> _performReplaceWithLatest() async {
    final automaticRefresh = _refreshLatestOperation;
    if (automaticRefresh != null) {
      try {
        await automaticRefresh;
      } catch (_) {
        // A manual refresh must still run even if the automatic top refresh
        // failed.
      }
    }

    if (_streamConnected) {
      _sendStreamCommand('disconnect');
      _streamConnected = false;
    }

    final currentModel = state.value;
    if (currentModel == null) return;
    var model = currentModel;
    state = AsyncData(model);
    ref.notifyListeners();
    try {
      final latest = await timeline();
      if (!ref.mounted) return;
      model = state.value ?? model;
      model.list = _deduplicate(latest);
      model.hasMore = latest.isNotEmpty;
      model.loadMoreError = null;
      model.isLatestLoaded = true;
      await _saveCache(model);
    } catch (error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);
      rethrow;
    } finally {
      if (ref.mounted) {
        state = AsyncData(model);
        ref.notifyListeners();
        if (_streamActive && model.isLatestLoaded) _connectStream();
      }
    }
  }

  List<NoteModel> _deduplicate(Iterable<NoteModel> notes) {
    final ids = <String>{};
    return [
      for (final note in notes)
        if (ids.add(note.id)) note,
    ];
  }

  bool _sameIds(List<NoteModel> left, List<NoteModel> right) {
    if (left.length != right.length) return false;
    for (var index = 0; index < left.length; index++) {
      if (left[index].id != right[index].id) return false;
    }
    return true;
  }

  Future<void> _saveCache(NoteListModel model) async {
    final db = await ref.read(timelineDatabaseProvider.future);
    final cachedNotes = model.list.take(200).toList();
    await db.setTimeline(api, cachedNotes);
  }

  Future<void> load() async {
    if (state.isLoading || _isLoadingMore) return;

    final model = state.value;
    if (model == null) return;

    _isLoadingMore = true;
    model.loadMoreError = null;
    ref.notifyListeners();
    try {
      String? untilId = model.list.lastOrNull?.id;

      List<NoteModel> notesList = await timeline(untilId: untilId);

      model.list += notesList;
      if (notesList.isEmpty) {
        model.hasMore = false;
      }
      await _saveCache(model);
    } catch (error, stackTrace) {
      logger.e(error);
      logger.e(stackTrace);
      model.loadMoreError = error;
    } finally {
      _isLoadingMore = false;
      state = AsyncData(model);
      ref.notifyListeners();
    }
  }

  Future<void> cleanCache() async {
    var db = await ref.read(timelineDatabaseProvider.future);
    await db.cleanTimeline(api);
  }
}

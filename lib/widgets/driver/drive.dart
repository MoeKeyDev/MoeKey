import "package:dio/dio.dart";
import "package:moekey/status/server.dart";
import "package:moekey/utils/image_compression.dart";
import "package:moekey/widgets/info_dialog.dart";
import "package:path/path.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../apis/models/drive.dart";
import "../../generated/l10n.dart";
import "../../main.dart";
import "../../status/misskey_api.dart";

part "drive.g.dart";

@riverpod
class DrivePath extends _$DrivePath {
  @override
  List<Map> build() {
    ref.watch(currentLoginUserProvider);
    return [
      {"name": S.current.drive, "id": null},
    ];
  }

  push({required String name, required String id}) {
    state.add({"name": name, "id": id});
    ref.notifyListeners();
  }

  backAt({required int index}) {
    state.removeRange(index + 1, state.length);
    ref.notifyListeners();
  }
}

@Riverpod(keepAlive: true)
class DriverUploader extends _$DriverUploader {
  @override
  List build() {
    return [];
  }

  Future<List> createFiles(
      {required List<String> filesPath, bool compression = true}) async {
    try {
      var apis = await ref.read(misskeyApisProvider.future);
      var path = ref.read(drivePathProvider);
      var loadingFile = [];
      for (var file in state) {
        if (!file["done"]) {
          loadingFile.add(file);
        }
      }
      for (var filePath in filesPath) {
        loadingFile.add({
          "progress": 0.0,
          "path": filePath,
          "done": false,
          "start": false,
          "data": {},
          "error": null
        });
      }
      state = loadingFile;
      ref.notifyListeners();

      var doneFiles = [];

      for (var (index, filePath) in state.indexed) {
        if (filePath["done"]) continue;
        if (filePath["start"]) continue;

        state[index]["start"] = true;
        ref.notifyListeners();

        var filename = basename(filePath["path"]);
        var ext = extension(filePath["path"]);
        FutureOr<MultipartFile> file =
            MultipartFile.fromFile(filePath["path"], filename: filename);

        // 仅仅压缩png jpg
        if ([".jpg", ".png", ".jpeg"].contains(ext.toLowerCase()) &&
            compression) {
          try {
            var imageFile = await imageCompression(filePath["path"]);
            file = MultipartFile.fromBytes(imageFile.rawBytes);
            filename = ext != "jpg" ? "$filename.jpg" : filename;
          } on Error catch (e) {
            logger.d(e);
            logger.d(e.stackTrace);
          }
        }

        try {
          String? folderId;
          if (path.lastOrNull?["id"] != null) {
            folderId = path.lastOrNull?["id"];
          }
          var data = await apis.drive.upload(
            filename: filename,
            file: await file,
            folderId: folderId,
            onSendProgress: (count, total) {
              state[index]["progress"] = count / total;
              ref.notifyListeners();
              logger.d("send: $count/$total");
            },
          );
          var notifier = ref.read(driveListProvider.notifier);
          notifier.addFile(data);
          doneFiles.add(data);
          state[index]["done"] = true;
          state[index]["data"] = data;

          ref.notifyListeners();
        } on DioException catch (e) {
          state[index]["done"] = true;
          state[index]["error"] = e;

          ref.notifyListeners();
          _showErrorDialog(e);
        }
      }

      return doneFiles;
    } on Error catch (e) {
      logger.d(e);
      logger.d(e.stackTrace);
    } on DioException catch (e) {
      logger.d(e);
      logger.d(e.response);
      logger.d(e.stackTrace);
    }
    return [];
  }

  void _showErrorDialog(DioException e) {
    InfoDialog.show(
        info: "上传失败\n ${e.response?.data.toString() ?? e.toString()}",
        isError: true);
  }

  Future createFolder(String name) async {
    var apis = await ref.read(misskeyApisProvider.future);
    var path = ref.read(drivePathProvider);
    String? parentId;
    if (path.lastOrNull?["id"] != null) {
      parentId = path.lastOrNull?["id"];
    }
    var data = await apis.drive.createFolder(name: name, parentId: parentId);

    var notifier = ref.read(driveListProvider.notifier);
    notifier.addFolder(data);
  }

  Future uploadFromUrl(String url) async {
    var path = ref.read(drivePathProvider);
    var apis = await ref.read(misskeyApisProvider.future);
    String? folderId;
    if (path.lastOrNull?["id"] != null) {
      folderId = path.lastOrNull?["id"];
    }
    apis.drive.uploadFromUrl(url: url, folderId: folderId);
  }

  Future updateFile({
    required String fileId,
    String? folderId,
    String? name,
    bool? isSensitive,
    String? comment,
  }) async {
    var apis = await ref.read(misskeyApisProvider.future);

    var res = await apis.drive.updateFile(
      fileId: fileId,
      folderId: folderId,
      comment: comment,
      isSensitive: isSensitive,
      name: name,
    );

    var notifier = ref.read(driveListProvider.notifier);
    notifier.updateFile(fileId, res);
  }

  Future updateFolders({
    required String folderId,
    String? name,
    String? parentId,
  }) async {
    var apis = await ref.read(misskeyApisProvider.future);
    var res = await apis.drive.updateFolders(
      folderId: folderId,
      name: name,
      parentId: parentId,
    );

    var notifier = ref.read(driveListProvider.notifier);
    notifier.updateFolder(folderId, res);
  }

  Future deleteFile(
    String fileId,
  ) async {
    var apis = await ref.read(misskeyApisProvider.future);
    await apis.drive.deleteFile(fileId: fileId);

    var notifier = ref.read(driveListProvider.notifier);
    notifier.deleteFile(fileId);
  }

  Future deleteFolder(
    String folderId,
  ) async {
    var apis = await ref.read(misskeyApisProvider.future);
    await apis.drive.deleteFolders(folderId: folderId);
    var notifier = ref.read(driveListProvider.notifier);
    notifier.deleteFolder(folderId);
  }
}

@riverpod
class DriveList extends _$DriveList {
  bool endFolder = false;

  @override
  FutureOr<List> build() async {
    var list = [];
    var res = await loadFolders();
    ref.listen(drivePathProvider, (previous, next) {
      state = const AsyncData([]);
    });
    for (var item in res) {
      list.add({"type": "folder", "data": item});
    }
    // 继续加载文件
    if (endFolder) {
      var res = await loadFiles();
      for (var item in res) {
        list.add({"type": "file", "data": item});
      }
    }

    return list;
  }

  loadMore() async {
    print("load");
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      var list = state.valueOrNull ?? [];
      if (endFolder == false) {
        // 继续加载文件夹
        var res = await loadFolders(untilId: list.lastOrNull["data"].id);
        for (var item in res) {
          list.add({"type": "folder", "data": item});
        }
      } else {
        // 加载文件
        var res = await loadFiles(untilId: list.lastOrNull["data"].id);
        for (var item in res) {
          list.add({"type": "file", "data": item});
        }
      }
      state = AsyncData(list);
    } on DioException catch (e) {
      state = AsyncError(e, e.stackTrace);
    }
  }

  Future<List<DriveFileModel>> loadFiles({String? untilId}) async {
    var path = ref.watch(drivePathProvider);

    var apis = await ref.watch(misskeyApisProvider.future);
    var res = await apis.drive.files(
      folderId: path.lastOrNull?["id"],
      untilId: untilId,
    );

    return res;
  }

  Future<List<DriverFolderModel>> loadFolders({String? untilId}) async {
    var path = ref.watch(drivePathProvider);
    var apis = await ref.watch(misskeyApisProvider.future);
    var res = await apis.drive.folders(
      folderId: path.lastOrNull?["id"],
      untilId: untilId,
    );

    if (res.length < 30) {
      endFolder = true;
    }
    return res;
  }

  addFile(dynamic data) {
    var list = state.valueOrNull ?? [];
    var fileIndex = -1;
    for (var (index, item) in list.indexed) {
      if (item["type"] == "file") {
        fileIndex = index;
        break;
      }
    }

    list.insert(fileIndex == -1 ? list.length : fileIndex,
        {"type": "file", "data": data});
    state = AsyncData(list);
  }

  addFolder(dynamic data) {
    var list = state.valueOrNull ?? [];
    list.insert(0, {"type": "folder", "data": data});
    state = AsyncData(list);
  }

  updateFile(String id, dynamic data) {
    var list = state.valueOrNull ?? [];
    for (var (index, item) in list.indexed) {
      if (item["type"] == "file" && item["data"].id == id) {
        list[index] = {"type": "file", "data": data};
        break;
      }
    }
    state = AsyncData(list);
  }

  updateFolder(String id, dynamic data) {
    var list = state.valueOrNull ?? [];
    for (var (index, item) in list.indexed) {
      if (item["type"] == "folder" && item["data"].id == id) {
        list[index] = {"type": "folder", "data": data};
        break;
      }
    }
    state = AsyncData(list);
  }

  void deleteFile(String fileId) {
    var list = state.valueOrNull ?? [];
    var fileIndex = 0;
    for (var (index, item) in list.indexed) {
      if (item["type"] == "file" && item["data"].id == fileId) {
        fileIndex = index;
        break;
      }
    }
    list.removeAt(fileIndex);
    state = AsyncData(list);
  }

  void deleteFolder(String folderId) {
    var list = state.valueOrNull ?? [];
    var fileIndex = 0;
    for (var (index, item) in list.indexed) {
      if (item["type"] == "folder" && item["data"].id == folderId) {
        fileIndex = index;
        break;
      }
    }
    list.removeAt(fileIndex);
    state = AsyncData(list);
  }
}

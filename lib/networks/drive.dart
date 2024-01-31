import "package:dio/dio.dart";
import "package:moekey/models/drive.dart";
import "package:moekey/networks/dio.dart";
import "package:moekey/state/server.dart";
import "package:moekey/utils/image_compression.dart";
import "package:moekey/widgets/info_dialog.dart";
import "package:path/path.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../generated/l10n.dart";
import "../main.dart";

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
      var http = await ref.read(httpProvider.future);
      var user = await ref.read(currentLoginUserProvider.future);
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
          var res = await http.post(
            "/drive/files/create",
            data: FormData.fromMap(
              {
                if (path.lastOrNull?["id"] != null)
                  "folderId": path.lastOrNull?["id"],
                "i": user!.token,
                "force": true,
                "name": filename,
                "file": await file
              },
            ),
            onSendProgress: (count, total) {
              state[index]["progress"] = count / total;
              ref.notifyListeners();
              logger.d("send: $count/$total");
            },
          );
          var data = res.data;
          var notifier = ref.read(driveListProvider.notifier);
          notifier.addFile(DriveFileModel.fromMap(data));
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
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);
    var path = ref.read(drivePathProvider);
    var res = await http.post("/drive/folders/create", data: {
      if (path.lastOrNull?["id"] != null) "parentId": path.lastOrNull?["id"],
      "i": user!.token,
      "name": name
    });

    var notifier = ref.read(driveListProvider.notifier);
    notifier.addFolder(DriverFolderModel.fromMap(res.data));
  }

  Future uploadFromUrl(String url) async {
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);
    var path = ref.read(drivePathProvider);
    http.post("/drive/files/upload-from-url", data: {
      if (path.lastOrNull?["id"] != null) "folderId": path.lastOrNull?["id"],
      "i": user!.token,
      "url": url
    });
  }

  Future updateFile({
    required String fileId,
    String? folderId,
    String? name,
    bool? isSensitive,
    String? comment,
  }) async {
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);
    var res = await http.post("/drive/files/update", data: {
      "i": user!.token,
      "fileId": fileId,
      if (folderId != null) "folderId": folderId,
      if (name != null) "name": name,
      if (isSensitive != null) "isSensitive": isSensitive,
      if (comment != null) "comment": comment,
    });

    var notifier = ref.read(driveListProvider.notifier);
    notifier.updateFile(fileId, DriveFileModel.fromMap(res.data));
  }

  Future updateFolders({
    required String folderId,
    String? name,
    String? parentId,
  }) async {
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);
    var res = await http.post("/drive/folders/update", data: {
      "i": user!.token,
      "folderId": folderId,
      if (name != null) "name": name,
      if (parentId != null) "parentId": parentId,
    });

    var notifier = ref.read(driveListProvider.notifier);
    notifier.updateFolder(folderId, DriverFolderModel.fromMap(res.data));
  }

  Future deleteFile(
    String fileId,
  ) async {
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);
    var res = await http.post("/drive/files/delete", data: {
      "i": user!.token,
      "fileId": fileId,
    });
    var notifier = ref.read(driveListProvider.notifier);
    notifier.deleteFile(fileId);
  }

  Future deleteFolder(
    String folderId,
  ) async {
    var http = await ref.read(httpProvider.future);
    var user = await ref.read(currentLoginUserProvider.future);
    var res = await http.post("/drive/folders/delete", data: {
      "i": user!.token,
      "folderId": folderId,
    });
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
      list.add({"type": "folder", "data": DriverFolderModel.fromMap(item)});
    }
    // 继续加载文件
    if (endFolder) {
      var res = await loadFiles();
      for (var item in res) {
        list.add({"type": "file", "data": DriveFileModel.fromMap(item)});
      }
    }

    return list;
  }

  loadMore() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      var list = state.valueOrNull ?? [];
      if (endFolder == false) {
        // 继续加载文件夹
        var res = await loadFolders(untilId: list.lastOrNull["data"].id);
        for (var item in res) {
          list.add({"type": "folder", "data": DriverFolderModel.fromMap(item)});
        }
      } else {
        // 加载文件
        var res = await loadFiles(untilId: list.lastOrNull["data"].id);
        for (var item in res) {
          list.add({"type": "file", "data": DriveFileModel.fromMap(item)});
        }
      }
      state = AsyncData(list);
    } on DioException catch (e) {
      state = AsyncError(e, e.stackTrace);
    }
  }

  Future<List> loadFiles({String? untilId}) async {
    var http = await ref.watch(httpProvider.future);
    var user = await ref.watch(currentLoginUserProvider.future);
    var path = ref.watch(drivePathProvider);
    var res = await http.post("/drive/files", data: {
      "folderId": path.lastOrNull?["id"],
      "i": user!.token,
      "limit": 30,
      if (untilId != null) "untilId": untilId
    });

    return res.data;
  }

  Future<List> loadFolders({String? untilId}) async {
    var http = await ref.watch(httpProvider.future);
    var user = await ref.watch(currentLoginUserProvider.future);
    var path = ref.watch(drivePathProvider);
    var res = await http.post("/drive/folders", data: {
      "folderId": path.lastOrNull?["id"],
      "i": user!.token,
      "limit": 30,
      if (untilId != null) "untilId": untilId
    });
    if (res.data.length < 30) {
      endFolder = true;
    }
    return res.data;
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

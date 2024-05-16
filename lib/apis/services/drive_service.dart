import 'package:dio/dio.dart';
import 'package:moekey/apis/models/drive.dart';
import 'package:moekey/apis/services/services.dart';

class DriveService extends MisskeyApiServices {
  DriveService({required super.client});

  Future<DriveFileModel?> upload({
    required String filename,
    String? folderId,
    required MultipartFile file,
    void Function(int, int)? onSendProgress,
  }) async {
    var res = await client.client.post(
      "/drive/files/create",
      data: FormData.fromMap({
        if (folderId != null) "folderId": folderId,
        "force": true,
        "name": filename,
        "i": client.accessToken,
        "file": file,
      }),
      onSendProgress: onSendProgress,
    );
    if (res.data != null) {
      return DriveFileModel.fromMap(res.data);
    }

    return null;
  }

  Future<DriverFolderModel?> createFolder({
    required String name,
    String? parentId,
  }) async {
    var res = await client.post(
      "/drive/folders/create",
      data: {
        if (parentId != null) "parentId": parentId,
        "name": name,
      },
    );
    if (res == null) {
      return null;
    }
    return DriverFolderModel.fromMap(res);
  }

  Future uploadFromUrl({
    required String url,
    String? folderId,
  }) async {
    await client.post("/drive/files/upload-from-url", data: {
      if (folderId != null) "folderId": folderId,
      "url": url,
    });
  }

  Future<DriveFileModel?> updateFile({
    required String fileId,
    String? folderId,
    bool? isSensitive,
    String? comment,
    String? name,
  }) async {
    var res = await client.post("/drive/files/update", data: {
      "fileId": fileId,
      if (folderId != null) "folderId": folderId,
      if (name != null) "name": name,
      if (isSensitive != null) "isSensitive": isSensitive,
      if (comment != null) "comment": comment,
    });
    if (res == null) {
      return null;
    }
    return DriveFileModel.fromMap(res);
  }

  Future<DriverFolderModel?> updateFolders({
    required String folderId,
    String? name,
    String? parentId,
  }) async {
    var res = await client.post("/drive/folders/update", data: {
      "folderId": folderId,
      if (name != null) "name": name,
      if (parentId != null) "parentId": parentId,
    });
    if (res == null) {
      return null;
    }
    return DriverFolderModel.fromMap(res);
  }

  Future deleteFile({required String fileId}) async {
    await client.post("/drive/files/delete", data: {
      "fileId": fileId,
    });
  }

  Future deleteFolders({required String folderId}) async {
    await client.post("/drive/folders/delete", data: {
      "folderId": folderId,
    });
  }

  Future<List<DriveFileModel>> files({
    String? folderId,
    String? untilId,
  }) async {
    var res = await client.post<List?>("/drive/files", data: {
      if (folderId != null) "folderId": folderId,
      if (untilId != null) "untilId": untilId,
      "limit": 30,
    });
    if (res == null) {
      return [];
    }
    return List<DriveFileModel>.from(res.map((x) => DriveFileModel.fromMap(x)));
  }

  Future<List<DriverFolderModel>> folders({
    String? folderId,
    String? untilId,
  }) async {
    var res = await client.post<List?>("/drive/folders", data: {
      if (folderId != null) "folderId": folderId,
      if (untilId != null) "untilId": untilId,
      "limit": 30,
    });
    if (res == null) {
      return [];
    }
    return List<DriverFolderModel>.from(
        res.map((x) => DriveFileModel.fromMap(x)));
  }
}

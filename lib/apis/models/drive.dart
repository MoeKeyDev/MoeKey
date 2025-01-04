import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'drive.freezed.dart';

part 'drive.g.dart';

class DriveModel {}

extension DriveModelExtension on DriveModel {
  String get id => (this as dynamic).id;

  String get name => (this as dynamic).name;

  String get createdAt => (this as dynamic).createdAt;
}

@freezed
class DriveFileModel extends DriveModel with _$DriveFileModel {
  factory DriveFileModel({
    String? blurhash,
    required String type,
    required String url,
    required int size,
    required bool isSensitive,
    String? comment,
    Properties? properties,
    String? thumbnailUrl,
    required String id,
    required String name,
    required String createdAt,
  }) = _DriveFileModel;

  factory DriveFileModel.fromJson(Map<String, dynamic> map) =>
      _$DriveFileModelFromJson(map);
}

@freezed
class Properties with _$Properties {
  const factory Properties({
    String? avgColor,
    double? height,
    double? orientation,
    double? width,
  }) = _Properties;

  factory Properties.fromJson(Map<String, dynamic> map) =>
      _$PropertiesFromJson(map);
}

@freezed
class DriverFolderModel extends DriveModel with _$DriverFolderModel {
  const factory DriverFolderModel({
    required String id,
    String? parentId,
    required String name,
    required String createdAt,
  }) = _DriverFolderModel;

  factory DriverFolderModel.fromJson(Map<String, dynamic> map) =>
      _$DriverFolderModelFromJson(map);
}

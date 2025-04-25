import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'drive.freezed.dart';

part 'drive.g.dart';

class DriveModel {
  DriveModel(
    this.id,
    this.name,
    this.createdAt,
  );

  final String id;
  final String name;
  final String createdAt;
}

@freezed
abstract class DriveFileModel extends DriveModel with _$DriveFileModel {
  DriveFileModel._(super.id, super.name, super.createdAt);

  factory DriveFileModel(
    String id,
    String name,
    String createdAt,
    String? blurhash,
    String type,
    String url,
    int size,
    bool isSensitive,
    String? comment,
    Properties? properties,
    String? thumbnailUrl,
  ) = _DriveFileModel;

  factory DriveFileModel.fromJson(Map<String, dynamic> map) =>
      _$DriveFileModelFromJson(map);
}

@freezed
abstract class Properties with _$Properties {
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
abstract class DriverFolderModel extends DriveModel with _$DriverFolderModel {
  DriverFolderModel._(super.id, super.name, super.createdAt);

  factory DriverFolderModel(
    String id,
    String? parentId,
    String name,
    String createdAt,
  ) = _DriverFolderModel;

  factory DriverFolderModel.fromJson(Map<String, dynamic> map) =>
      _$DriverFolderModelFromJson(map);
}

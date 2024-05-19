import 'package:flutter/cupertino.dart';

abstract class DriveModel {
  String id;
  String name;
  String createdAt;

  DriveModel({
    required this.id,
    required this.name,
    required this.createdAt,
  });
}

class DriveFileModel extends DriveModel {
  String? blurhash;
  String type;
  String url;
  int size;
  bool isSensitive;
  String? comment;
  Map? properties;
  String? thumbnailUrl;
  UniqueKey? hero;

  DriveFileModel({
    this.blurhash,
    required this.type,
    required this.url,
    required this.size,
    required this.isSensitive,
    this.properties,
    this.thumbnailUrl,
    this.comment,
    required this.hero,
    required super.id,
    required super.name,
    required super.createdAt,
  });

  @override
  String toString() {
    return 'DriveFileModel{blurhash: $blurhash, type: $type, url: $url, createdAt: $createdAt, size: $size, isSensitive: $isSensitive, name: $name, comment: $comment, id: $id, properties: $properties, thumbnailUrl: $thumbnailUrl, hero: $hero}';
  }

  factory DriveFileModel.fromMap(dynamic map) {
    return DriveFileModel(
      blurhash: map['blurhash'],
      type: map['type'],
      url: map['url'],
      createdAt: map['createdAt'],
      size: map['size'],
      name: map['name'],
      id: map['id'],
      properties: map['properties'],
      isSensitive: map['isSensitive'] ?? false,
      thumbnailUrl: map['thumbnailUrl'],
      comment: map['comment'],
      hero: null,
    );
  }

  DriveFileModel copyWith({
    String? blurhash,
    String? type,
    String? url,
    String? createdAt,
    int? size,
    bool? isSensitive,
    String? name,
    String? id,
    Map? properties,
    String? thumbnailUrl,
    UniqueKey? hero,
    String? comment,
  }) {
    return DriveFileModel(
      blurhash: blurhash ?? this.blurhash,
      type: type ?? this.type,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      size: size ?? this.size,
      isSensitive: isSensitive ?? this.isSensitive,
      name: name ?? this.name,
      id: id ?? this.id,
      properties: properties ?? this.properties,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      hero: hero ?? this.hero,
      comment: comment ?? this.comment,
    );
  }
}

class DriverFolderModel extends DriveModel {
  String? parentId;

  DriverFolderModel({
    required super.id,
    this.parentId,
    required super.name,
    required super.createdAt,
  });

  factory DriverFolderModel.fromMap(dynamic map) {
    return DriverFolderModel(
      createdAt: map['createdAt'],
      name: map['name'],
      id: map['id'],
      parentId: map['parentId']?.toString(),
    );
  }

  DriverFolderModel copyWith({
    String? createdAt,
    String? name,
    String? id,
    String? parentId,
  }) {
    return DriverFolderModel(
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
    );
  }
}

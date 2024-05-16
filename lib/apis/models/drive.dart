import 'package:flutter/cupertino.dart';

class DriveFileModel {
  String? blurhash;
  String type;
  String url;
  String createdAt;
  int size;
  bool isSensitive;
  String name;
  String id;
  Map? properties;
  String? thumbnailUrl;
  UniqueKey? hero;
  DriveFileModel({
    this.blurhash,
    required this.type,
    required this.url,
    required this.createdAt,
    required this.size,
    required this.isSensitive,
    required this.name,
    required this.id,
    this.properties,
    this.thumbnailUrl,
    required this.hero,
  });

  @override
  String toString() {
    return 'DriveFileModel{blurhash: $blurhash, type: $type, url: $url, createdAt: $createdAt, size: $size, isSensitive: $isSensitive, name: $name, id: $id, properties: $properties, thumbnailUrl: $thumbnailUrl, hero: $hero}';
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
        hero: null);
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
    );
  }
}

class DriverFolderModel {
  String createdAt;

  String name;

  String id;

  String? parentId;

  DriverFolderModel({
    required this.createdAt,
    required this.name,
    required this.id,
    this.parentId,
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

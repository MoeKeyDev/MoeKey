import 'dart:convert';

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
  Properties? properties;
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
      properties: Properties.fromMap(map['properties']),
      isSensitive: map['isSensitive'] ?? false,
      thumbnailUrl: map['thumbnailUrl'],
      comment: map['comment'],
      hero: UniqueKey(),
    );
  }

  factory DriveFileModel.fromJson(String str) =>
      DriveFileModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "blurhash": blurhash,
        "comment": comment,
        "createdAt": createdAt,
        "id": id,
        "isSensitive": isSensitive,
        "name": name,
        "properties": properties?.toMap(),
        "size": size,
        "thumbnailUrl": thumbnailUrl,
        "type": type,
        "url": url,
      };

  DriveFileModel copyWith({
    String? blurhash,
    String? type,
    String? url,
    String? createdAt,
    int? size,
    bool? isSensitive,
    String? name,
    String? id,
    Properties? properties,
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

class Properties {
  final String? avgColor;
  final double? height;
  final double? orientation;
  final double? width;

  Properties({
    this.avgColor,
    this.height,
    this.orientation,
    this.width,
  });

  Properties copyWith({
    String? avgColor,
    double? height,
    double? orientation,
    double? width,
  }) =>
      Properties(
        avgColor: avgColor ?? this.avgColor,
        height: height ?? this.height,
        orientation: orientation ?? this.orientation,
        width: width ?? this.width,
      );

  factory Properties.fromJson(String str) =>
      Properties.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Properties.fromMap(Map<String, dynamic> json) => Properties(
        avgColor: json["avgColor"],
        height: json["height"]?.toDouble(),
        orientation: json["orientation"]?.toDouble(),
        width: json["width"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "avgColor": avgColor,
        "height": height,
        "orientation": orientation,
        "width": width,
      };
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

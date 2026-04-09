// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticleModelAdapter extends TypeAdapter<ArticleModel> {
  @override
  final int typeId = 0;

  @override
  ArticleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArticleModel(
      id: fields[0] as String?,
      authorId: fields[1] as String?,
      title: fields[2] as String?,
      content: fields[3] as String?,
      thumbnailUrl: fields[4] as String?,
      tagIds: (fields[5] as List?)?.cast<String>(),
      status: fields[6] as String?,
      createdAt: fields[7] as DateTime?,
      avgReadTime: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ArticleModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.authorId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.content)
      ..writeByte(4)
      ..write(obj.thumbnailUrl)
      ..writeByte(5)
      ..write(obj.tagIds)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.avgReadTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArticleModel _$ArticleModelFromJson(Map<String, dynamic> json) => ArticleModel(
      id: json['id'] as String?,
      authorId: json['authorId'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      tagIds:
          (json['tagIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
      status: json['status'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      avgReadTime: (json['avgReadTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ArticleModelToJson(ArticleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'authorId': instance.authorId,
      'title': instance.title,
      'content': instance.content,
      'thumbnailUrl': instance.thumbnailUrl,
      'tagIds': instance.tagIds,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'avgReadTime': instance.avgReadTime,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

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

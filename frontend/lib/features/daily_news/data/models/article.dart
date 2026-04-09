import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

part 'article.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class ArticleModel extends ArticleEntity {
  @override
  @HiveField(0)
  final String? id;

  @override
  @HiveField(1)
  final String? authorId;

  @override
  @HiveField(2)
  final String? title;

  @override
  @HiveField(3)
  final String? content;

  @override
  @HiveField(4)
  final String? thumbnailUrl;

  @override
  @HiveField(5)
  final List<String>? tagIds;

  @override
  @HiveField(6)
  final String? status;

  @override
  @HiveField(7)
  final DateTime? createdAt;

  @override
  @HiveField(8)
  final int? avgReadTime;

  const ArticleModel({
    this.id,
    this.authorId,
    this.title,
    this.content,
    this.thumbnailUrl,
    this.tagIds,
    this.status,
    this.createdAt,
    this.avgReadTime,
  }) : super(
          id: id,
          authorId: authorId,
          title: title,
          content: content,
          thumbnailUrl: thumbnailUrl,
          tagIds: tagIds,
          status: status,
          createdAt: createdAt,
          avgReadTime: avgReadTime,
        );

  ArticleModel copyWith({
    String? id,
    String? authorId,
    String? title,
    String? content,
    String? thumbnailUrl,
    List<String>? tagIds,
    String? status,
    DateTime? createdAt,
    int? avgReadTime,
  }) {
    return ArticleModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      title: title ?? this.title,
      content: content ?? this.content,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      tagIds: tagIds ?? this.tagIds,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      avgReadTime: avgReadTime ?? this.avgReadTime,
    );
  }

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);

  factory ArticleModel.fromEntity(ArticleEntity entity) {
    return ArticleModel(
      id: entity.id,
      authorId: entity.authorId,
      title: entity.title,
      content: entity.content,
      thumbnailUrl: entity.thumbnailUrl,
      tagIds: entity.tagIds,
      status: entity.status,
      createdAt: entity.createdAt,
      avgReadTime: entity.avgReadTime,
    );
  }
}

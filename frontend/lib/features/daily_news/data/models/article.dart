import 'package:json_annotation/json_annotation.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

// 1. Vincular el archivo que se va a generar
part 'article.g.dart';

@JsonSerializable()
class ArticleModel extends ArticleEntity {
  @override
  final String? id;
  @override
  final String? authorId;
  @override
  final String? title;
  @override
  final String? content;
  @override
  final String? thumbnailUrl;
  @override
  final List<String>? tagIds;
  @override
  final String? status;
  @override
  final DateTime? createdAt;
  @override
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

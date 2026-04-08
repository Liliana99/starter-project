import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

// 1. Vincular el archivo que se va a generar
part 'article.g.dart';

@Entity(tableName: 'article', primaryKeys: ['id'])
@JsonSerializable()
class ArticleModel extends ArticleEntity {
  const ArticleModel({
    String? id,
    String? authorId,
    String? title,
    String? content,
    String? thumbnailUrl,
    List<String>? tagIds,
    String? status,
    DateTime? createdAt,
    int? avgReadTime,
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

  // 2. El generador creará estas funciones automáticamente
  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);

  // Útil para convertir la entidad pura a modelo de persistencia
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

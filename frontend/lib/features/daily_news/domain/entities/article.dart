import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final String? id;
  final String? authorId;
  final String? title;
  final String? content;
  final String? thumbnailUrl;
  final List<String>? tagIds;
  final String? status;
  final DateTime? createdAt;
  final int? avgReadTime;

  const ArticleEntity({
    this.id,
    this.authorId,
    this.title,
    this.content,
    this.thumbnailUrl,
    this.tagIds,
    this.status,
    this.createdAt,
    this.avgReadTime,
  });

  @override
  List<Object?> get props {
    return [
      id,
      authorId,
      title,
      content,
      thumbnailUrl,
      tagIds,
      status,
      createdAt,
      avgReadTime,
    ];
  }

  ArticleEntity copyWith({
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
    return ArticleEntity(
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
}

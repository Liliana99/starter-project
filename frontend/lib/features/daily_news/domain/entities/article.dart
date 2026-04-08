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
      content,
    ];
  }
}

import 'package:equatable/equatable.dart';
import '../../../../domain/entities/article.dart';

enum RemoteArticleStatus { initial, loading, success, error }

class RemoteArticleState extends Equatable {
  final List<ArticleEntity> articles;
  final RemoteArticleStatus status;
  final String? errorMessage;

  const RemoteArticleState({
    this.articles = const [],
    this.status = RemoteArticleStatus.initial,
    this.errorMessage,
  });

  RemoteArticleState copyWith({
    List<ArticleEntity>? articles,
    RemoteArticleStatus? status,
    String? errorMessage,
  }) {
    return RemoteArticleState(
      articles: articles ?? this.articles,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [articles, status, errorMessage];
}

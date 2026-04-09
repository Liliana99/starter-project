import 'package:equatable/equatable.dart';
import '../../../../domain/entities/article.dart';

enum LocalArticleStatus { initial, loading, success, error }

class LocalArticleState extends Equatable {
  final List<ArticleEntity> articles;
  final LocalArticleStatus status;
  final String? errorMessage;
  final String? searchQuery;
  final List<String>? tempTags;
  final List<String> allAvailableTags;

  const LocalArticleState({
    this.articles = const [],
    this.status = LocalArticleStatus.initial,
    this.errorMessage,
    this.searchQuery = '',
    this.tempTags,
    this.allAvailableTags = const [],
  });

  LocalArticleState copyWith({
    List<ArticleEntity>? articles,
    LocalArticleStatus? status,
    String? errorMessage,
    String? searchQuery,
    List<String>? tempTags,
    List<String>? allAvailableTags,
  }) {
    return LocalArticleState(
      articles: articles ?? this.articles,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      tempTags: tempTags ?? this.tempTags,
      allAvailableTags: allAvailableTags ?? this.allAvailableTags,
    );
  }

  @override
  List<Object?> get props =>
      [articles, status, errorMessage, searchQuery, tempTags, allAvailableTags];
}

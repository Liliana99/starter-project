import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

abstract class ArticleRepository {
  Future<DataState<List<ArticleEntity>>> getNewsArticles();

  Future<List<ArticleEntity>> getSavedArticles();
  Future<void> saveArticle(ArticleEntity article);
  Future<void> removeArticle(ArticleEntity article);

  Future<void> publishArticle(ArticleEntity article);
  Stream<List<ArticleEntity>> searchArticles(String query);

  Future<List<ArticleEntity>> getRemotePublishedArticles();
  Future<void> deleteRemoteArticle(String id);
}

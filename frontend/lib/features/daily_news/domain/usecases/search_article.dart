import '../entities/article.dart';
import '../repository/article_repository.dart';

class SearchArticleUseCase {
  final ArticleRepository _articleRepository;

  SearchArticleUseCase(this._articleRepository);

  Stream<List<ArticleEntity>> call(String query) {
    return _articleRepository.searchArticles(query);
  }
}

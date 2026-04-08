import '../../models/article.dart';

class LocalStorageService {
  final List<ArticleModel> _savedArticles = [];

  Future<List<ArticleModel>> getSavedArticles() async {
    return _savedArticles;
  }

  Future<void> saveArticle(ArticleModel article) async {
    if (!_savedArticles.contains(article)) {
      _savedArticles.add(article);
    }
  }

  Future<void> removeArticle(ArticleModel article) async {
    _savedArticles.remove(article);
  }
}

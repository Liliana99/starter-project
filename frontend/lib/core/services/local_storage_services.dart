import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';

class LocalStorageService {
  static const String _boxName = 'articles_box';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<ArticleModel>(_boxName);
  }

  Future<void> saveArticle(ArticleModel article) async {
    final box = Hive.box<ArticleModel>(_boxName);

    await box.put(article.thumbnailUrl ?? article.title, article);
  }

  Future<void> removeArticle(ArticleModel article) async {
    final box = Hive.box<ArticleModel>(_boxName);
    await box.delete(article.thumbnailUrl ?? article.title);
  }

  Future<List<ArticleModel>> getSavedArticles() async {
    final box = Hive.box<ArticleModel>(_boxName);
    return box.values.toList();
  }
}

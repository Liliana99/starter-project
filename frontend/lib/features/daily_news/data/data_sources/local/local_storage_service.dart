import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/article.dart';

class LocalStorageService {
  static const String _boxName = 'articles_box';

  final List<ArticleModel> _mockArticles = [
    ArticleModel(
      id: 'mock-1',
      title: 'El auge de los Agentes de IA en 2026',
      authorId: 'Kinetic Tech',
      content: 'Los sistemas agenticos están redefiniendo el software...',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1677442136019-21780ecad995',
      status: 'published',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      avgReadTime: 4,
    ),
    ArticleModel(
      id: 'mock-2',
      title: 'Clean Architecture: ¿Por qué Symmetry la prefiere?',
      authorId: 'Senior Dev',
      content: 'La separación de capas permite un mantenimiento escalable...',
      thumbnailUrl:
          'https://images.unsplash.com/photo-1517694712202-14dd9538aa97',
      status: 'published',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      avgReadTime: 6,
    ),
  ];

  Future<List<ArticleModel>> getSavedArticles() async {
    final box = await Hive.openBox(_boxName);

    if (box.isEmpty) {
      return _mockArticles;
    }

    final List<ArticleModel> articles = [];
    for (var item in box.values) {
      if (item is String) {
        articles.add(ArticleModel.fromJson(jsonDecode(item)));
      }
    }
    return articles;
  }

  Future<void> saveArticle(ArticleModel article) async {
    final box = await Hive.openBox(_boxName);
    final jsonString = jsonEncode(article.toJson());
    await box.put(article.id, jsonString);
  }

  Future<void> removeArticle(ArticleModel article) async {
    final box = await Hive.openBox(_boxName);
    await box.delete(article.id);
  }

  Future<List<ArticleModel>> searchArticles(String query) async {
    final articles = await getSavedArticles();
    if (query.isEmpty) return articles;

    return articles.where((article) {
      final title = article.title?.toLowerCase() ?? '';
      final content = article.content?.toLowerCase() ?? '';
      final search = query.toLowerCase();
      return title.contains(search) || content.contains(search);
    }).toList();
  }
}

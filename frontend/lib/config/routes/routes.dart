import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/create_article/article_create.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/home/detail_page.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/home/home_page.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/manage_article/manage_article_page.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/pages/profile/profile_page.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const HomePage());

      case '/CreateArticle':
        return _materialRoute(const CreateArticlePage());

      case '/ManageArticle':
        return _materialRoute(const ManageArticlePage());

      case '/ArticleDetail':
        final article = settings.arguments as ArticleEntity;
        return _materialRoute(ArticleDetailPage(article: article));

      case '/Profile':
        return _materialRoute(const ProfilePage());

      default:
        return _materialRoute(const HomePage());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}

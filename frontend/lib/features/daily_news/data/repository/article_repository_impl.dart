import 'dart:io';
import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/constants/constants.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/local_storage_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

import '../data_sources/remote/news_api_service.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  final LocalStorageService
      _localStorageService; // Cambiamos AppDatabase por nuestro Mock

  ArticleRepositoryImpl(this._newsApiService, this._localStorageService);

  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final response = await _newsApiService.getNewsArticles(
        apiKey: newsAPIKey,
        country: countryQuery,
        category: categoryQuery,
      );

      if (response.statusCode == HttpStatus.ok) {
        final articles = (response.data!['articles'] as List)
            .map((i) => ArticleModel.fromJson(i))
            .toList();

        return DataSuccess(articles);
      } else {
        return DataFailed(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } on DioException catch (e) {
      return DataFailed(e);
    }
  }

  @override
  Future<List<ArticleModel>> getSavedArticles() async {
    return _localStorageService.getSavedArticles();
  }

  @override
  Future<void> removeArticle(ArticleEntity article) {
    return _localStorageService.removeArticle(ArticleModel.fromEntity(article));
  }

  @override
  Future<void> saveArticle(ArticleEntity article) {
    return _localStorageService.saveArticle(ArticleModel.fromEntity(article));
  }
}

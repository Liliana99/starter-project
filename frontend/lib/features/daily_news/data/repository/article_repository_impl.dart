import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/constants/constants.dart';
import 'package:news_app_clean_architecture/core/services/cloudinary_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/local_storage_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';

import '../data_sources/remote/news_api_service.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final NewsApiService _newsApiService;
  final LocalStorageService _localStorageService;
  final FirebaseFirestore _firestore;

  ArticleRepositoryImpl(
    this._newsApiService,
    this._localStorageService,
    this._firestore,
  );

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

  @override
  Future<void> publishArticle(ArticleEntity article) async {
    try {
      final String confirmedId = (article.id != null && article.id!.isNotEmpty)
          ? article.id!
          : _firestore.collection('articles').doc().id;

      String? finalImageUrl = article.thumbnailUrl;

      if (article.thumbnailUrl != null &&
          article.thumbnailUrl!.isNotEmpty &&
          !article.thumbnailUrl!.startsWith('http')) {
        final file = File(article.thumbnailUrl!);

        if (!await file.exists()) {
          throw Exception(
              "El archivo no existe en la ruta local: ${article.thumbnailUrl}");
        }

        finalImageUrl = await CloudinaryService.uploadImage(file);
      }

      final articleModel = ArticleModel.fromEntity(article).copyWith(
        id: confirmedId,
        thumbnailUrl: finalImageUrl,
      );

      final json = articleModel.toJson();

      if (articleModel.createdAt != null) {
        json['createdAt'] = Timestamp.fromDate(articleModel.createdAt!);
      }

      json['searchTokens'] = _generateSearchTokens(
        title: articleModel.title ?? "",
        content: articleModel.content ?? "",
        tags: articleModel.tagIds ?? [],
      );

      json['id'] = confirmedId;

      await _firestore.collection('articles').doc(confirmedId).set(json);

      await _localStorageService.saveArticle(articleModel);
    } catch (e) {
      print("Error en publishArticle: $e");
      throw Exception("Error en el flujo de publicación de Symetry: $e");
    }
  }

  @override
  Stream<List<ArticleEntity>> searchArticles(String query) {
    Query queryRef = _firestore.collection('articles');

    if (query.isNotEmpty) {
      queryRef =
          queryRef.where('searchTokens', arrayContains: query.toLowerCase());
    } else {
      queryRef = queryRef.orderBy('createdAt', descending: true);
    }

    return queryRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;

        if (data['createdAt'] is Timestamp) {
          data['createdAt'] =
              (data['createdAt'] as Timestamp).toDate().toIso8601String();
        }

        return ArticleModel.fromJson(data);
      }).toList();
    });
  }

  List<String> _generateSearchTokens({
    required String title,
    required String content,
    required List<String> tags,
  }) {
    final Set<String> tokens = {};

    void tokenize(String text) {
      // Dividimos por espacios para indexar cada palabra por separado
      final words = text.toLowerCase().split(RegExp(r'\s+'));
      for (var word in words) {
        if (word.length < 2) continue; // Ignorar letras sueltas
        for (int i = 1; i <= word.length; i++) {
          tokens.add(word.substring(0, i));
        }
      }
    }

    tokenize(title);
    tokenize(content);
    for (var tag in tags) {
      tokenize(tag);
    }

    return tokens.toList();
  }

  @override
  Future<List<ArticleEntity>> getRemotePublishedArticles() async {
    final snapshot = await _firestore
        .collection('articles')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      if (data['createdAt'] is Timestamp) {
        data['createdAt'] =
            (data['createdAt'] as Timestamp).toDate().toIso8601String();
      }
      return ArticleModel.fromJson(data);
    }).toList();
  }

  @override
  Future<void> deleteRemoteArticle(String id) async {
    try {
      await _firestore.collection('articles').doc(id).delete();
    } catch (e) {
      throw Exception("Error al eliminar el artículo de Firestore: $e");
    }
  }
}

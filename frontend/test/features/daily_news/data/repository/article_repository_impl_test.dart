import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/local_storage_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/models/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockNewsApiService extends Mock implements NewsApiService {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

class MockFirestore extends Mock implements FirebaseFirestore {}

void main() {
  late ArticleRepositoryImpl repository;
  late MockNewsApiService mockNewsApi;
  late MockLocalStorageService mockLocalService;
  late MockFirestore mockFirestore;

  setUp(() {
    mockNewsApi = MockNewsApiService();
    mockLocalService = MockLocalStorageService();
    mockFirestore = MockFirestore();
    repository =
        ArticleRepositoryImpl(mockNewsApi, mockLocalService, mockFirestore);
  });

  final tArticleModel = ArticleModel(
    title: 'Offline News',
    authorId: 'Reporter',
    content: 'This was saved locally',
  );

  test(
    'should return local saved articles when remote call fails (Offline behavior)',
    () async {
      when(() => mockNewsApi.getNewsArticles(
            apiKey: any(named: 'apiKey'),
            country: any(named: 'country'),
            category: any(named: 'category'),
          )).thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      when(() => mockLocalService.getSavedArticles())
          .thenAnswer((_) async => [tArticleModel]);

      final result = await repository.getNewsArticles();

      expect(result, isA<DataSuccess>());
      expect(result.data?.first.title, 'Offline News');

      verify(() => mockLocalService.getSavedArticles()).called(1);
    },
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';

class MockArticleRepository extends Mock implements ArticleRepository {}

void main() {
  late GetArticleUseCase useCase;
  late MockArticleRepository mockArticleRepository;

  setUp(() {
    mockArticleRepository = MockArticleRepository();
    useCase = GetArticleUseCase(mockArticleRepository);
  });

  final tArticle = ArticleEntity(
      title: 'Test Title', content: 'Test Content', thumbnailUrl: 'test.jpg');

  test(
    'should get articles from the repository',
    () async {
      when(() => mockArticleRepository.getNewsArticles()).thenAnswer(
        (_) async => DataSuccess([tArticle]),
      );
      final result = await useCase();

      expect(result.data, [tArticle]);
      verify(() => mockArticleRepository.getNewsArticles()).called(1);
      verifyNoMoreInteractions(mockArticleRepository);
    },
  );
}

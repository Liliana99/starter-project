import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/resources/data_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/search_article.dart';
import 'remote_article_state.dart';
import '../../../../domain/usecases/get_article.dart';
import '../../../../domain/repository/article_repository.dart';

class RemoteArticleCubit extends Cubit<RemoteArticleState> {
  final GetArticleUseCase _getArticleUseCase;
  final SearchArticleUseCase _searchUseCase;
  final ArticleRepository _articleRepository;

  RemoteArticleCubit(
    this._getArticleUseCase,
    this._searchUseCase,
    this._articleRepository,
  ) : super(const RemoteArticleState());

  void onSearchRemote(String query) async {
    if (query.isEmpty) {
      onGetArticles();
      return;
    }

    emit(state.copyWith(status: RemoteArticleStatus.loading));

    try {
      final firestoreResults =
          await _articleRepository.searchArticles(query).first;

      final apiResults = await _searchUseCase(query).first;

      final merged = [...firestoreResults, ...apiResults];

      emit(state.copyWith(
        status: RemoteArticleStatus.success,
        articles: merged,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RemoteArticleStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> onGetArticles() async {
    emit(state.copyWith(status: RemoteArticleStatus.loading));

    try {
      final List<ArticleEntity> firestoreArticles =
          await _articleRepository.getRemotePublishedArticles();

      final dataState = await _getArticleUseCase();

      List<ArticleEntity> apiArticles = [];
      if (dataState is DataSuccess && dataState.data != null) {
        apiArticles = dataState.data!;
      }

      final merged = [...firestoreArticles, ...apiArticles];

      emit(state.copyWith(
        status: RemoteArticleStatus.success,
        articles: merged,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: RemoteArticleStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}

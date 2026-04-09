import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/publish_article.dart';
import 'local_article_state.dart';
import '../../../../domain/entities/article.dart';
import '../../../../domain/usecases/get_saved_article.dart';
import '../../../../domain/usecases/save_article.dart';
import '../../../../domain/usecases/remove_article.dart';

class LocalArticleCubit extends Cubit<LocalArticleState> {
  final GetSavedArticleUseCase _getSavedArticleUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;
  final PublishArticleUseCase _publishArticleUseCase;
  final ArticleRepository _articleRepository;

  LocalArticleCubit(
    this._getSavedArticleUseCase,
    this._saveArticleUseCase,
    this._removeArticleUseCase,
    this._publishArticleUseCase,
    this._articleRepository,
  ) : super(const LocalArticleState());

  void onTagsChanged(List<String> tags) {
    emit(state.copyWith(tempTags: tags, status: LocalArticleStatus.initial));
  }

  Future<void> onPublishArticle(ArticleEntity article,
      {Uint8List? imageBytes}) async {
    emit(state.copyWith(status: LocalArticleStatus.loading));
    try {
      String? finalImageUrl = article.thumbnailUrl;

      // Si tenemos bytes nuevos (de la selección), los subimos primero
      if (imageBytes != null) {
        finalImageUrl = await _articleRepository.uploadImageBytes(imageBytes);
      }

      final articleWithImage = article.copyWith(thumbnailUrl: finalImageUrl);
      await _publishArticleUseCase(params: articleWithImage);

      List<ArticleEntity> remoteArticles = [];
      try {
        remoteArticles = await _articleRepository.getRemotePublishedArticles();
      } catch (_) {}
      final localArticles = await _getSavedArticleUseCase();
      final remoteIds = remoteArticles.map((a) => a.id).toSet();
      final onlyLocal =
          localArticles.where((a) => !remoteIds.contains(a.id)).toList();
      final merged = [...remoteArticles, ...onlyLocal];

      merged.sort((a, b) {
        final dateA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final dateB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return dateB.compareTo(dateA);
      });

      emit(state.copyWith(
        status: LocalArticleStatus.publishedSuccess,
        articles: merged,
        allAvailableTags: _extractUniqueTags(merged),
        tempTags: [],
      ));
    } catch (e) {
      emit(state.copyWith(
          status: LocalArticleStatus.error,
          errorMessage: "Error al publicar: ${e.toString()}"));
    }
  }

  Future<void> onGetSavedArticles() async {
    emit(state.copyWith(status: LocalArticleStatus.loading));
    try {
      List<ArticleEntity> remoteArticles = [];
      try {
        remoteArticles = await _articleRepository.getRemotePublishedArticles();
      } catch (_) {}

      final localArticles = await _getSavedArticleUseCase();

      final remoteIds = remoteArticles.map((a) => a.id).toSet();

      final onlyLocal =
          localArticles.where((a) => !remoteIds.contains(a.id)).toList();

      final merged = [...remoteArticles, ...onlyLocal];

      merged.sort((a, b) {
        final dateA = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final dateB = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return dateB.compareTo(dateA);
      });

      final availableTags = _extractUniqueTags(merged);

      emit(state.copyWith(
        status: LocalArticleStatus.success,
        articles: merged,
        allAvailableTags: availableTags,
      ));
    } catch (e) {
      emit(state.copyWith(
          status: LocalArticleStatus.error, errorMessage: e.toString()));
    }
  }

  List<String> _extractUniqueTags(List<ArticleEntity> articles) {
    final Set<String> uniqueTags = {};
    for (var article in articles) {
      if (article.tagIds != null) {
        uniqueTags.addAll(article.tagIds!);
      }
    }
    final list = uniqueTags.toList()..sort();
    return list;
  }

  Future<void> onSaveArticle(ArticleEntity article) async {
    emit(state.copyWith(status: LocalArticleStatus.loading));
    try {
      await _saveArticleUseCase(params: article);
      await onGetSavedArticles();
    } catch (e) {
      emit(state.copyWith(
          status: LocalArticleStatus.error,
          errorMessage: "No se pudo guardar el artículo"));
    }
  }

  Future<void> onRemoveArticle(ArticleEntity article) async {
    emit(state.copyWith(status: LocalArticleStatus.loading));
    try {
      if (article.id != null && article.id!.length > 5) {
        await _articleRepository.deleteRemoteArticle(article.id!);
      }

      await _removeArticleUseCase(params: article);

      await onGetSavedArticles();
    } catch (e) {
      emit(state.copyWith(
          status: LocalArticleStatus.error,
          errorMessage: "Error al eliminar: ${e.toString()}"));
    }
  }

  void onSearchArticles(String query) async {
    emit(
        state.copyWith(status: LocalArticleStatus.loading, searchQuery: query));

    try {
      final allArticles = await _getSavedArticleUseCase();

      if (query.isEmpty) {
        emit(state.copyWith(
            status: LocalArticleStatus.success, articles: allArticles));
        return;
      }

      final filteredArticles = allArticles.where((article) {
        final title = article.title?.toLowerCase() ?? '';
        final content = article.content?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();

        return title.contains(searchLower) || content.contains(searchLower);
      }).toList();

      emit(state.copyWith(
          status: LocalArticleStatus.success, articles: filteredArticles));
    } catch (e) {
      emit(state.copyWith(
          status: LocalArticleStatus.error, errorMessage: "Error al buscar"));
    }
  }
}

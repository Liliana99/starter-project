import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/local/local_storage_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/data_sources/remote/news_api_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/data/repository/article_repository_impl.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/repository/article_repository.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/get_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/publish_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/usecases/search_article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/remote/remote_article_cubit.dart';
import 'features/daily_news/domain/usecases/get_saved_article.dart';
import 'features/daily_news/domain/usecases/remove_article.dart';
import 'features/daily_news/domain/usecases/save_article.dart';
import 'features/daily_news/presentation/bloc/article/local/local_article_cubit.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<Dio>(Dio());

  sl.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  sl.registerSingleton<NewsApiService>(NewsApiService(sl<Dio>()));

  final localStorageService = LocalStorageService();

  sl.registerSingleton<LocalStorageService>(localStorageService);

  // Repos
  sl.registerLazySingleton<ArticleRepository>(
    () => ArticleRepositoryImpl(
      sl<NewsApiService>(), // 1. newsApiService
      sl<LocalStorageService>(), // 2. localStorageService
      sl<FirebaseFirestore>(), // 3. firestore   
    ),
  );

  sl.registerSingleton<GetArticleUseCase>(GetArticleUseCase(sl()));
  sl.registerSingleton<GetSavedArticleUseCase>(GetSavedArticleUseCase(sl()));
  sl.registerSingleton<SaveArticleUseCase>(SaveArticleUseCase(sl()));
  sl.registerSingleton<RemoveArticleUseCase>(RemoveArticleUseCase(sl()));
  sl.registerSingleton<PublishArticleUseCase>(PublishArticleUseCase(sl()));
  sl.registerLazySingleton<SearchArticleUseCase>(
      () => SearchArticleUseCase(sl()));

  sl.registerFactory<RemoteArticleCubit>( () => RemoteArticleCubit(sl(), sl(), sl()));
  
  sl.registerFactory<LocalArticleCubit>(
    () => LocalArticleCubit(
      sl<GetSavedArticleUseCase>(),
      sl<SaveArticleUseCase>(),
      sl<RemoveArticleUseCase>(),
      sl<PublishArticleUseCase>(),
      sl<ArticleRepository>(),
    ),
  );
}

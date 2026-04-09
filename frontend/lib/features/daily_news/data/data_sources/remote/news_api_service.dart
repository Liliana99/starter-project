import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/constants/constants.dart';

class NewsApiService {
  final Dio _dio;

  NewsApiService(this._dio);

  Future<Response<Map<String, dynamic>>> getNewsArticles({
    String? apiKey,
    String? country,
    String? category,
  }) async {
    return await _dio.get(
      newsAPIBaseURL,
      queryParameters: {
        'apiKey': apiKey,
        'country': country,
        'category': category,
      },
    );
  }
}

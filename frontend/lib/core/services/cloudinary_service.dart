import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:news_app_clean_architecture/core/config/secrets.dart';

class CloudinaryService {
  static final Dio _dio = Dio();

  static Future<String> uploadImage(Uint8List imageBytes,
      {String folder = 'articles', String? fileName}) async {
    const cloudName = Secrets.cloudinaryCloudName;
    const uploadPreset = Secrets.cloudinaryUploadPreset;

    final url = 'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        imageBytes,
        filename:
            fileName ?? 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ),
      'upload_preset': uploadPreset,
      'folder': folder,
    });

    try {
      final response = await _dio.post(url, data: formData);

      if (response.statusCode == 200) {
        return response.data['secure_url'] as String;
      } else {
        throw Exception(
            'Cloudinary respondió con status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Error al subir imagen a Cloudinary: ${e.message}');
    }
  }
}

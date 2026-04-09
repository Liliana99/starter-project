import 'package:hive/hive.dart';

class ProfileService {
  static const String _boxName = 'user_profile';

  static Future<void> saveProfile({
    required String name,
    required String bio,
    String? imageUrl,
  }) async {
    var box = await Hive.openBox(_boxName);
    await box.put('name', name);
    await box.put('bio', bio);
    if (imageUrl != null) {
      await box.put('imageUrl', imageUrl);
    }
  }

  static Future<Map<String, String?>> getProfile() async {
    var box = await Hive.openBox(_boxName);
    return {
      'name': box.get('name', defaultValue: 'Julianne Vane') as String?,
      'bio': box.get('bio', defaultValue: 'Digital curator and tech enthusiast...') as String?,
      'imageUrl': box.get('imageUrl') as String?,
    };
  }
}

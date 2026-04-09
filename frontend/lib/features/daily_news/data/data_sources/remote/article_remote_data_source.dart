import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleRemoteDataSource {
  final FirebaseFirestore _firestore;

  ArticleRemoteDataSource(this._firestore);

  Future<void> createArticle(Map<String, dynamic> articleData) async {
    await _firestore
        .collection('articles')
        .doc(articleData['id'])
        .set(articleData);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchArticles(String? query) {
    if (query == null || query.isEmpty) {
      return _firestore.collection('articles').snapshots();
    }

    return _firestore
        .collection('articles')
        .where('searchTokens', arrayContains: query.toLowerCase())
        .snapshots();
  }
}

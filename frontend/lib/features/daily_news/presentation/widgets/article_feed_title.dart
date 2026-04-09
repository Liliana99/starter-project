// import 'dart:io'; // Eliminado para compatibilidad web
import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

class ArticleFeedTile extends StatelessWidget {
  final ArticleEntity article;
  final bool isUserArticle;

  const ArticleFeedTile({
    super.key,
    required this.article,
    this.isUserArticle = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final screenWidth = MediaQuery.of(context).size.width;
    final dynamicHeight = (screenWidth * 0.25).clamp(200.0, 400.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildThumbnail(article.thumbnailUrl, dynamicHeight),
              ),
              if (isUserArticle)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Row(
                    children: [
                      _actionIcon(Icons.edit, const Color(0xFF1A1A40)),
                      const SizedBox(width: 8),
                      _actionIcon(Icons.delete, const Color(0xFFC84B1F)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                (article.tagIds?.first ?? "GENERAL").toUpperCase(),
                style: TextStyle(
                  color: colorScheme.tertiary,
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
              if (isUserArticle) ...[
                const SizedBox(width: 8),
                const Text(
                  "YOUR ARTICLE",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w900,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            article.title ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1A40),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            article.content ?? '',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF5D5D81), height: 1.5),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "12 MIN READ",
                style: TextStyle(
                  color: Color(0xFF5D5D81),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/ArticleDetail',
                    arguments: article),
                child: Row(
                  children: [
                    Text(
                      "READ MORE",
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Icon(Icons.arrow_right_alt,
                        color: colorScheme.primary, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(String? url, double height) {
    if (url == null || url.isEmpty) {
      return _placeholder(height);
    }

    if (url.startsWith('http')) {
      return Image.network(
        url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(height),
      );
    }

    return _placeholder(height);
  }

  Widget _placeholder(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: const Color(0xFFF0F0F8),
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined,
            size: 40, color: Color(0xFFC0C0D6)),
      ),
    );
  }

  Widget _actionIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}

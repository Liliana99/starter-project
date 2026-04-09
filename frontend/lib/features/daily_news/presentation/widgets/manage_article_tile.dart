import 'dart:io';
import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

class ManageArticleTile extends StatelessWidget {
  final ArticleEntity article;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ManageArticleTile({
    super.key,
    required this.article,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                child: _buildThumbnail(article.thumbnailUrl),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    (article.tagIds?.first ?? "TECH").toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "AUG 24, 2024",
                      style: TextStyle(
                        color: colorScheme.secondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: onEdit,
                          child: const Icon(Icons.edit,
                              size: 18, color: Color(0xFF5C79FF)),
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: onDelete,
                          child: const Icon(Icons.delete,
                              size: 18, color: Color(0xFFC84B1F)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                  style: const TextStyle(
                      color: Color(0xFF5D5D81), fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.visibility,
                            size: 14, color: Color(0xFFC0C0D6)),
                        SizedBox(width: 6),
                        Text(
                          "2.4k",
                          style: TextStyle(
                            color: Color(0xFF5D5D81),
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/ArticleDetail',
                        arguments: article,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "READ MORE",
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: 10,
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
          ),
        ],
      ),
    );
  }
  /// Muestra la imagen correctamente según su origen:
  /// - URL remota (Cloudinary): usa [Image.network]
  /// - Ruta local (archivo del dispositivo): usa [Image.file]
  /// - Sin imagen: muestra un placeholder
  Widget _buildThumbnail(String? url) {
    const double height = 200;

    if (url == null || url.isEmpty) {
      return _placeholder(height);
    }

    if (url.startsWith('http')) {
      return Image.network(
        url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : Container(
                height: height,
                color: const Color(0xFFF0F0F8),
                child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2)),
              ),
        errorBuilder: (_, __, ___) => _placeholder(height),
      );
    }

    // Ruta local
    final file = File(url);
    if (file.existsSync()) {
      return Image.file(
        file,
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
}

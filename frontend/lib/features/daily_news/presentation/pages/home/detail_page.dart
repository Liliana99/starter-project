import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/navigation_bar.dart';

import '../../widgets/detail_hero.dart';
import '../../widgets/author_section.dart';

class ArticleDetailPage extends StatelessWidget {
  final ArticleEntity article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "KINETIC",
          style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailHero(article: article),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  AuthorSection(article: article),
                  const SizedBox(height: 40),
                  _buildBodyText(article.content ?? 'No content available.'),
                  const SizedBox(height: 32),
                  if (article.tagIds != null && article.tagIds!.isNotEmpty) ...[
                    const Divider(),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: article.tagIds!
                          .map((tag) => Text(
                                "#$tag",
                                style: const TextStyle(
                                  color: Color(0xFF5C79FF),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          const KineticNavigationBar(currentRoute: '/ArticleDetail'),
      extendBody: true,
    );
  }

  Widget _buildBodyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        color: Color(0xFF1A1A40),
        height: 1.8,
      ),
    );
  }
}

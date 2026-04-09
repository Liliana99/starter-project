import 'package:flutter/material.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';

class AuthorSection extends StatelessWidget {
  final ArticleEntity article;

  const AuthorSection({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=julian'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.authorId ?? "Julian Vance",
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: Color(0xFF1A1A40),
                ),
              ),
              const Text(
                "Senior Energy Correspondent",
                style: TextStyle(color: Color(0xFF737373), fontSize: 12),
              ),
            ],
          ),
        ),
        _buildMeta("PUBLISHED", "Oct 24, 2023"),
        const SizedBox(width: 20),
        _buildMeta("READ TIME", "12 Min"),
      ],
    );
  }

  Widget _buildMeta(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFC0C0D6),
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF1A1A40),
            fontSize: 12,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final String articles;
  final String readers;
  final String following;

  const ProfileStats({
    super.key,
    required this.articles,
    required this.readers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem(articles, "ARTICLES"),
          _buildStatItem(readers, "READERS"),
          _buildStatItem(following, "FOLLOWING"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFF5C79FF),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFC0C0D6),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}

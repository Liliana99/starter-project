import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/app_drawer.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/navigation_bar.dart';
import '../../bloc/article/local/local_article_cubit.dart';
import '../../bloc/article/local/local_article_state.dart';

import '../../widgets/profile_header.dart';
import '../../widgets/profile_stats.dart';
import '../../widgets/growth_insight_card.dart';
import '../../widgets/manage_article_tile.dart';

class ManageArticlePage extends StatefulWidget {
  const ManageArticlePage({super.key});

  @override
  State<ManageArticlePage> createState() => _ManageArticlePageState();
}

class _ManageArticlePageState extends State<ManageArticlePage> {
  @override
  void initState() {
    super.initState();
    context.read<LocalArticleCubit>().onGetSavedArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      drawer: const KineticDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF1A1A40)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        }),
        title: const Text(
          "The Kinetic Editorial",
          style: TextStyle(
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1A40),
              fontSize: 16),
        ),
      ),
      body: BlocBuilder<LocalArticleCubit, LocalArticleState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/Profile');
                  },
                  child: const ProfileHeader(
                    name: "Julian Vance",
                    role: "SENIOR EDITOR",
                    bio:
                        "Exploring the intersection of kinetic energy and digital landscapes. Deciphering the pulse of modern technology through an editorial lens since 2018.",
                    imageUrl: 'https://i.pravatar.cc/400?u=julian',
                  ),
                ),
                const ProfileStats(
                  articles: "48",
                  readers: "12.4k",
                  following: "92",
                ),
                GrowthInsightCard(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/CreateArticle'),
                ),
                _buildStoriesHeader(),
                state.status == LocalArticleStatus.loading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(40),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: state.articles.length,
                        itemBuilder: (context, index) {
                          final article = state.articles[index];
                          return ManageArticleTile(
                            article: article,
                            onDelete: () => _showDeleteDialog(context, article),
                            onEdit: () {
                              Navigator.pushNamed(
                                context,
                                '/CreateArticle',
                                arguments: article,
                              );
                            },
                          );
                        },
                      ),
                const SizedBox(height: 140),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar:
          const KineticNavigationBar(currentRoute: '/ManageArticle'),
    );
  }

  void _showDeleteDialog(BuildContext context, ArticleEntity article) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Delete Article",
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Are you sure you want to delete this story?"),
            const SizedBox(height: 12),
            Text(
              article.title ?? "",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC84B1F),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              context.read<LocalArticleCubit>().onRemoveArticle(article);
              Navigator.pop(context);
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildStoriesHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: const Text(
                  "My Published Stories",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1A1A40)),
                ),
              ),
              Row(
                children: [
                  _iconBox(Icons.grid_view_rounded, isSelected: true),
                  const SizedBox(width: 4),
                  _iconBox(Icons.format_list_bulleted_rounded,
                      isSelected: false),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
              width: 40,
              height: 3,
              color: const Color(0xFF5C79FF).withOpacity(0.3)),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE8E8F3) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon,
          size: 18,
          color:
              isSelected ? const Color(0xFF5C79FF) : const Color(0xFFC0C0D6)),
    );
  }
}

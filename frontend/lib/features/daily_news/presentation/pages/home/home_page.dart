import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/article_feed_title.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/home_hero.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/app_drawer.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/navigation_bar.dart';
import '../../bloc/article/remote/remote_article_cubit.dart';
import '../../bloc/article/remote/remote_article_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<RemoteArticleCubit>().onGetArticles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFF),
      drawer: const KineticDrawer(),
      appBar: _buildAppBar(context),
      body: BlocBuilder<RemoteArticleCubit, RemoteArticleState>(
        builder: (context, state) {
          if (state.status == RemoteArticleStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final firestoreArticles = state.articles;
          final mockArticles = _getMockArticles();

          final articles = [...firestoreArticles, ...mockArticles];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHero(article: articles.first),
                const SizedBox(height: 24),
                _buildCategoryFilter(),
                const SizedBox(height: 32),
                _buildFeedHeader(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: articles.length - 1,
                  itemBuilder: (context, index) {
                    final article = articles[index + 1];
                    return ArticleFeedTile(
                      article: article,
                      isUserArticle: false,
                    );
                  },
                ),
                const SizedBox(height: 120),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const KineticNavigationBar(currentRoute: '/'),
      extendBody: true,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Builder(builder: (context) {
        return IconButton(
          icon: Icon(_isSearching ? Icons.arrow_back : Icons.menu,
              color: Colors.black),
          onPressed: () {
            if (_isSearching) {
              setState(() {
                _isSearching = false;
                _searchController.clear();
              });
              context.read<RemoteArticleCubit>().onGetArticles();
            } else {
              Scaffold.of(context).openDrawer();
            }
          },
        );
      }),
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: "Search stories...",
                border: InputBorder.none,
              ),
              onChanged: (val) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    context.read<RemoteArticleCubit>().onSearchRemote(val);
                  }
                });
              },
            )
          : const Text("KINETIC",
              style: TextStyle(
                  letterSpacing: 2,
                  fontWeight: FontWeight.w900,
                  color: Colors.black)),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search,
              color: Colors.black),
          onPressed: () {
            setState(() {
              if (_isSearching) {
                _searchController.clear();
                context.read<RemoteArticleCubit>().onGetArticles();
              }
              _isSearching = !_isSearching;
            });
          },
        ),
        const SizedBox(width: 8),
        if (!_isSearching) ...[
          const CircleAvatar(
              radius: 14,
              backgroundImage:
                  NetworkImage('https://i.pravatar.cc/150?u=julian')),
          const SizedBox(width: 16),
        ],
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _FilterChip(label: "ALL STORIES", isActive: true),
          SizedBox(width: 12),
          _FilterChip(label: "TECHNOLOGY"),
          SizedBox(width: 12),
          _FilterChip(label: "POLITICS"),
        ],
      ),
    );
  }

  Widget _buildFeedHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("The Latest Feed",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1A1A40))),
          Text("UPDATE NOW",
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF7C3AED),
                  letterSpacing: 1)),
        ],
      ),
    );
  }

  List<ArticleEntity> _getMockArticles() {
    return [
      ArticleEntity(
        title: "The Hydrogen Shift: Powering the New Century",
        content:
            "Global energy infrastructures are pivoting as the first commercial hydrogen grids go online across Northern Europe.",
        thumbnailUrl:
            "https://images.unsplash.com/photo-1473341304170-971dccb5ac1e",
        tagIds: ["GLOBAL PULSE"],
      ),
      ArticleEntity(
        title: "Quantum Encryption Standards Finalized for 2025",
        content:
            "Why the sudden shift in global cybersecurity protocols means everything for digital privacy next year.",
        thumbnailUrl:
            "https://images.unsplash.com/photo-1639322537228-f710d846310a",
        tagIds: ["THE SILICON PULSE"],
      ),
      ArticleEntity(
        title: "Reclaiming the Concrete: The Vertical Forest Initiative",
        content:
            "How Singapore's urban design is inspiring a new wave of oxygen-rich skyscrapers globally.",
        thumbnailUrl:
            "https://images.unsplash.com/photo-1449844908441-8829872d2607",
        tagIds: ["URBANISM"],
      ),
    ];
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  const _FilterChip({required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF5C79FF) : const Color(0xFFE8E8F3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : const Color(0xFF5D5D81),
          fontWeight: FontWeight.w900,
          fontSize: 11,
        ),
      ),
    );
  }
}

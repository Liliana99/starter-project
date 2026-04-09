import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/services/notification_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/navigation_bar.dart';

class EditArticlePage extends StatefulWidget {
  final ArticleEntity article;

  const EditArticlePage({super.key, required this.article});

  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  late TextEditingController _headlineController;
  late TextEditingController _bodyController;
  final TextEditingController _tagController = TextEditingController();

  String? _imageUrl;
  Uint8List? _imageBytes;
  late ArticleEntity _editingArticle;

  @override
  void initState() {
    super.initState();
    _editingArticle = widget.article;

    _headlineController = TextEditingController(text: _editingArticle.title);
    _bodyController = TextEditingController(text: _editingArticle.content);
    _imageUrl = _editingArticle.thumbnailUrl;

    // Cargar tags en el Cubit
    if (_editingArticle.tagIds != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context
            .read<LocalArticleCubit>()
            .onTagsChanged(_editingArticle.tagIds!);
      });
    }

    _headlineController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _headlineController.dispose();
    _bodyController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null) {
        setState(() {
          _imageBytes = result.files.single.bytes;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _onUpdatePressed() {
    final currentState = context.read<LocalArticleCubit>().state;
    final currentTags = currentState.tempTags ?? [];

    final updatedArticle = _editingArticle.copyWith(
      title: _headlineController.text.trim(),
      content: _bodyController.text.trim(),
      tagIds: currentTags,
    );

    context.read<LocalArticleCubit>().onPublishArticle(
          updatedArticle,
          imageBytes: _imageBytes,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<LocalArticleCubit, LocalArticleState>(
      listener: (context, state) {
        if (state.status == LocalArticleStatus.publishedSuccess) {
          NotificationService.show(
            context,
            title: "Article Updated!",
            message: "Changes saved successfully.",
          );
          Navigator.pop(context); 
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildHeader(theme, colorScheme),
                const SizedBox(height: 32),
                _buildImagePlaceholder(theme, colorScheme),
                const SizedBox(height: 32),
                _buildSectionLabel(theme, "STORY DETAILS"),
                const SizedBox(height: 16),
                _buildHeadlineInput(theme),
                const SizedBox(height: 24),
                _buildTagsSection(theme, colorScheme),
                const SizedBox(height: 32),
                _buildSectionLabel(theme, "ARTICLE BODY"),
                const SizedBox(height: 8),
                _buildBodyInput(theme),
                const SizedBox(height: kIsWeb ? 80 : 48),
                _buildUpdateButton(colorScheme),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
        bottomNavigationBar:
            const KineticNavigationBar(currentRoute: '/ManageArticle'),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("EDITORIAL REVISION",
                style: TextStyle(
                    color: colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
            Text("Edit Article",
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontSize: 28, fontWeight: FontWeight.w900)),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder(ThemeData theme, ColorScheme colorScheme) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dynamicHeight = (screenWidth * 0.3).clamp(180.0, 320.0);
    final isWideScreen = screenWidth > 1100;

    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          constraints:
              BoxConstraints(maxWidth: isWideScreen ? 800 : double.infinity),
          width: double.infinity,
          height: dynamicHeight,
          decoration: BoxDecoration(
            color: colorScheme.tertiary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            image: _imageBytes != null
                ? DecorationImage(
                    image: MemoryImage(_imageBytes!), fit: BoxFit.cover)
                : (_imageUrl != null)
                    ? DecorationImage(
                        image: NetworkImage(_imageUrl!), fit: BoxFit.cover)
                    : null,
          ),
          child: (_imageBytes == null && _imageUrl == null)
              ? const Icon(Icons.add_a_photo_outlined, size: 40)
              : null,
        ),
      ),
    );
  }

  Widget _buildHeadlineInput(ThemeData theme) {
    return TextField(
      controller: _headlineController,
      style:
          theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
      decoration: const InputDecoration(
          hintText: "Enter headline...", border: InputBorder.none),
    );
  }

  Widget _buildTagsSection(ThemeData theme, ColorScheme colorScheme) {
    return BlocBuilder<LocalArticleCubit, LocalArticleState>(
      builder: (context, state) {
        final tags = state.tempTags ?? [];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              children: tags
                  .map((tag) => Chip(
                        label: Text(tag),
                        onDeleted: () {
                          final newTags = List<String>.from(tags)..remove(tag);
                          context
                              .read<LocalArticleCubit>()
                              .onTagsChanged(newTags);
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _tagController,
              decoration: InputDecoration(
                hintText: "Add tags (press Enter)...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (_tagController.text.isNotEmpty) {
                      final newTags = List<String>.from(tags)
                        ..add(_tagController.text.trim());
                      context.read<LocalArticleCubit>().onTagsChanged(newTags);
                      _tagController.clear();
                    }
                  },
                ),
              ),
              onSubmitted: (val) {
                if (val.isNotEmpty) {
                  final newTags = List<String>.from(tags)..add(val.trim());
                  context.read<LocalArticleCubit>().onTagsChanged(newTags);
                  _tagController.clear();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBodyInput(ThemeData theme) {
    return TextField(
      controller: _bodyController,
      maxLines: null,
      decoration: const InputDecoration(
          hintText: "Start writing...", border: InputBorder.none),
    );
  }

  Widget _buildUpdateButton(ColorScheme colorScheme) {
    final isEnabled = _headlineController.text.isNotEmpty;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5C79FF),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: isEnabled ? _onUpdatePressed : null,
        child: const Text("SAVE CHANGES",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionLabel(ThemeData theme, String label) {
    return Text(label,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey));
  }
}

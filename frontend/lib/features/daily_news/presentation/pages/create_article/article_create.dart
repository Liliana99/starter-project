import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_architecture/core/services/notification_service.dart';
import 'package:news_app_clean_architecture/features/daily_news/domain/entities/article.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_cubit.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/bloc/article/local/local_article_state.dart';
import 'package:news_app_clean_architecture/features/daily_news/presentation/widgets/navigation_bar.dart';

class CreateArticlePage extends StatefulWidget {
  const CreateArticlePage({super.key});

  @override
  State<CreateArticlePage> createState() => _CreateArticlePageState();
}

class _CreateArticlePageState extends State<CreateArticlePage> {
  final TextEditingController _headlineController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  String? _imageUrl;
  Uint8List? _imageBytes; // Para soporte Web
  ArticleEntity? _editingArticle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is ArticleEntity) {
        setState(() {
          _editingArticle = args;
          _headlineController.text = args.title ?? "";
          _bodyController.text = args.content ?? "";
          _imageUrl = args.thumbnailUrl;
        });

        if (args.tagIds != null) {
          context.read<LocalArticleCubit>().onTagsChanged(args.tagIds!);
        }
      }
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
        withData: true, // Importante para Web
      );

      if (result != null) {
        setState(() {
          _imageBytes = result.files.single.bytes;
          _imageUrl = result
              .files.single.name; // Usamos el nombre como referencia temporal
        });
      }
    } catch (e) {
      NotificationService.show(
        context,
        title: "Error",
        message: "Could not open file picker",
        isError: true,
      );
    }
  }

  void _onPublishPressed() {
    if (_headlineController.text.trim().isEmpty) {
      _showErrorSnackBar("Please enter a headline");
      return;
    }
    if (_bodyController.text.trim().isEmpty) {
      _showErrorSnackBar("The article body cannot be empty");
      return;
    }

    final currentState = context.read<LocalArticleCubit>().state;
    final currentTags = currentState.tempTags ?? [];

    final article = ArticleEntity(
      id: _editingArticle?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _headlineController.text.trim(),
      content: _bodyController.text.trim(),
      createdAt: _editingArticle?.createdAt ?? DateTime.now(),
      status: "published",
      tagIds: currentTags,
      thumbnailUrl: _imageUrl,
      authorId: "paco_editor_1",
    );

    // Si hay bytes de imagen, se los pasamos al Cubit para que los suba
    if (_imageBytes != null) {
      context
          .read<LocalArticleCubit>()
          .onPublishArticle(article, imageBytes: _imageBytes);
    } else {
      context.read<LocalArticleCubit>().onPublishArticle(article);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<LocalArticleCubit, LocalArticleState>(
      listener: (context, state) {
        if (state.status == LocalArticleStatus.success) {
          NotificationService.show(
            context,
            title: "Article Published Successfully!",
            message: "Your story is now live on the feed.",
          );
          Navigator.pop(context);
        }

        if (state.status == LocalArticleStatus.error) {
          NotificationService.show(
            context,
            isError: true,
            title: "Error: Connection lost",
            message: state.errorMessage ?? "Could not sync with server.",
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        extendBody: true,
        appBar: AppBar(
          leading: Icon(Icons.menu, color: colorScheme.primary),
          title: Text(
            "THE KINETIC",
            style: theme.appBarTheme.titleTextStyle,
          ),
        ),
        body: BlocBuilder<LocalArticleCubit, LocalArticleState>(
          builder: (context, state) {
            final isLoading = state.status == LocalArticleStatus.loading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildDraftHeader(theme, colorScheme),
                  const SizedBox(height: 24),
                  _buildImagePlaceholder(theme, colorScheme),
                  const SizedBox(height: 32),
                  _buildSectionLabel(theme, "HEADLINE"),
                  const SizedBox(height: 8),
                  _buildHeadlineInput(theme, colorScheme),
                  const SizedBox(height: 24),
                  _buildTagsSection(theme, colorScheme, state),
                  const SizedBox(height: 32),
                  _buildSectionLabel(theme, "ARTICLE BODY"),
                  const SizedBox(height: 8),
                  _buildBodyInput(theme, colorScheme),
                  const SizedBox(height: 48),
                  _buildPublishButton(colorScheme, isLoading),
                  const SizedBox(height: 150),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar:
            const KineticNavigationBar(currentRoute: '/CreateArticle'),
      ),
    );
  }

  Widget _buildDraftHeader(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "KINETIC EDITOR",
              style: TextStyle(
                color: colorScheme.tertiary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.1,
              ),
            ),
            Text(
              "Publish Article",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 28,
                color: const Color(0xFF1A1A2E),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder(ThemeData theme, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: colorScheme.tertiary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          image: _imageBytes != null
              ? DecorationImage(
                  image: MemoryImage(_imageBytes!),
                  fit: BoxFit.cover,
                )
              : (_imageUrl != null && _imageUrl!.startsWith('http'))
                  ? DecorationImage(
                      image: NetworkImage(_imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
          border: Border.all(
            color: colorScheme.tertiary.withOpacity(
                _imageUrl != null || _imageBytes != null ? 0 : 0.2),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
        child: (_imageUrl == null && _imageBytes == null)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: colorScheme.tertiary.withOpacity(0.1),
                    child: Icon(Icons.camera_alt, color: colorScheme.primary),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "ADD COVER IMAGE",
                    style: TextStyle(
                      color: Color(0xFF5D5D81),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  Widget _buildSectionLabel(ThemeData theme, String label) {
    return Text(
      label,
      style: TextStyle(
        color: theme.colorScheme.tertiary,
        fontWeight: FontWeight.bold,
        fontSize: 11,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildHeadlineInput(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.tertiary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _headlineController,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter a bold, punchy headline",
          hintStyle: TextStyle(color: colorScheme.tertiary.withOpacity(0.4)),
        ),
      ),
    );
  }

  Widget _buildTagsSection(
      ThemeData theme, ColorScheme colorScheme, LocalArticleState state) {
    final currentTags = state.tempTags ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Etiquetas ya seleccionadas (Wrap)
        if (currentTags.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: currentTags
                .map((tag) => Chip(
                      backgroundColor: colorScheme.primary.withOpacity(0.1),
                      side: BorderSide.none,
                      label: Text("#$tag",
                          style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12)),
                      onDeleted: () {
                        final newTags = List<String>.from(currentTags)
                          ..remove(tag);
                        context
                            .read<LocalArticleCubit>()
                            .onTagsChanged(newTags);
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
        ],

        if (state.allAvailableTags.isNotEmpty) ...[
          _buildSectionLabel(theme, "SUGGESTED TAGS"),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: state.allAvailableTags.map((tag) {
                final isSelected = currentTags.contains(tag);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        _addTagToState(tag, currentTags);
                      } else {
                        final newTags = List<String>.from(currentTags)
                          ..remove(tag);
                        context
                            .read<LocalArticleCubit>()
                            .onTagsChanged(newTags);
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // 3. Campo para agregar tag personalizado
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.tertiary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _tagController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add custom tag...",
                  ),
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) {
                      _addTagToState(val.trim().toUpperCase(), currentTags);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                if (_tagController.text.isNotEmpty) {
                  _addTagToState(
                      _tagController.text.trim().toUpperCase(), currentTags);
                }
              },
              icon: CircleAvatar(
                backgroundColor: colorScheme.primary,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _addTagToState(String tag, List<String> currentTags) {
    if (!currentTags.contains(tag)) {
      final newTags = List<String>.from(currentTags)..add(tag);
      context.read<LocalArticleCubit>().onTagsChanged(newTags);
    }
    _tagController.clear();
  }

  Widget _buildBodyInput(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.surface),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        controller: _bodyController,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Start your story here...",
          hintStyle: TextStyle(color: Colors.grey[300]),
        ),
      ),
    );
  }

  Widget _buildPublishButton(ColorScheme colorScheme, bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : _onPublishPressed,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2),
              )
            : const Icon(Icons.cloud_upload_outlined, size: 20),
        label: Text(
          isLoading ? "PUBLISHING..." : "PUBLISH ARTICLE",
          style:
              const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5C79FF),
          foregroundColor: Colors.white,
          elevation: isLoading ? 0 : 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}

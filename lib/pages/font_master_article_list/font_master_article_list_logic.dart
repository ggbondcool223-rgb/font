import 'package:get/get.dart';
import '../../db_font_master/data.dart';
import '../../utils/index.dart';

class FontMasterArticleListLogic extends GetxController {
  final _db = FontMasterDatabase();

  // State management
  final articles = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final isRefreshing = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadArticles();
  }

  Future<void> loadArticles() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Load articles from database
      final articleEntities = await _db.getAllArticles();

      // Convert to display format
      articles.value = articleEntities.map((article) {
        return {
          'article_id': article.articleId,
          'title': article.title,
          'words': article.wordCount != null
              ? '${article.wordCount} words'
              : '200 words',
          'readTime': _calculateReadTime(article.wordCount ?? 200),
          'excerpt': article.summary ?? _generateExcerpt(article.content),
          'tags': _getTags(article.category),
          'category': article.category ?? 'General',
        };
      }).toList();

      // Check if articles list is empty
      if (articles.isEmpty) {
        errorMessage.value = 'No articles found';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load articles. Please try again.';
      errorToast('Failed to load articles');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    try {
      isRefreshing.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Reload articles
      final articleEntities = await _db.getAllArticles();

      articles.value = articleEntities.map((article) {
        return {
          'article_id': article.articleId,
          'title': article.title,
          'words': article.wordCount != null
              ? '${article.wordCount} words'
              : '200 words',
          'readTime': _calculateReadTime(article.wordCount ?? 200),
          'excerpt': article.summary ?? _generateExcerpt(article.content),
          'tags': _getTags(article.category),
          'category': article.category ?? 'General',
        };
      }).toList();

      successToast('Articles refreshed');
    } catch (e) {
      errorToast('Failed to refresh articles');
    } finally {
      isRefreshing.value = false;
    }
  }

  String _calculateReadTime(int wordCount) {
    final minutes = (wordCount / 200)
        .ceil(); // Average reading speed: 200 words/min
    if (minutes <= 1) {
      return '1 min read';
    }
    return '$minutes min read';
  }

  List<String> _getTags(String? category) {
    final tags = <String>[];
    if (category != null && category.isNotEmpty) {
      tags.add(category);
    }
    tags.add('Font Test');
    return tags;
  }

  String _generateExcerpt(String content) {
    if (content.length <= 100) {
      return content;
    }
    return '${content.substring(0, 100)}...';
  }

  void openArticle(String articleId, String title) {
    try {
      Get.toNamed(
        '/article_reading',
        arguments: {'article_id': articleId, 'title': title},
      );
    } catch (e) {
      errorToast('Failed to open article');
    }
  }

  Future<void> retryLoad() async {
    await loadArticles();
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db_font_master/data.dart';
import '../../utils/font_loader_service.dart';

class FontMasterArticleReadingLogic extends GetxController {
  final _db = FontMasterDatabase();

  // Article data
  final articleId = ''.obs;
  final articleTitle = ''.obs;
  final articleContent = ''.obs;
  final isLoading = true.obs;

  // Font selection
  final currentFont = 'System Default'.obs;
  final currentFontSource = 'System'.obs;
  final currentFontPath = ''.obs;
  final selectedFontId = 'system'.obs;
  final availableFonts = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      isLoading.value = true;
      final args = Get.arguments as Map<String, dynamic>?;
      
      if (args == null) {
        Get.back();
        return;
      }

      articleId.value = args['article_id'] as String;
      articleTitle.value = args['title'] as String? ?? '';

      await Future.wait([
        _loadArticleContent(),
        _loadCurrentFont(),
        _loadAvailableFonts(),
      ]);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadArticleContent() async {
    try {
      final article = await _db.getArticleById(articleId.value);
      if (article != null) {
        articleContent.value = article.content;
      }
    } catch (e) {
    }
  }

  Future<void> _loadCurrentFont() async {
    try {
      final fontId = await _db.getSetting('current_font_id');
      final fontName = await _db.getSetting('current_font_name');
      final fontPath = await _db.getSetting('current_font_path');
      final fontSource = await _db.getSetting('current_font_source');

      if (fontId != null) {
        selectedFontId.value = fontId;
        currentFont.value = fontName ?? 'System Default';
        currentFontPath.value = fontPath ?? '';
        currentFontSource.value = _getFontSourceDisplay(fontSource);
      }
    } catch (e) {
    }
  }

  Future<void> _loadAvailableFonts() async {
    try {
      // Add system default font
      availableFonts.add({
        'font_id': 'system',
        'font_name': 'System Default',
        'source': 'System',
        'font_path': '',
      });

      // Add builtin fonts
      final builtinFonts = await _db.getAllFonts();
      for (final font in builtinFonts) {
        availableFonts.add({
          'font_id': font.fontId,
          'font_name': font.fontName,
          'source': font.category ?? 'Builtin',
          'font_path': font.fontPath,
        });
      }

      // Custom fonts feature has been removed
      // No longer loading custom fonts

    } catch (e) {
    }
  }

  Future<void> selectFont(String fontId) async {
    try {
      final font = availableFonts.firstWhere(
        (f) => f['font_id'] == fontId,
        orElse: () => availableFonts.first,
      );

      final fontName = font['font_name'] as String;
      final fontPath = font['font_path'] as String? ?? '';

      // Dynamically load font if needed
      if (fontPath.isNotEmpty && fontId != 'system') {
        await FontLoaderService.loadFont(fontName, fontPath);
      }

      selectedFontId.value = fontId;
      currentFont.value = fontName;
      currentFontSource.value = font['source'] as String;
      currentFontPath.value = fontPath;

      Get.back(); // Close font selector
    } catch (e) {
    }
  }

  void showFontSelector() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Font',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: availableFonts.length,
                itemBuilder: (context, index) {
                  final font = availableFonts[index];
                  final fontId = font['font_id'] as String;
                  final isSelected = selectedFontId.value == fontId;

                  return ListTile(
                    title: Text(font['font_name'] as String),
                    subtitle: Text(font['source'] as String),
                    trailing: isSelected
                        ? Icon(Icons.check, color: Colors.blue)
                        : null,
                    selected: isSelected,
                    onTap: () => selectFont(fontId),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  String _getFontSourceDisplay(String? source) {
    switch (source) {
      case 'builtin':
        return 'Builtin';
      case 'custom':
        return 'Custom';
      case 'local':
        return 'Local';
      default:
        return 'System';
    }
  }
}


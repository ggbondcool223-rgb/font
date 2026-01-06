import 'package:get/get.dart';
import '../../db_font_master/data.dart';
import '../../db_font_master/db_font_master_helper.dart';
import '../../utils/font_loader_service.dart';

class FontMasterHomeLogic extends GetxController {
  final _db = FontMasterDatabase();
  final _dbHelper = FontMasterDatabaseHelper();

  final selectedCategory = 'Latest'.obs;
  final isLoading = true.obs;
  final fonts = <Map<String, dynamic>>[].obs;
  final allFontsFromAllSources = <Map<String, dynamic>>[].obs;

  final categories = [
    'Latest',
    'Featured',
    'Classic',
    'Cute',
    'Handwriting',
    'Custom',
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    try {
      isLoading.value = true;
      await _dbHelper.initializePresetData();
      await loadFonts();
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFonts() async {
    try {
      final allFonts = await _db.getAllFontsFromAllSources();
      allFontsFromAllSources.value = allFonts;

      _filterFontsByCategory();

      _preloadVisibleFonts();
    } catch (e) {
    }
  }

  Future<void> _preloadVisibleFonts() async {
    try {
      final builtinFonts = fonts
          .where((font) => font['source'] == 'builtin' && font['name'] != null)
          .take(10)
          .toList();
      for (final font in builtinFonts) {
        final fontName = font['name'] as String;

        final fontEntity = await _db.getFontById(font['font_id'] as String);
        if (fontEntity != null && fontEntity.fontPath.isNotEmpty) {
          FontLoaderService.loadFont(fontName, fontEntity.fontPath).catchError((
            e,
          ) {
            return false;
          });
        }
      }
    } catch (e) {
    }
  }

  void _filterFontsByCategory() {
    try {
      final category = selectedCategory.value;

      if (category == 'Latest') {
        fonts.value = allFontsFromAllSources.map((font) {
          return _mapFontToDisplay(font);
        }).toList();
      } else if (category == 'Custom') {
        fonts.value = allFontsFromAllSources
            .where((font) {
              final source = font['source'] as String;
              return source == 'custom';
            })
            .map((font) {
              return _mapFontToDisplay(font);
            })
            .toList();
      } else if (category == 'Local') {
        fonts.value = allFontsFromAllSources
            .where((font) {
              final source = font['source'] as String;
              return source == 'local';
            })
            .map((font) {
              return _mapFontToDisplay(font);
            })
            .toList();
      } else {
        _loadFontsByCategory(category);
      }
    } catch (e) {
    }
  }

  Future<void> _loadFontsByCategory(String category) async {
    try {
      final categoryFonts = await _db.getFontsByCategory(category);
      fonts.value = categoryFonts.map((font) {
        return {
          'font_id': font.fontId,
          'name': font.fontName,
          'category': font.category ?? '',
          'badge': null,
          'source': 'builtin',
          'preview_image': font.previewImage,
          'font_path': font.fontPath,
        };
      }).toList();
    } catch (e) {
    }
  }

  Map<String, dynamic> _mapFontToDisplay(Map<String, dynamic> font) {
    final source = font['source'] as String;
    String? badge;

    if (source == 'custom') {
      badge = 'Custom';
    } else if (source == 'local') {
      badge = 'Local';
    }

    return {
      'font_id': font['font_id'],
      'name': font['font_name'],
      'category':
          font['category'] ??
          (source == 'builtin'
              ? 'Featured'
              : (source == 'custom' ? 'User Created' : 'Local Install')),
      'badge': badge,
      'source': source,
      'preview_image': font['preview_image'],
    };
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    _filterFontsByCategory();
  }

  Future<void> refreshFonts() async {
    await loadFonts();
  }
}

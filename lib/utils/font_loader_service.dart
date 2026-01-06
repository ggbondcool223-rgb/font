import 'package:flutter/services.dart';

class FontLoaderService {
  static final Map<String, bool> _loadedFonts = {};

  static Future<bool> loadFont(String fontFamily, String assetPath) async {
    if (_loadedFonts[fontFamily] == true) {
      return true;
    }

    try {
      final fontLoader = FontLoader(fontFamily);
      final fontData = await rootBundle.load(assetPath);
      fontLoader.addFont(Future.value(fontData.buffer.asByteData()));
      await fontLoader.load();
      _loadedFonts[fontFamily] = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> preloadFonts(List<Map<String, String>> fonts) async {
    final futures = fonts.map((font) {
      return loadFont(font['family']!, font['path']!);
    }).toList();
    
    await Future.wait(futures);
  }

  static bool isFontLoaded(String fontFamily) {
    return _loadedFonts[fontFamily] == true;
  }

  static void clearCache() {
    _loadedFonts.clear();
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../db_font_master/data.dart';
import 'font_loader_service.dart';

class ThemeService extends GetxService {
  final _db = FontMasterDatabase();
  final currentFontFamily = Rx<String?>(null);
  
  Future<ThemeService> init() async {
    await _loadCurrentFont();
    return this;
  }
  
  Future<void> _loadCurrentFont() async {
    try {
      final fontName = await _db.getSetting('current_font_name');
      final fontPath = await _db.getSetting('current_font_path');
      
      if (fontName != null && fontName.isNotEmpty && 
          fontPath != null && fontPath.isNotEmpty) {
        await FontLoaderService.loadFont(fontName, fontPath);
        currentFontFamily.value = fontName;
      }
    } catch (e) {
    }
  }
  
  Future<void> applyFont(String fontName, String fontPath) async {
    try {
      await FontLoaderService.loadFont(fontName, fontPath);
      currentFontFamily.value = fontName;
      Get.forceAppUpdate();
    } catch (e) {
      rethrow;
    }
  }
  
  Future<void> resetFont() async {
    currentFontFamily.value = null;
    Get.forceAppUpdate();
  }
  
  TextTheme getTextTheme(TextTheme baseTheme) {
    if (currentFontFamily.value == null) {
      return baseTheme;
    }
    
    return baseTheme.apply(fontFamily: currentFontFamily.value);
  }
}


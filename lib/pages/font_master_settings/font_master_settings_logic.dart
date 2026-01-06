import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../db_font_master/data.dart';
import '../../db_font_master/db_font_master_helper.dart';
import '../../utils/font_loader_service.dart';

class FontMasterSettingsLogic extends GetxController {
  final _db = FontMasterDatabase();
  final _dbHelper = FontMasterDatabaseHelper();

  final currentFont = 'System Default'.obs;
  final currentFontCategory = 'System'.obs;
  final downloadedFontsCount = 0.obs;
  final cacheSize = '0 MB'.obs;
  final appVersion = 'v1.0.0'.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      isLoading.value = true;
      await Future.wait([
        _loadCurrentFont(),
        _loadDownloadedFontsCount(),
        _loadCacheSize(),
        _loadAppVersion(),
      ]);
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCurrentFont() async {
    try {
      final fontName = await _db.getSetting('current_font_name');
      final fontSource = await _db.getSetting('current_font_source');
      final fontPath = await _db.getSetting('current_font_path');
      
      if (fontName != null && fontName.isNotEmpty) {
        currentFont.value = fontName;
        
        // Dynamically load font for preview
        if (fontPath != null && fontPath.isNotEmpty) {
          await FontLoaderService.loadFont(fontName, fontPath);
        }
        
        // Set category based on source
        if (fontSource == 'custom') {
          currentFontCategory.value = 'Custom';
        } else if (fontSource == 'local') {
          currentFontCategory.value = 'Local';
        } else if (fontSource == 'builtin') {
          // Try to get category from database
          final fontId = await _db.getSetting('current_font_id');
          if (fontId != null) {
            final font = await _db.getFontById(fontId);
            currentFontCategory.value = font?.category ?? 'Builtin';
          }
        } else {
          currentFontCategory.value = 'System';
        }
      } else {
        currentFont.value = 'System Default';
        currentFontCategory.value = 'System';
      }
    } catch (e) {
    }
  }

  Future<void> _loadDownloadedFontsCount() async {
    try {
      final count = await _db.getDownloadedFontsCount();
      downloadedFontsCount.value = count;
    } catch (e) {
    }
  }

  Future<void> _loadCacheSize() async {
    try {
      // For now, just show 0 MB as we don't track actual cache size
      cacheSize.value = '0 MB';
    } catch (e) {
    }
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      appVersion.value = 'v${packageInfo.version}';
    } catch (e) {
      appVersion.value = 'v1.0.0';
    }
  }

  void onCurrentFontTap() {
    // Navigate to home page with current font selected
    Get.offAllNamed('/master_tab', arguments: {'initialTab': 0});
  }

  void onDownloadedFontsTap() {
    // Navigate to home page filtered by downloaded fonts
    Get.offAllNamed('/master_tab', arguments: {'initialTab': 0});
  }

  Future<void> onClearAllDataTap() async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'This will delete all downloaded fonts, custom fonts, and settings. This action cannot be undone.\n\nAre you sure you want to continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
      barrierDismissible: true,
    );

    if (confirmed == true) {
      await _clearAllData();
    }
  }

  Future<void> _clearAllData() async {
    try {
      await _dbHelper.resetDatabase();
      _showSuccess('All data cleared successfully');
      
      // Reload settings
      await _loadSettings();
    } catch (e) {
      _showError('Failed to clear data');
    }
  }

  Future<void> refreshSettings() async {
    await _loadSettings();
  }

  void _showSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}


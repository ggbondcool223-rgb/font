import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../db_font_master/data.dart';
import '../../utils/font_loader_service.dart';
import '../../utils/index.dart';
import '../../utils/theme_service.dart';

class FontMasterFontDetailLogic extends GetxController {
  final _db = FontMasterDatabase();

  // Font data
  final fontId = ''.obs;
  final fontName = ''.obs;
  final fontCategory = ''.obs;
  final fontFileSize = 0.0.obs;
  final fontDescription = ''.obs;
  final fontSource = 'builtin'.obs; // builtin/custom/local

  // UI states
  final isLoading = true.obs;
  final isFontLoaded = false.obs; // Track if custom font is loaded
  final previewFontSize = 16.0.obs; // Article preview font size
  final defaultFontSize = 16.0; // Default font size
  final minFontSize = 12.0; // Minimum font size
  final maxFontSize = 24.0; // Maximum font size
  final isCurrentFont = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFontDetail();
  }

  Future<void> _loadFontDetail() async {
    try {
      isLoading.value = true;
      final args = Get.arguments as Map<String, dynamic>?;

      if (args == null) {
        Get.back();
        return;
      }

      fontId.value = args['font_id'] as String;
      fontName.value = args['font_name'] as String? ?? '';
      fontSource.value = args['source'] as String? ?? 'builtin';

      // Load font details from database based on source
      if (fontSource.value == 'builtin') {
        await _loadBuiltinFontDetails();
      } else if (fontSource.value == 'custom') {
        // Custom fonts feature has been removed
        errorToast('Custom fonts are no longer supported');
        Get.back();
        return;
      }

      // Check if this is the current app font
      await _checkIsCurrentFont();
    } catch (e) {
      errorToast('Failed to load font details');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadBuiltinFontDetails() async {
    final font = await _db.getFontById(fontId.value);
    if (font != null) {
      fontCategory.value = font.category ?? '';
      fontFileSize.value = font.fileSize ?? 0.0;
      fontDescription.value = font.description ?? '';

      // Dynamically load font for preview
      if (font.fontPath.isNotEmpty) {
        await FontLoaderService.loadFont(fontName.value, font.fontPath);
        isFontLoaded.value = true;
      }
    }
  }

  // _loadCustomFontDetails method removed - custom fonts feature no longer supported

  Future<void> _checkIsCurrentFont() async {
    try {
      final currentFontId = await _db.getSetting('current_font_id');
      isCurrentFont.value = currentFontId == fontId.value;
    } catch (e) {
      errorToast('Failed to check current font status');
    }
  }

  void decreaseFontSize() {
    if (previewFontSize.value > minFontSize) {
      previewFontSize.value = (previewFontSize.value - 2.0).clamp(
        minFontSize,
        maxFontSize,
      );
    }
  }

  void increaseFontSize() {
    if (previewFontSize.value < maxFontSize) {
      previewFontSize.value = (previewFontSize.value + 2.0).clamp(
        minFontSize,
        maxFontSize,
      );
    }
  }

  void resetFontSize() {
    previewFontSize.value = defaultFontSize;
  }

  Future<void> onDownloadTap() async {
    try {
      // For builtin fonts from assets, save to local storage
      if (fontSource.value == 'builtin') {
        // Get font details
        final font = await _db.getFontById(fontId.value);
        if (font == null || font.fontPath.isEmpty) {
          errorToast('Font file not found');
          return;
        }

        // Show loading message
        Get.snackbar(
          'Downloading',
          'Saving font file...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 1),
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          showProgressIndicator: true,
        );

        // Load font file from assets
        final ByteData data = await rootBundle.load(font.fontPath);
        final List<int> bytes = data.buffer.asUint8List();

        // Get application documents directory
        final Directory appDocDir = await getApplicationDocumentsDirectory();

        // Create fonts subdirectory if it doesn't exist
        final Directory fontsDir = Directory('${appDocDir.path}/fonts');
        if (!await fontsDir.exists()) {
          await fontsDir.create(recursive: true);
        }

        // Extract filename from path
        final String fileName = font.fontPath.split('/').last;
        final String filePath = '${fontsDir.path}/$fileName';

        // Write font file to local storage
        final File file = File(filePath);
        await file.writeAsBytes(bytes);

        // Update database download status
        await _db.updateFontDownloadStatus(fontId.value, true);

        // Show success message with file location
        successToast('Font saved to: ${fontsDir.path}');

      } else if (fontSource.value == 'custom') {
        // Custom fonts feature has been removed
        errorToast('Custom fonts are no longer supported');
        return;
      }
    } catch (e) {
      errorToast('Failed to download font');
    }
  }

  Future<void> onApplyToAppTap() async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Apply Font'),
        content: Text('Apply "${fontName.value}" to all app text?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Confirm'),
          ),
        ],
      ),
      barrierDismissible: true,
    );

    if (confirmed == true) {
      await _applyFont();
    }
  }

  Future<void> _applyFont() async {
    try {
      // Get font path based on source
      String fontPath = '';
      if (fontSource.value == 'builtin') {
        final font = await _db.getFontById(fontId.value);
        fontPath = font?.fontPath ?? '';
      } else if (fontSource.value == 'custom') {
        // Custom fonts feature has been removed
        errorToast('Custom fonts are no longer supported');
        return;
      }

      if (fontPath.isEmpty) {
        errorToast('Font file path not found');
        return;
      }

      // Save to settings
      await _db.setSetting('current_font_id', fontId.value);
      await _db.setSetting('current_font_name', fontName.value);
      await _db.setSetting('current_font_path', fontPath);
      await _db.setSetting('current_font_source', fontSource.value);

      // Apply font globally through theme service
      final themeService = Get.find<ThemeService>();
      await themeService.applyFont(fontName.value, fontPath);

      isCurrentFont.value = true;
      successToast('Font applied successfully. App will refresh.');
    } catch (e) {
      errorToast('Failed to apply font');
    }
  }
}

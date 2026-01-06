import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class CustomFontLoader {
  static final Map<String, bool> _loadedFonts = {};

  static Future<bool> loadFont(String fontPath, String fontFamily) async {
    try {
      if (_loadedFonts[fontFamily] == true) {
        return true;
      }

      final file = File(fontPath);
      if (!await file.exists()) {
        return false;
      }

      final bytes = await file.readAsBytes();
      final fontLoader = FontLoader(fontFamily);
      fontLoader.addFont(Future.value(ByteData.view(bytes.buffer)));
      await fontLoader.load();
      _loadedFonts[fontFamily] = true;
      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isFontLoaded(String fontFamily) {
    return _loadedFonts[fontFamily] == true;
  }

  static void unloadFont(String fontFamily) {
    _loadedFonts.remove(fontFamily);
  }

  static List<String> getLoadedFonts() {
    return _loadedFonts.keys.toList();
  }

  static Future<bool> shareFont(String fontPath, String fontName) async {
    try {
      final file = File(fontPath);
      if (!await file.exists()) {
        return false;
      }

      final result = await Share.shareXFiles(
        [XFile(fontPath)],
        subject: fontName,
        text: 'Custom font: $fontName',
      );

      return result.status == ShareResultStatus.success;
    } catch (e) {
      return false;
    }
  }

  static Future<String?> exportFont(String fontPath, String fontName) async {
    try {
      final sourceFile = File(fontPath);
      if (!await sourceFile.exists()) {
        return null;
      }

      Directory? targetDir;
      if (Platform.isAndroid) {
        targetDir = Directory('/storage/emulated/0/Download');
        if (!await targetDir.exists()) {
          targetDir = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        targetDir = await getApplicationDocumentsDirectory();
      }

      if (targetDir == null) {
        return null;
      }

      final fileName = '${fontName.replaceAll(' ', '_')}.ttf';
      final targetPath = '${targetDir.path}/$fileName';
      await sourceFile.copy(targetPath);
      return targetPath;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> installFontToSystem(
    String fontPath,
    String fontName,
  ) async {
    try {
      if (!Platform.isAndroid) {
        return false;
      }

      final exportedPath = await exportFont(fontPath, fontName);
      if (exportedPath == null) {
        return false;
      }

      await shareFont(exportedPath, fontName);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<FontFileInfo?> getFontInfo(String fontPath) async {
    try {
      final file = File(fontPath);
      if (!await file.exists()) {
        return null;
      }

      final stat = await file.stat();
      return FontFileInfo(
        path: fontPath,
        size: stat.size,
        modifiedTime: stat.modified,
      );
    } catch (e) {
      return null;
    }
  }
}

class FontFileInfo {
  final String path;
  final int size;
  final DateTime modifiedTime;

  FontFileInfo({
    required this.path,
    required this.size,
    required this.modifiedTime,
  });

  String get formattedSize {
    if (size < 1024) {
      return '$size B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }
}


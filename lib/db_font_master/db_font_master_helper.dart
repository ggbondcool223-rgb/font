import 'dart:convert';
import 'package:flutter/services.dart';
import 'data.dart';
import 'db_font_master_entity.dart';

class FontMasterDatabaseHelper {
  static final FontMasterDatabaseHelper _instance =
      FontMasterDatabaseHelper._internal();
  final FontMasterDatabase _db = FontMasterDatabase();

  factory FontMasterDatabaseHelper() => _instance;

  FontMasterDatabaseHelper._internal();

  Future<void> initializePresetData() async {
    final firstLaunch = await _db.getSetting('first_launch');
    if (firstLaunch != 'true') {
      return;
    }

    await _insertPresetFonts();
    await _insertPresetArticles();
    await _db.setSetting('first_launch', 'false');
  }

  Future<void> _insertPresetFonts() async {
    try {
      final String fontsDataJson = await rootBundle.loadString('assets/fonts_data.json');
      final Map<String, dynamic> fontsData = jsonDecode(fontsDataJson);
      final List<dynamic> fontsList = fontsData['fonts'] as List<dynamic>;

      final presetFonts = fontsList.map((fontJson) {
        return FontEntity(
          fontId: fontJson['font_id'] as String,
          fontName: fontJson['font_name'] as String,
          fontPath: fontJson['font_path'] as String,
          previewImage: fontJson['preview_image'] as String?,
          category: fontJson['category'] as String?,
          fileSize: (fontJson['file_size'] as num?)?.toDouble(),
          description: fontJson['description'] as String?,
          isDownloaded: (fontJson['is_downloaded'] as int?) ?? 1,
          createdAt: fontJson['created_at'] as int?,
        );
      }).toList();

      await _db.insertFonts(presetFonts);
    } catch (e) {
      await _insertFallbackFonts();
    }
  }

  Future<void> _insertFallbackFonts() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final fallbackFonts = [
      FontEntity(
        fontId: 'builtin_001',
        fontName: 'ABeeZee',
        fontPath: 'assets/fonts/classic/ABeeZee-Regular.ttf',
        previewImage: 'assets/font_previews/classic/ABeeZee-Regular.png',
        category: 'Classic',
        fileSize: 0.04,
        description: 'A classic style font',
        isDownloaded: 1,
        createdAt: now,
      ),
    ];
    await _db.insertFonts(fallbackFonts);
  }

  Future<void> _insertPresetArticles() async {
    final now = DateTime.now().millisecondsSinceEpoch;

    final presetArticles = [
      ArticleEntity(
        articleId: 'article_001',
        title: 'The Quick Brown Fox',
        content: '''The quick brown fox jumps over the lazy dog. 0123456789

This pangram contains every letter of the English alphabet at least once. It is commonly used to display font samples and test typewriters and computer keyboards.

ABCDEFGHIJKLMNOPQRSTUVWXYZ
abcdefghijklmnopqrstuvwxyz
0123456789

Special characters: !@#\$%^&*()_+-=[]{}|;:',.<>?/~`

The five boxing wizards jump quickly. Pack my box with five dozen liquor jugs. How vexingly quick daft zebras jump!''',
        wordCount: 95,
        summary: 'Classic pangram containing all English letters',
        category: 'English',
        createdAt: now,
      ),
      ArticleEntity(
        articleId: 'article_002',
        title: 'Lorem Ipsum',
        content: '''Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.

Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.

Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.''',
        wordCount: 120,
        summary: 'Classic Lorem Ipsum placeholder text',
        category: 'English',
        createdAt: now - 1000,
      ),
      ArticleEntity(
        articleId: 'article_003',
        title: 'Font Testing Sample',
        content: '''Font Testing Sample

UPPERCASE LETTERS:
ABCDEFGHIJKLMNOPQRSTUVWXYZ

Lowercase letters:
abcdefghijklmnopqrstuvwxyz

Numbers:
0 1 2 3 4 5 6 7 8 9

Punctuation and Symbols:
! @ # \$ % ^ & * ( ) _ + - = [ ] { } | ; : ' " , . < > ? / ~ `

Common Words:
The quick brown fox jumps over the lazy dog.
Pack my box with five dozen liquor jugs.
How razorback-jumping frogs can level six piqued gymnasts!

Mixed Case Sentences:
Typography is the art and technique of arranging type.
Beautiful fonts make reading a pleasure.
Every font tells a story through its unique design.''',
        wordCount: 140,
        summary: 'Comprehensive font testing sample with all characters',
        category: 'English',
        createdAt: now - 2000,
      ),
      ArticleEntity(
        articleId: 'article_004',
        title: 'Short Story Sample',
        content: '''Once upon a time, in a land far away, there lived a young artist who loved creating beautiful letters. Every day, the artist would practice drawing different styles of alphabets, from elegant serifs to playful scripts.

One day, the artist discovered that each letter had its own personality. The letter 'A' stood tall and proud, like a mountain peak. The letter 'S' curved gracefully, like a winding river. The letter 'O' was perfectly round, like the full moon on a clear night.

As time passed, the artist became known throughout the kingdom for creating the most beautiful fonts. People from all corners of the realm would come to commission custom typefaces for their books, signs, and manuscripts.

The artist learned that fonts were more than just letters on a page - they were a way to express emotions, convey meaning, and bring words to life. Each stroke, curve, and line told a story of its own.

And so, the artist continued to create, knowing that every font was a gift to readers everywhere, making their reading experience more beautiful and enjoyable.

The End.''',
        wordCount: 198,
        summary: 'A short story about typography and fonts',
        category: 'English',
        createdAt: now - 3000,
      ),
    ];

    await _db.insertArticles(presetArticles);
  }

  static List<String> getCharacterSet(String characterSetType) {
    switch (characterSetType) {
      case 'lowercase':
        return _getLowercaseCharacters();
      case 'with_uppercase':
        return _getWithUppercaseCharacters();
      case 'complete':
        return _getCompleteCharacters();
      default:
        return _getLowercaseCharacters();
    }
  }

  static List<String> _getLowercaseCharacters() {
    return List.generate(26, (index) => String.fromCharCode(97 + index));
  }

  static List<String> _getWithUppercaseCharacters() {
    final lowercase = _getLowercaseCharacters();
    final uppercase = List.generate(26, (index) => String.fromCharCode(65 + index));
    return [...lowercase, ...uppercase];
  }

  static List<String> _getCompleteCharacters() {
    final letters = _getWithUppercaseCharacters();
    final numbers = List.generate(10, (index) => index.toString());
    return [...letters, ...numbers];
  }

  static int getTotalCharsForSet(String characterSetType) {
    switch (characterSetType) {
      case 'lowercase':
        return 26;
      case 'with_uppercase':
        return 52;
      case 'complete':
        return 62;
      default:
        return 26;
    }
  }

  static String createStrokeDataJson(List<List<List<double>>> strokes,
      String penType, double penSize) {
    final strokesData = strokes.map((stroke) {
      return {
        'points': stroke,
        'pen_type': penType,
        'pen_size': penSize,
      };
    }).toList();

    return jsonEncode({'strokes': strokesData});
  }

  static Map<String, dynamic> parseStrokeDataJson(String strokeDataJson) {
    return jsonDecode(strokeDataJson) as Map<String, dynamic>;
  }

  static String generateProjectId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'custom_$timestamp';
  }

  static bool validateFontName(String name) {
    if (name.isEmpty) return false;
    if (name.length > 20) return false;
    return true;
  }

  static bool validateDescription(String description) {
    if (description.length > 100) return false;
    return true;
  }

  static double calculateFileSizeMB(int bytes) {
    return bytes / (1024 * 1024);
  }

  static String formatFileSize(double sizeMB) {
    if (sizeMB < 0.01) {
      return '< 0.01 MB';
    }
    return '${sizeMB.toStringAsFixed(2)} MB';
  }

  static String formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String getCategoryDisplayName(String category) {
    switch (category) {
      case 'Latest':
        return 'Latest';
      case 'Featured':
        return 'Featured';
      case 'Classic':
        return 'Classic';
      case 'Cute':
        return 'Cute';
      case 'Handwriting':
        return 'Handwriting';
      default:
        return category;
    }
  }

  static String getStatusDisplayName(String status) {
    switch (status) {
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'failed':
        return 'Failed';
      default:
        return status;
    }
  }

  static String getCharacterSetDisplayName(String characterSet) {
    switch (characterSet) {
      case 'lowercase':
        return 'Lowercase Only (26 characters)';
      case 'with_uppercase':
        return 'With Uppercase (52 characters)';
      case 'complete':
        return 'Complete Set (62 characters)';
      default:
        return characterSet;
    }
  }

  Future<void> resetDatabase() async {
    await _db.clearAllData();
    await _db.setSetting('first_launch', 'true');
    await initializePresetData();
  }
}

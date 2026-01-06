import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'db_font_master_entity.dart';

class FontMasterDatabase {
  static final FontMasterDatabase _instance = FontMasterDatabase._internal();
  static Database? _database;

  factory FontMasterDatabase() => _instance;

  FontMasterDatabase._internal();

  static const String _databaseName = 'fontmaster.db';
  static const int _databaseVersion = 1;

  static const String tableFonts = 'fonts';
  static const String tableAppSettings = 'app_settings';
  static const String tableArticles = 'articles';
  static const String tableGreetingCards = 'greeting_cards';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableFonts (
        font_id TEXT PRIMARY KEY,
        font_name TEXT NOT NULL,
        font_path TEXT NOT NULL,
        preview_image TEXT,
        category TEXT,
        file_size REAL,
        description TEXT,
        is_downloaded INTEGER DEFAULT 0,
        created_at INTEGER
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_fonts_category ON $tableFonts(category)',
    );
    await db.execute('CREATE INDEX idx_fonts_name ON $tableFonts(font_name)');

    await db.execute('''
      CREATE TABLE $tableAppSettings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableArticles (
        article_id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        word_count INTEGER,
        summary TEXT,
        category TEXT,
        created_at INTEGER NOT NULL
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_articles_category ON $tableArticles(category)',
    );

    await db.execute('''
      CREATE TABLE $tableGreetingCards (
        card_id TEXT PRIMARY KEY,
        template_id TEXT NOT NULL,
        text_boxes_data TEXT NOT NULL,
        background_color TEXT NOT NULL,
        image_path TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    await db.execute(
      'CREATE INDEX idx_greeting_cards_created ON $tableGreetingCards(created_at DESC)',
    );
    await db.execute(
      'CREATE INDEX idx_greeting_cards_template ON $tableGreetingCards(template_id)',
    );

    await _insertInitialSettings(db);
  }

  Future<void> _insertInitialSettings(Database db) async {
    await db.insert(tableAppSettings, {
      'key': 'current_font_id',
      'value': 'system',
    });
    await db.insert(tableAppSettings, {
      'key': 'current_font_name',
      'value': 'System Default',
    });
    await db.insert(tableAppSettings, {
      'key': 'current_font_path',
      'value': '',
    });
    await db.insert(tableAppSettings, {
      'key': 'current_font_source',
      'value': 'system',
    });
    await db.insert(tableAppSettings, {'key': 'search_history', 'value': '[]'});
    await db.insert(tableAppSettings, {'key': 'first_launch', 'value': 'true'});
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Currently no upgrade logic needed as we start from version 1
    // Future upgrades can be handled here
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(tableFonts);
    await db.delete(tableGreetingCards);
    await db.delete(tableArticles);
    await db.delete(tableAppSettings);
    await _insertInitialSettings(db);
  }

  Future<int> insertFont(FontEntity font) async {
    final db = await database;
    return await db.insert(
      tableFonts,
      font.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertFonts(List<FontEntity> fonts) async {
    final db = await database;
    final batch = db.batch();
    for (final font in fonts) {
      batch.insert(
        tableFonts,
        font.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<FontEntity?> getFontById(String fontId) async {
    final db = await database;
    final maps = await db.query(
      tableFonts,
      where: 'font_id = ?',
      whereArgs: [fontId],
    );
    if (maps.isEmpty) return null;
    return FontEntity.fromMap(maps.first);
  }

  Future<List<FontEntity>> getAllFonts() async {
    final db = await database;
    final maps = await db.query(tableFonts, orderBy: 'created_at DESC');
    return maps.map((map) => FontEntity.fromMap(map)).toList();
  }

  Future<List<FontEntity>> getFontsByCategory(String category) async {
    final db = await database;
    final maps = await db.query(
      tableFonts,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => FontEntity.fromMap(map)).toList();
  }

  Future<List<FontEntity>> searchFonts(String keyword) async {
    final db = await database;
    final maps = await db.query(
      tableFonts,
      where: 'font_name LIKE ? OR category LIKE ? OR description LIKE ?',
      whereArgs: ['%$keyword%', '%$keyword%', '%$keyword%'],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => FontEntity.fromMap(map)).toList();
  }

  Future<int> updateFont(FontEntity font) async {
    final db = await database;
    return await db.update(
      tableFonts,
      font.toMap(),
      where: 'font_id = ?',
      whereArgs: [font.fontId],
    );
  }

  Future<int> updateFontDownloadStatus(String fontId, bool isDownloaded) async {
    final db = await database;
    return await db.update(
      tableFonts,
      {'is_downloaded': isDownloaded ? 1 : 0},
      where: 'font_id = ?',
      whereArgs: [fontId],
    );
  }

  Future<int> deleteFont(String fontId) async {
    final db = await database;
    return await db.delete(
      tableFonts,
      where: 'font_id = ?',
      whereArgs: [fontId],
    );
  }

  Future<int> getDownloadedFontsCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableFonts WHERE is_downloaded = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final maps = await db.query(
      tableAppSettings,
      where: 'key = ?',
      whereArgs: [key],
    );
    if (maps.isEmpty) return null;
    return maps.first['value'] as String;
  }

  Future<int> setSetting(String key, String value) async {
    final db = await database;
    return await db.insert(tableAppSettings, {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, String>> getAllSettings() async {
    final db = await database;
    final maps = await db.query(tableAppSettings);
    return Map.fromEntries(
      maps.map((map) => MapEntry(map['key'] as String, map['value'] as String)),
    );
  }

  Future<int> deleteSetting(String key) async {
    final db = await database;
    return await db.delete(
      tableAppSettings,
      where: 'key = ?',
      whereArgs: [key],
    );
  }

  Future<int> insertArticle(ArticleEntity article) async {
    final db = await database;
    return await db.insert(
      tableArticles,
      article.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertArticles(List<ArticleEntity> articles) async {
    final db = await database;
    final batch = db.batch();
    for (final article in articles) {
      batch.insert(
        tableArticles,
        article.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<ArticleEntity?> getArticleById(String articleId) async {
    final db = await database;
    final maps = await db.query(
      tableArticles,
      where: 'article_id = ?',
      whereArgs: [articleId],
    );
    if (maps.isEmpty) return null;
    return ArticleEntity.fromMap(maps.first);
  }

  Future<List<ArticleEntity>> getAllArticles() async {
    final db = await database;
    final maps = await db.query(tableArticles, orderBy: 'created_at DESC');
    return maps.map((map) => ArticleEntity.fromMap(map)).toList();
  }

  Future<List<ArticleEntity>> getArticlesByCategory(String category) async {
    final db = await database;
    final maps = await db.query(
      tableArticles,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => ArticleEntity.fromMap(map)).toList();
  }

  Future<int> updateArticle(ArticleEntity article) async {
    final db = await database;
    return await db.update(
      tableArticles,
      article.toMap(),
      where: 'article_id = ?',
      whereArgs: [article.articleId],
    );
  }

  Future<int> deleteArticle(String articleId) async {
    final db = await database;
    return await db.delete(
      tableArticles,
      where: 'article_id = ?',
      whereArgs: [articleId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllFontsFromAllSources() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT font_id, font_name, 'builtin' as source, created_at, preview_image, category FROM $tableFonts
      ORDER BY created_at DESC
    ''');
    return result;
  }

  Future<List<Map<String, dynamic>>> searchAllFonts(String keyword) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT font_id, font_name, 'builtin' as source, preview_image FROM $tableFonts
      WHERE font_name LIKE ? OR category LIKE ? OR description LIKE ?
      ORDER BY font_name ASC
    ''',
      ['%$keyword%', '%$keyword%', '%$keyword%'],
    );
    return result;
  }

  Future<int> insertGreetingCard(GreetingCardEntity card) async {
    final db = await database;
    return await db.insert(
      tableGreetingCards,
      card.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateGreetingCard(GreetingCardEntity card) async {
    final db = await database;
    return await db.update(
      tableGreetingCards,
      card.toMap(),
      where: 'card_id = ?',
      whereArgs: [card.cardId],
    );
  }

  Future<int> deleteGreetingCard(String cardId) async {
    final db = await database;
    return await db.delete(
      tableGreetingCards,
      where: 'card_id = ?',
      whereArgs: [cardId],
    );
  }

  Future<List<GreetingCardEntity>> getAllGreetingCards() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableGreetingCards,
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return GreetingCardEntity.fromMap(maps[i]);
    });
  }

  Future<GreetingCardEntity?> getGreetingCardById(String cardId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableGreetingCards,
      where: 'card_id = ?',
      whereArgs: [cardId],
    );

    if (maps.isEmpty) {
      return null;
    }

    return GreetingCardEntity.fromMap(maps.first);
  }
}

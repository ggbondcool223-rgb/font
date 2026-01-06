class FontEntity {
  final String fontId;
  final String fontName;
  final String fontPath;
  final String? previewImage;
  final String? category;
  final double? fileSize;
  final String? description;
  final int isDownloaded;
  final int? createdAt;

  FontEntity({
    required this.fontId,
    required this.fontName,
    required this.fontPath,
    this.previewImage,
    this.category,
    this.fileSize,
    this.description,
    this.isDownloaded = 0,
    this.createdAt,
  });

  factory FontEntity.fromMap(Map<String, dynamic> map) {
    return FontEntity(
      fontId: map['font_id'] as String,
      fontName: map['font_name'] as String,
      fontPath: map['font_path'] as String,
      previewImage: map['preview_image'] as String?,
      category: map['category'] as String?,
      fileSize: map['file_size'] as double?,
      description: map['description'] as String?,
      isDownloaded: map['is_downloaded'] as int? ?? 0,
      createdAt: map['created_at'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'font_id': fontId,
      'font_name': fontName,
      'font_path': fontPath,
      'preview_image': previewImage,
      'category': category,
      'file_size': fileSize,
      'description': description,
      'is_downloaded': isDownloaded,
      'created_at': createdAt,
    };
  }

  FontEntity copyWith({
    String? fontId,
    String? fontName,
    String? fontPath,
    String? previewImage,
    String? category,
    double? fileSize,
    String? description,
    int? isDownloaded,
    int? createdAt,
  }) {
    return FontEntity(
      fontId: fontId ?? this.fontId,
      fontName: fontName ?? this.fontName,
      fontPath: fontPath ?? this.fontPath,
      previewImage: previewImage ?? this.previewImage,
      category: category ?? this.category,
      fileSize: fileSize ?? this.fileSize,
      description: description ?? this.description,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AppSettingEntity {
  final String key;
  final String value;

  AppSettingEntity({
    required this.key,
    required this.value,
  });

  factory AppSettingEntity.fromMap(Map<String, dynamic> map) {
    return AppSettingEntity(
      key: map['key'] as String,
      value: map['value'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
    };
  }
}

class ArticleEntity {
  final String articleId;
  final String title;
  final String content;
  final int? wordCount;
  final String? summary;
  final String? category;
  final int createdAt;

  ArticleEntity({
    required this.articleId,
    required this.title,
    required this.content,
    this.wordCount,
    this.summary,
    this.category,
    required this.createdAt,
  });

  factory ArticleEntity.fromMap(Map<String, dynamic> map) {
    return ArticleEntity(
      articleId: map['article_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      wordCount: map['word_count'] as int?,
      summary: map['summary'] as String?,
      category: map['category'] as String?,
      createdAt: map['created_at'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'article_id': articleId,
      'title': title,
      'content': content,
      'word_count': wordCount,
      'summary': summary,
      'category': category,
      'created_at': createdAt,
    };
  }

  ArticleEntity copyWith({
    String? articleId,
    String? title,
    String? content,
    int? wordCount,
    String? summary,
    String? category,
    int? createdAt,
  }) {
    return ArticleEntity(
      articleId: articleId ?? this.articleId,
      title: title ?? this.title,
      content: content ?? this.content,
      wordCount: wordCount ?? this.wordCount,
      summary: summary ?? this.summary,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class GreetingCardEntity {
  final String cardId;
  final String templateId;
  final String textBoxesData;
  final String backgroundColor;
  final String? imagePath;
  final int createdAt;
  final int updatedAt;

  GreetingCardEntity({
    required this.cardId,
    required this.templateId,
    required this.textBoxesData,
    required this.backgroundColor,
    this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GreetingCardEntity.fromMap(Map<String, dynamic> map) {
    return GreetingCardEntity(
      cardId: map['card_id'] as String,
      templateId: map['template_id'] as String,
      textBoxesData: map['text_boxes_data'] as String,
      backgroundColor: map['background_color'] as String,
      imagePath: map['image_path'] as String?,
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'card_id': cardId,
      'template_id': templateId,
      'text_boxes_data': textBoxesData,
      'background_color': backgroundColor,
      'image_path': imagePath,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  GreetingCardEntity copyWith({
    String? cardId,
    String? templateId,
    String? textBoxesData,
    String? backgroundColor,
    String? imagePath,
    int? createdAt,
    int? updatedAt,
  }) {
    return GreetingCardEntity(
      cardId: cardId ?? this.cardId,
      templateId: templateId ?? this.templateId,
      textBoxesData: textBoxesData ?? this.textBoxesData,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      imagePath: imagePath ?? this.imagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

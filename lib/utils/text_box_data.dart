import 'dart:convert';

class TextBoxData {
  final String content;
  final String fontName;
  final String fontPath;
  final String textColor;
  final double textSize;
  final double positionX;
  final double positionY;

  TextBoxData({
    required this.content,
    required this.fontName,
    required this.fontPath,
    required this.textColor,
    required this.textSize,
    required this.positionX,
    required this.positionY,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'fontName': fontName,
      'fontPath': fontPath,
      'textColor': textColor,
      'textSize': textSize,
      'positionX': positionX,
      'positionY': positionY,
    };
  }

  factory TextBoxData.fromMap(Map<String, dynamic> map) {
    return TextBoxData(
      content: map['content'] as String? ?? '',
      fontName: map['fontName'] as String? ?? 'System Default',
      fontPath: map['fontPath'] as String? ?? '',
      textColor: map['textColor'] as String? ?? '#000000',
      textSize: (map['textSize'] as num?)?.toDouble() ?? 24.0,
      positionX: (map['positionX'] as num?)?.toDouble() ?? 0.5,
      positionY: (map['positionY'] as num?)?.toDouble() ?? 0.5,
    );
  }

  TextBoxData copyWith({
    String? content,
    String? fontName,
    String? fontPath,
    String? textColor,
    double? textSize,
    double? positionX,
    double? positionY,
  }) {
    return TextBoxData(
      content: content ?? this.content,
      fontName: fontName ?? this.fontName,
      fontPath: fontPath ?? this.fontPath,
      textColor: textColor ?? this.textColor,
      textSize: textSize ?? this.textSize,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
    );
  }

  static String listToJson(List<TextBoxData> textBoxes) {
    final list = textBoxes.map((box) => box.toMap()).toList();
    return jsonEncode(list);
  }

  static List<TextBoxData> listFromJson(String jsonString) {
    try {
      final List<dynamic> list = jsonDecode(jsonString);
      return list.map((item) => TextBoxData.fromMap(item as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }
}

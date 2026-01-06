import 'text_box_data.dart';

class CardTemplate {
  final String id;
  final String name;
  final String description;
  final String backgroundColor;
  final List<TextBoxData> textBoxes;

  CardTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.backgroundColor,
    required this.textBoxes,
  });

  CardTemplate copyWith({
    String? id,
    String? name,
    String? description,
    String? backgroundColor,
    List<TextBoxData>? textBoxes,
  }) {
    return CardTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textBoxes: textBoxes ?? this.textBoxes,
    );
  }
}


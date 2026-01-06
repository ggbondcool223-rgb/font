import 'card_template.dart';
import 'text_box_data.dart';

class CardTemplates {
  static List<CardTemplate> getAllTemplates() {
    return [
      birthdayTemplate,
      holidayTemplate,
      thankYouTemplate,
      loveTemplate,
      congratulationsTemplate,
      blankTemplate,
    ];
  }

  static CardTemplate? getTemplateById(String id) {
    try {
      return getAllTemplates().firstWhere((template) => template.id == id);
    } catch (e) {
      return null;
    }
  }

  static final CardTemplate birthdayTemplate = CardTemplate(
    id: 'birthday',
    name: 'Birthday',
    description: 'Happy Birthday wishes',
    backgroundColor: '#FFB6C1',
    textBoxes: [
      TextBoxData(
        content: 'Happy Birthday',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#FF1493',
        textSize: 36.0,
        positionX: 0.5,
        positionY: 0.25,
      ),
      TextBoxData(
        content: 'To [Name]',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#FF69B4',
        textSize: 28.0,
        positionX: 0.5,
        positionY: 0.5,
      ),
      TextBoxData(
        content: 'Wish you all the best!',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#C71585',
        textSize: 20.0,
        positionX: 0.5,
        positionY: 0.75,
      ),
    ],
  );

  static final CardTemplate holidayTemplate = CardTemplate(
    id: 'holiday',
    name: 'Holiday',
    description: 'Season greetings',
    backgroundColor: '#DC143C',
    textBoxes: [
      TextBoxData(
        content: 'Happy Holidays',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#FFFFFF',
        textSize: 36.0,
        positionX: 0.5,
        positionY: 0.25,
      ),
      TextBoxData(
        content: 'Season\'s Greetings',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#FFD700',
        textSize: 28.0,
        positionX: 0.5,
        positionY: 0.5,
      ),
      TextBoxData(
        content: 'From [Your Name]',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#FFFACD',
        textSize: 20.0,
        positionX: 0.5,
        positionY: 0.75,
      ),
    ],
  );

  static final CardTemplate thankYouTemplate = CardTemplate(
    id: 'thankyou',
    name: 'Thank You',
    description: 'Express gratitude',
    backgroundColor: '#87CEEB',
    textBoxes: [
      TextBoxData(
        content: 'Thank You',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#000080',
        textSize: 40.0,
        positionX: 0.5,
        positionY: 0.25,
      ),
      TextBoxData(
        content: 'For everything',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#4169E1',
        textSize: 26.0,
        positionX: 0.5,
        positionY: 0.5,
      ),
      TextBoxData(
        content: 'With appreciation',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#1E90FF',
        textSize: 20.0,
        positionX: 0.5,
        positionY: 0.75,
      ),
    ],
  );

  static final CardTemplate loveTemplate = CardTemplate(
    id: 'love',
    name: 'Love',
    description: 'Love and romance',
    backgroundColor: '#DDA0DD',
    textBoxes: [
      TextBoxData(
        content: 'I Love You',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#8B008B',
        textSize: 38.0,
        positionX: 0.5,
        positionY: 0.25,
      ),
      TextBoxData(
        content: 'Forever & Always',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#9370DB',
        textSize: 28.0,
        positionX: 0.5,
        positionY: 0.5,
      ),
      TextBoxData(
        content: '♥',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#FF1493',
        textSize: 32.0,
        positionX: 0.5,
        positionY: 0.75,
      ),
    ],
  );

  static final CardTemplate congratulationsTemplate = CardTemplate(
    id: 'congratulations',
    name: 'Congratulations',
    description: 'Celebrate achievements',
    backgroundColor: '#90EE90',
    textBoxes: [
      TextBoxData(
        content: 'Congratulations!',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#006400',
        textSize: 36.0,
        positionX: 0.5,
        positionY: 0.25,
      ),
      TextBoxData(
        content: 'Well Done',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#228B22',
        textSize: 30.0,
        positionX: 0.5,
        positionY: 0.5,
      ),
      TextBoxData(
        content: 'You did it!',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#32CD32',
        textSize: 24.0,
        positionX: 0.5,
        positionY: 0.75,
      ),
    ],
  );

  static final CardTemplate blankTemplate = CardTemplate(
    id: 'blank',
    name: 'Blank',
    description: 'Start from scratch',
    backgroundColor: '#FFFFFF',
    textBoxes: [
      TextBoxData(
        content: 'Title',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#000000',
        textSize: 32.0,
        positionX: 0.5,
        positionY: 0.25,
      ),
      TextBoxData(
        content: 'Content',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#000000',
        textSize: 24.0,
        positionX: 0.5,
        positionY: 0.5,
      ),
      TextBoxData(
        content: 'Signature',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#000000',
        textSize: 20.0,
        positionX: 0.5,
        positionY: 0.75,
      ),
    ],
  );
}

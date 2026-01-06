import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../db_font_master/data.dart';
import '../../db_font_master/db_font_master_entity.dart';
import '../../utils/color_utils.dart';
import '../../utils/image_saver.dart';
import '../../utils/index.dart';
import '../../utils/text_box_data.dart';
import '../../utils/card_template.dart';
import '../../utils/card_templates.dart';

class FontMasterCardEditorLogic extends GetxController {
  final String? cardId = Get.arguments as String?;

  // Template related
  final RxString selectedTemplateId = 'blank'.obs;
  final Rx<CardTemplate?> currentTemplate = Rx<CardTemplate?>(null);

  // 3 text boxes (each managed independently)
  final RxList<Rx<TextBoxData>> textBoxes = <Rx<TextBoxData>>[
    Rx<TextBoxData>(
      TextBoxData(
        content: '',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#000000',
        textSize: 24.0,
        positionX: 0.5,
        positionY: 0.5,
      ),
    ),
    Rx<TextBoxData>(
      TextBoxData(
        content: '',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#000000',
        textSize: 24.0,
        positionX: 0.5,
        positionY: 0.5,
      ),
    ),
    Rx<TextBoxData>(
      TextBoxData(
        content: '',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#000000',
        textSize: 24.0,
        positionX: 0.5,
        positionY: 0.5,
      ),
    ),
  ].obs;
  final RxInt selectedTextBoxIndex = 0.obs; // Currently editing text box

  // Background color (global)
  final Rx<Color> backgroundColor = Colors.white.obs;

  final RxBool isSaving = false.obs;
  final GlobalKey canvasKey = GlobalKey();

  final _db = FontMasterDatabase();

  @override
  void onInit() {
    super.onInit();
    if (cardId != null) {
      // Edit mode: load existing card data
      loadCardData(cardId!);
    } else {
      // Create mode: load birthday template by default
      loadTemplate('birthday');
    }
  }

  void loadTemplate(String templateId) {
    final template = CardTemplates.getTemplateById(templateId);
    if (template == null) return;

    selectedTemplateId.value = templateId;
    currentTemplate.value = template;
    backgroundColor.value = ColorUtils.hexToColor(template.backgroundColor);

    // Initialize 3 text boxes from template
    textBoxes.clear();
    for (final textBoxData in template.textBoxes) {
      textBoxes.add(Rx<TextBoxData>(textBoxData));
    }

    // Ensure we have exactly 3 text boxes
    while (textBoxes.length < 3) {
      textBoxes.add(
        Rx<TextBoxData>(
          TextBoxData(
            content: '',
            fontName: 'System Default',
            fontPath: '',
            textColor: '#000000',
            textSize: 24.0,
            positionX: 0.5,
            positionY: 0.5,
          ),
        ),
      );
    }
  }

  void switchTemplate(String templateId) {
    loadTemplate(templateId);
  }

  void selectTextBox(int index) {
    if (index >= 0 && index < textBoxes.length) {
      selectedTextBoxIndex.value = index;
    }
  }

  TextBoxData get currentTextBox {
    if (textBoxes.isEmpty || selectedTextBoxIndex.value >= textBoxes.length) {
      // Return default TextBoxData if list is empty or index is invalid
      return TextBoxData(
        content: '',
        fontName: 'System Default',
        fontPath: '',
        textColor: '#000000',
        textSize: 24.0,
        positionX: 0.5,
        positionY: 0.5,
      );
    }
    return textBoxes[selectedTextBoxIndex.value].value;
  }

  void updateTextContent(String content) {
    final index = selectedTextBoxIndex.value;
    textBoxes[index].value = currentTextBox.copyWith(content: content);
  }

  void updateFont(String fontName, String fontPath) {
    final index = selectedTextBoxIndex.value;
    textBoxes[index].value = currentTextBox.copyWith(
      fontName: fontName,
      fontPath: fontPath,
    );
  }

  void updateTextColor(Color color) {
    final index = selectedTextBoxIndex.value;
    textBoxes[index].value = currentTextBox.copyWith(
      textColor: ColorUtils.colorToHex(color),
    );
  }

  void updateTextSize(double size) {
    final index = selectedTextBoxIndex.value;
    textBoxes[index].value = currentTextBox.copyWith(textSize: size);
  }

  void updateTextPosition(int index, double x, double y) {
    if (index >= 0 && index < textBoxes.length) {
      textBoxes[index].value = textBoxes[index].value.copyWith(
        positionX: x,
        positionY: y,
      );
    }
  }

  void updateBackgroundColor(Color color) {
    backgroundColor.value = color;
  }

  Future<void> loadCardData(String id) async {
    try {
      final card = await _db.getGreetingCardById(id);
      if (card != null) {
        selectedTemplateId.value = card.templateId;
        backgroundColor.value = ColorUtils.hexToColor(card.backgroundColor);

        // Parse text boxes from JSON
        final loadedTextBoxes = TextBoxData.listFromJson(card.textBoxesData);

        textBoxes.clear();
        for (final textBoxData in loadedTextBoxes) {
          textBoxes.add(Rx<TextBoxData>(textBoxData));
        }

        // Ensure we have exactly 3 text boxes
        while (textBoxes.length < 3) {
          textBoxes.add(
            Rx<TextBoxData>(
              TextBoxData(
                content: '',
                fontName: 'System Default',
                fontPath: '',
                textColor: '#000000',
                textSize: 24.0,
                positionX: 0.5,
                positionY: 0.5,
              ),
            ),
          );
        }

        // Load template info
        currentTemplate.value = CardTemplates.getTemplateById(card.templateId);
      }
    } catch (e) {
      errorToast('Failed to load card data');
    }
  }

  Future<void> selectFont() async {
    try {
      // Get all preset fonts from database
      final fonts = await _db.getAllFonts();

      if (fonts.isEmpty) {
        errorToast('No fonts available');
        return;
      }

      // Show font selection dialog
      final selected = await Get.dialog<FontEntity>(
        Dialog(
          child: Container(
            constraints: BoxConstraints(maxHeight: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Select Font',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: fonts.length,
                    itemBuilder: (context, index) {
                      final font = fonts[index];
                      return ListTile(
                        title: Text(
                          font.fontName,
                          style: TextStyle(fontFamily: font.fontName),
                        ),
                        onTap: () => Get.back(result: font),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      if (selected != null) {
        updateFont(selected.fontName, selected.fontPath);
      }
    } catch (e) {
      errorToast('Failed to load fonts');
    }
  }

  Future<void> selectBackgroundColor() async {
    final color = await _showColorPicker(backgroundColor.value);
    if (color != null) {
      updateBackgroundColor(color);
    }
  }

  Future<void> selectTextColor() async {
    final currentColor = ColorUtils.hexToColor(currentTextBox.textColor);
    final color = await _showColorPicker(currentColor);
    if (color != null) {
      updateTextColor(color);
    }
  }

  Future<void> saveCard() async {
    // Validate input - at least one text box should have content
    final hasContent = textBoxes.any((box) => box.value.content.isNotEmpty);
    if (!hasContent) {
      errorToast('Please enter some text for your card');
      return;
    }

    isSaving.value = true;

    try {
      // Request permission
      final hasPermission = await ImageSaver.requestPermission();
      if (!hasPermission) {
        errorToast(
          'Permission denied. Please enable photo library access in settings.',
        );
        isSaving.value = false;
        return;
      }

      // Capture canvas as image
      await Future.delayed(
        Duration(milliseconds: 100),
      ); // Wait for UI to update
      final imageBytes = await captureCanvas();

      if (imageBytes == null) {
        errorToast('Failed to generate card image');
        isSaving.value = false;
        return;
      }

      // Save to gallery
      final fileName =
          'greeting_card_${DateTime.now().millisecondsSinceEpoch}.png';
      final saved = await ImageSaver.saveToGallery(imageBytes, fileName);

      if (!saved) {
        errorToast('Failed to save greeting card. Please try again.');
        isSaving.value = false;
        return;
      }

      // Serialize text boxes to JSON
      final textBoxesJson = TextBoxData.listToJson(
        textBoxes.map((box) => box.value).toList(),
      );

      // Save to database
      final now = DateTime.now().millisecondsSinceEpoch;
      final id = cardId ?? generateCardId();

      final card = GreetingCardEntity(
        cardId: id,
        templateId: selectedTemplateId.value,
        textBoxesData: textBoxesJson,
        backgroundColor: ColorUtils.colorToHex(backgroundColor.value),
        imagePath: fileName,
        createdAt: cardId == null
            ? now
            : (await _db.getGreetingCardById(id))?.createdAt ?? now,
        updatedAt: now,
      );

      if (cardId == null) {
        await _db.insertGreetingCard(card);
      } else {
        await _db.updateGreetingCard(card);
      }

      isSaving.value = false;

      Get.back(result: true);

      // Show success snackbar with icon
      Get.snackbar(
        'Success',
        'Greeting card saved to gallery successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.all(16.w),
        borderRadius: 8.r,
      );

      // Go back to list
    } catch (e) {
      errorToast('Failed to save greeting card. Please try again.');
      isSaving.value = false;
    }
  }

  Future<Uint8List?> captureCanvas() async {
    return await ImageSaver.captureWidget(canvasKey, pixelRatio: 3.0);
  }

  String generateCardId() {
    return 'card_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<Color?> _showColorPicker(Color currentColor) async {
    final controller = ColorPickerController(currentColor);

    return await Get.dialog<Color>(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Color',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildSimpleColorPicker(controller),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () =>
                        Get.back(result: controller.currentColor.value),
                    child: Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleColorPicker(ColorPickerController controller) {
    final colors = [
      Colors.white,
      Colors.black,
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () => controller.updateColor(color),
          child: Obx(() {
            final isSelected = controller.currentColor.value == color;
            return Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey,
                  width: isSelected ? 3 : 1,
                ),
              ),
            );
          }),
        );
      }).toList(),
    );
  }
}

class ColorPickerController extends GetxController {
  final Rx<Color> currentColor;

  ColorPickerController(Color initialColor) : currentColor = initialColor.obs;

  void updateColor(Color color) {
    currentColor.value = color;
  }
}

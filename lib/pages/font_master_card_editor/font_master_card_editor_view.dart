import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'font_master_card_editor_logic.dart';
import '../../components/font_master_greeting_card_canvas.dart';
import '../../utils/colors.dart';
import '../../utils/card_templates.dart';

class FontMasterCardEditorView extends GetView<FontMasterCardEditorLogic> {
  const FontMasterCardEditorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Column(
        children: [
          _buildNavBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTemplateSelector(),
                  SizedBox(height: 20.h),
                  _buildCanvasPreview(),
                  SizedBox(height: 24.h),
                  _buildTextBoxTabs(),
                  SizedBox(height: 16.h),
                  _buildControlPanel(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 48.h, bottom: 4.h),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
            onPressed: () => Get.back(),
          ),
          SizedBox(width: 8.w),
          Text(
            controller.cardId == null ? 'Create Card' : 'Edit Card',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacer(),
          Obx(() {
            if (controller.isSaving.value) {
              return SizedBox(
                width: 20.w,
                height: 20.w,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              );
            }
            return IconButton(
              icon: Icon(Icons.save, color: Colors.white, size: 24.sp),
              onPressed: controller.saveCard,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTemplateSelector() {
    final templates = CardTemplates.getAllTemplates();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Templates',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 80.h,
          child: Obx(() {
            // Read observable at top level so GetX can track it
            final selectedId = controller.selectedTemplateId.value;

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: templates.length,
              itemBuilder: (context, index) {
                final template = templates[index];
                final isSelected = selectedId == template.id;

                return GestureDetector(
                  onTap: () => controller.switchTemplate(template.id),
                  child: Container(
                    width: 80.w,
                    margin: EdgeInsets.only(right: 12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryStart
                            : AppColors.borderLight,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getTemplateIcon(template.id),
                          size: 24.sp,
                          color: isSelected
                              ? AppColors.primaryStart
                              : AppColors.textSecondary,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          template.name,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: isSelected
                                ? AppColors.primaryStart
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  IconData _getTemplateIcon(String templateId) {
    switch (templateId) {
      case 'birthday':
        return FontAwesomeIcons.cakeCandles;
      case 'holiday':
        return FontAwesomeIcons.candyCane;
      case 'thankyou':
        return FontAwesomeIcons.handHoldingHeart;
      case 'love':
        return FontAwesomeIcons.heart;
      case 'congratulations':
        return FontAwesomeIcons.trophy;
      case 'blank':
      default:
        return FontAwesomeIcons.fileLines;
    }
  }

  Widget _buildCanvasPreview() {
    return Center(
      child: Obx(() {
        return GreetingCardCanvas(
          canvasKey: controller.canvasKey,
          textBoxes: controller.textBoxes.map((box) => box.value).toList(),
          backgroundColor: controller.backgroundColor.value,
          selectedTextBoxIndex: controller.selectedTextBoxIndex.value,
          isInteractive: true,
          onTextDragged: (index, x, y) =>
              controller.updateTextPosition(index, x, y),
        );
      }),
    );
  }

  Widget _buildTextBoxTabs() {
    return Obx(() {
      return Row(
        children: List.generate(3, (index) {
          final isSelected = controller.selectedTextBoxIndex.value == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => controller.selectTextBox(index),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryStart : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryStart
                        : AppColors.borderLight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: index == 0 ? Radius.circular(8.r) : Radius.zero,
                    topRight: index == 2 ? Radius.circular(8.r) : Radius.zero,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Text ${index + 1}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildControlPanel() {
    return Obx(() {
      final currentBox = controller.currentTextBox;

      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8.r),
            bottomRight: Radius.circular(8.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Text Content'),
            SizedBox(height: 12.h),
            _buildTextInput(currentBox.content),
            SizedBox(height: 20.h),
            _buildSectionTitle('Font & Style'),
            SizedBox(height: 12.h),
            _buildFontSelector(currentBox.fontName),
            SizedBox(height: 12.h),
            _buildTextSizeSlider(currentBox.textSize),
            SizedBox(height: 20.h),
            _buildSectionTitle('Colors'),
            SizedBox(height: 12.h),
            _buildColorSelectors(),
            SizedBox(height: 32.h),
          ],
        ),
      );
    });
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextInput(String currentValue) {
    return TextField(
      controller: TextEditingController(text: currentValue)
        ..selection = TextSelection.collapsed(offset: currentValue.length),
      onChanged: controller.updateTextContent,
      maxLines: 1,
      style: TextStyle(fontSize: 16.sp),
      decoration: InputDecoration(
        hintText: 'Enter text...',
        filled: true,
        fillColor: AppColors.bgSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.primaryStart, width: 2),
        ),
      ),
    );
  }

  Widget _buildFontSelector(String currentFont) {
    return InkWell(
      onTap: controller.selectFont,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.font,
              size: 18.sp,
              color: AppColors.primaryStart,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                currentFont,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontFamily: currentFont != 'System Default'
                      ? currentFont
                      : null,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSizeSlider(double currentSize) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Size: ${currentSize.toInt()}',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
        Slider(
          value: currentSize,
          min: 12,
          max: 100,
          divisions: 88,
          activeColor: AppColors.primaryStart,
          onChanged: controller.updateTextSize,
        ),
      ],
    );
  }

  Widget _buildColorSelectors() {
    return Obx(() {
      final currentBox = controller.currentTextBox;
      final backgroundColor = controller.backgroundColor.value;
      final textColor = Color(
        int.parse(currentBox.textColor.replaceAll('#', 'FF'), radix: 16),
      );

      return Row(
        children: [
          Expanded(
            child: _buildColorButton(
              'Background',
              backgroundColor,
              controller.selectBackgroundColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildColorButton(
              'Text',
              textColor,
              controller.selectTextColor,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildColorButton(String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.bgSecondary,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          children: [
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderLight),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(label, style: TextStyle(fontSize: 14.sp)),
            ),
          ],
        ),
      ),
    );
  }
}

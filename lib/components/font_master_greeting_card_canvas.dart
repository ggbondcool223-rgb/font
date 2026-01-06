import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/text_box_data.dart';
import '../utils/color_utils.dart';

class GreetingCardCanvas extends StatelessWidget {
  final List<TextBoxData> textBoxes;
  final Color backgroundColor;
  final int? selectedTextBoxIndex;
  final Function(int index, double x, double y)? onTextDragged;
  final bool isInteractive;
  final GlobalKey? canvasKey;

  const GreetingCardCanvas({
    super.key,
    required this.textBoxes,
    required this.backgroundColor,
    this.selectedTextBoxIndex,
    this.onTextDragged,
    this.isInteractive = true,
    this.canvasKey,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = 1.sw;
    final canvasSize = screenWidth * 0.9;

    return RepaintBoundary(
      key: canvasKey,
      child: Container(
        width: canvasSize,
        height: canvasSize,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          children: [
            ...List.generate(textBoxes.length, (index) {
              return _buildDraggableText(index, canvasSize);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableText(int index, double canvasSize) {
    if (index >= textBoxes.length) {
      return const SizedBox.shrink();
    }

    final textBox = textBoxes[index];
    
    if (textBox.content.isEmpty) {
      return const SizedBox.shrink();
    }

    final alignmentX = (textBox.positionX * 2) - 1;
    final alignmentY = (textBox.positionY * 2) - 1;
    final isSelected = selectedTextBoxIndex == index;

    if (isInteractive && onTextDragged != null) {
      return Align(
        alignment: Alignment(alignmentX, alignmentY),
        child: GestureDetector(
          onPanUpdate: (details) {
            final centerX = canvasSize / 2;
            final centerY = canvasSize / 2;
            final currentAbsX = centerX + (alignmentX * centerX);
            final currentAbsY = centerY + (alignmentY * centerY);
            final newAbsX = currentAbsX + details.delta.dx;
            final newAbsY = currentAbsY + details.delta.dy;
            final newX = newAbsX / canvasSize;
            final newY = newAbsY / canvasSize;
            final clampedX = newX.clamp(0.0, 1.0);
            final clampedY = newY.clamp(0.0, 1.0);

            onTextDragged!(index, clampedX, clampedY);
          },
          child: _buildTextWidget(textBox, isSelected),
        ),
      );
    } else {
      return Align(
        alignment: Alignment(alignmentX, alignmentY),
        child: _buildTextWidget(textBox, isSelected),
      );
    }
  }

  Widget _buildTextWidget(TextBoxData textBox, bool isSelected) {
    final textColor = ColorUtils.hexToColor(textBox.textColor);
    final fontFamily = textBox.fontName != 'System Default' ? textBox.fontName : null;

    return Container(
      decoration: isSelected
          ? BoxDecoration(
              border: Border.all(
                color: Colors.blue,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4.r),
            )
          : null,
      padding: isSelected ? EdgeInsets.all(4.w) : null,
      child: Text(
        textBox.content,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: textBox.textSize.sp,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}


import 'package:flutter/material.dart';

class ColorUtils {
  static String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  static Color hexToColor(String hexString) {
    final hex = hexString.replaceAll('#', '');
    final hexColor = hex.length == 6 ? 'FF$hex' : hex;
    return Color(int.parse(hexColor, radix: 16));
  }
}


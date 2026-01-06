import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryStart = Color(0xFF667EEA);
  static const Color primaryEnd = Color(0xFF764BA2);
  static const Color textPrimary = Color(0xFF1D1D1F);
  static const Color textSecondary = Color(0xFF86868B);
  static const Color bgPrimary = Color(0xFFFFFFFF);
  static const Color bgSecondary = Color(0xFFF5F5F7);
  static const Color borderColor = Color(0xFFD2D2D7);
  static const Color borderLight = Color(0xFFE5E5E7);
  static const Color success = Color(0xFF28A745);
  static const Color successLight = Color(0xFFD4EDDA);
  static const Color warning = Color(0xFFC107);
  static const Color danger = Color(0xFFDC3545);
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryStart, primaryEnd],
  );
}


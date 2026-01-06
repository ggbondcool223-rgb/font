import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'font_master_font_detail_logic.dart';
import '../../utils/colors.dart';

class FontMasterFontDetailView extends GetView<FontMasterFontDetailLogic> {
  const FontMasterFontDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Column(
        children: [
          _buildNavBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildFontHeader(),
                  SizedBox(height: 12.h),
                  _buildCharacterSetSection(),
                  SizedBox(height: 12.h),
                  _buildSizePreviewSection(),
                  SizedBox(height: 12.h),
                  _buildArticlePreviewSection(),
                  SizedBox(height: 20.h),
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
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 52.h,
        bottom: 12.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Font Detail',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            children: [
              // Download button
              GestureDetector(
                onTap: controller.onDownloadTap,
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    FontAwesomeIcons.download,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Apply to App button
              Obx(
                () => GestureDetector(
                  onTap: controller.isCurrentFont.value
                      ? null
                      : controller.onApplyToAppTap,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: controller.isCurrentFont.value
                          ? Colors.white.withOpacity(0.3)
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      controller.isCurrentFont.value
                          ? FontAwesomeIcons.circleCheck
                          : FontAwesomeIcons.paintbrush,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFontHeader() {
    return Obx(
      () => Container(
        color: Colors.white,
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.fontName.value,
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                if (controller.fontCategory.value.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryStart,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      controller.fontCategory.value,
                      style: TextStyle(fontSize: 13.sp, color: Colors.white),
                    ),
                  ),
                if (controller.fontFileSize.value > 0) ...[
                  SizedBox(width: 16.w),
                  Icon(
                    FontAwesomeIcons.file,
                    size: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '${controller.fontFileSize.value.toStringAsFixed(2)} MB',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
            if (controller.fontDescription.value.isNotEmpty) ...[
              SizedBox(height: 12.h),
              Text(
                controller.fontDescription.value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCharacterSetSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Character Set',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                    style: TextStyle(
                      fontFamily: controller.fontName.value,
                      fontSize: 20.sp,
                      color: AppColors.textPrimary,
                      height: 1.6,
                      letterSpacing: 8.w,
                    ),
                  ),
                ),
                Obx(
                  () => Text(
                    'abcdefghijklmnopqrstuvwxyz',
                    style: TextStyle(
                      fontFamily: controller.fontName.value,
                      fontSize: 20.sp,
                      color: AppColors.textPrimary,
                      height: 1.6,
                      letterSpacing: 8.w,
                    ),
                  ),
                ),
                Obx(
                  () => Text(
                    '0123456789 @#\$%&*()',
                    style: TextStyle(
                      fontFamily: controller.fontName.value,
                      fontSize: 20.sp,
                      color: AppColors.textPrimary,
                      height: 1.6,
                      letterSpacing: 8.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizePreviewSection() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Size Preview',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    'The quick brown fox - 14pt',
                    style: TextStyle(
                      fontFamily: controller.fontName.value,
                      fontSize: 14.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Obx(
                  () => Text(
                    'The quick brown fox - 18pt',
                    style: TextStyle(
                      fontFamily: controller.fontName.value,
                      fontSize: 18.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Obx(
                  () => Text(
                    'The quick brown fox - 24pt',
                    style: TextStyle(
                      fontFamily: controller.fontName.value,
                      fontSize: 24.sp,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticlePreviewSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Article Preview',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildSizeButton('Aa-', () => controller.decreaseFontSize()),
              SizedBox(width: 12.w),
              _buildSizeButton('Aa', () => controller.resetFontSize()),
              SizedBox(width: 12.w),
              _buildSizeButton('Aa+', () => controller.increaseFontSize()),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(20.w),
            constraints: BoxConstraints(maxHeight: 300.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: SingleChildScrollView(
              child: Obx(
                () => Text(
                  'The Art of Typography\n\n'
                  'Typography is the art and technique of arranging type to make written language legible, readable, and appealing when displayed.\n\n'
                  'The arrangement of type involves selecting typefaces, point sizes, line lengths, line-spacing, and letter-spacing, and adjusting the space between pairs of letters.\n\n'
                  'Good typography establishes a strong visual hierarchy, provides a graphic balance to the website, and sets the product\'s overall tone.\n\n'
                  'The quick brown fox jumps over the lazy dog. 0123456789',
                  style: TextStyle(
                    fontFamily: controller.fontName.value,
                    fontSize: controller.previewFontSize.value.sp,
                    color: AppColors.textPrimary,
                    height: 1.8,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeButton(String label, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        side: BorderSide(color: AppColors.borderColor),
        foregroundColor: AppColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text(label, style: TextStyle(fontSize: 14.sp)),
    );
  }
}

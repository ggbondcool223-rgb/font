import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'font_master_settings_logic.dart';
import '../../utils/colors.dart';

class FontMasterSettingsView extends GetView<FontMasterSettingsLogic> {
  const FontMasterSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Column(
        children: [
          _buildNavBar(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionHeader('FONT'),
                _buildCurrentFontSection(),
                _buildSectionHeader('DATA'),
                _buildDataSection(),
                _buildSectionHeader('ABOUT'),
                _buildAboutSection(),
                SizedBox(height: 20.h),
              ],
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
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 48.h,
        bottom: 12.h,
      ),
      child: Text(
        'Settings',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCurrentFontSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: InkWell(
        onTap: controller.onCurrentFontTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and title
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.font,
                    color: AppColors.primaryStart,
                    size: 18.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Current Font',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    FontAwesomeIcons.chevronRight,
                    color: AppColors.borderColor,
                    size: 16.sp,
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Font name and category
              Obx(
                () => Text(
                  '${controller.currentFont.value} - ${controller.currentFontCategory.value}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Preview text
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Obx(
                  () => Text(
                    'The quick brown fox jumps over the lazy dog. 0123456789',
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: AppColors.textPrimary,
                      fontFamily:
                          controller.currentFont.value != 'System Default'
                          ? controller.currentFont.value
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Obx(
        () => _buildSettingsItem(
          icon: FontAwesomeIcons.broom,
          title: 'Clear All Data',
          trailing: Text(
            controller.cacheSize.value,
            style: TextStyle(fontSize: 15.sp, color: AppColors.textSecondary),
          ),
          onTap: controller.onClearAllDataTap,
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Obx(
        () => _buildSettingsItem(
          icon: FontAwesomeIcons.circleInfo,
          title: 'Version',
          trailing: Text(
            controller.appVersion.value,
            style: TextStyle(fontSize: 15.sp, color: AppColors.textSecondary),
          ),
          showChevron: false,
          onTap: null,
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    bool showChevron = true,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryStart, size: 18.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (showChevron) ...[
              SizedBox(width: 8.w),
              Icon(
                FontAwesomeIcons.chevronRight,
                color: AppColors.borderColor,
                size: 16.sp,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

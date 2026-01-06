import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'font_master_article_reading_logic.dart';
import '../../utils/colors.dart';

class FontMasterArticleReadingView
    extends GetView<FontMasterArticleReadingLogic> {
  const FontMasterArticleReadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Column(
        children: [
          _buildNavBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(12.w),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.articleTitle.value,
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.3,
                          fontFamily:
                              controller.selectedFontId.value != 'system'
                              ? controller.currentFont.value
                              : null,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        controller.articleContent.value,
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: AppColors.textPrimary,
                          height: 1.8,
                          fontFamily:
                              controller.selectedFontId.value != 'system'
                              ? controller.currentFont.value
                              : null,
                        ),
                      ),
                      SizedBox(height: 80.h),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildFontSelector(),
    );
  }

  Widget _buildNavBar() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 52.h,
        bottom: 16.h,
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
              child: Obx(
                () => Text(
                  controller.articleTitle.value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.borderLight, width: 1.h),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 12.h,
            bottom: 28.h,
          ),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    FontAwesomeIcons.font,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.currentFont.value,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        controller.currentFontSource.value,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: controller.showFontSelector,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryStart,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Text(
                  'Change Font',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

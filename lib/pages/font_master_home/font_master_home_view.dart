import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'font_master_home_logic.dart';
import '../../utils/colors.dart';

class FontMasterHomeView extends GetView<FontMasterHomeLogic> {
  const FontMasterHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Column(
        children: [
          _buildNavBar(),
          _buildCategoryTabs(),
          Expanded(child: _buildFontGrid()),
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
        top: 48.h,
        bottom: 12.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'FontMaster',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.toNamed('/master_search'),
                child: Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 16.w),
              GestureDetector(
                onTap: () => Get.toNamed('/article_list'),
                child: Icon(
                  FontAwesomeIcons.bookOpen,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 1.h),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Obx(
          () => Row(
            children: controller.categories.map((category) {
              final isSelected = controller.selectedCategory.value == category;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: GestureDetector(
                  onTap: () => controller.selectCategory(category),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryStart
                          : AppColors.bgSecondary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFontGrid() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.fonts.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.font_download_outlined,
                size: 64.sp,
                color: AppColors.textSecondary,
              ),
              SizedBox(height: 16.h),
              Text(
                'No Fonts Found',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Try selecting a different category',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
          childAspectRatio: 1,
        ),
        itemCount: controller.fonts.length,
        itemBuilder: (context, index) {
          final font = controller.fonts[index];
          return _buildFontCard(font);
        },
      );
    });
  }

  Widget _buildFontCard(Map<String, dynamic> font) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          '/font_detail',
          arguments: {
            'font_id': font['font_id'],
            'font_name': font['name'],
            'source': font['source'],
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFontPreview(font),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r),
                  ),
                ),
                child: Text(
                  font['name'],
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontPreview(Map<String, dynamic> font) {
    final previewImage = font['preview_image'] as String?;
    final hasPreviewImage = previewImage != null && previewImage.isNotEmpty;

    return Container(
      height: 128.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Stack(
        children: [
          if (hasPreviewImage)
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
              child: Transform.scale(
                scale: 1.4,
                child: Image.asset(
                  previewImage,
                  width: double.infinity,
                  height: 140.h,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center,
                ),
              ),
            )
          else
            Center(
              child: Text(
                'Aa Bb Cc',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: font['name'],
                  color: const Color(0xFF2D3436),
                ),
              ),
            ),
          if (font['badge'] != null)
            Positioned(
              top: 8.h,
              right: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      font['badge'] == 'Custom'
                          ? FontAwesomeIcons.star
                          : FontAwesomeIcons.folder,
                      color: Colors.white,
                      size: 10.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      font['badge'],
                      style: TextStyle(color: Colors.white, fontSize: 10.sp),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

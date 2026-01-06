import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'font_master_article_list_logic.dart';
import '../../utils/colors.dart';

class FontMasterArticleListView extends GetView<FontMasterArticleListLogic> {
  const FontMasterArticleListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Column(
        children: [
          _buildNavBar(),
          Expanded(
            child: Obx(() {
              // Show loading state
              if (controller.isLoading.value) {
                return _buildLoadingState();
              }

              // Show error state
              if (controller.hasError.value) {
                return _buildErrorState();
              }

              // Show empty state
              if (controller.articles.isEmpty) {
                return _buildEmptyState();
              }

              // Show articles list with pull to refresh
              return RefreshIndicator(
                onRefresh: controller.onRefresh,
                color: AppColors.primaryStart,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.articles.length,
                  itemBuilder: (context, index) {
                    return _buildArticleCard(controller.articles[index], index);
                  },
                ),
              );
            }),
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
        bottom: 14.h,
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
                'Font Test Articles',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 44.w), // Balance the back button
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryStart),
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading articles...',
            style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.bookOpen,
            size: 64.sp,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            'No Articles Found',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Obx(
            () => Text(
              controller.errorMessage.value.isNotEmpty
                  ? controller.errorMessage.value
                  : 'No articles available',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.circleExclamation,
            size: 64.sp,
            color: Colors.red.withOpacity(0.6),
          ),
          SizedBox(height: 16.h),
          Text(
            'Error Loading Articles',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Obx(
              () => Text(
                controller.errorMessage.value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: controller.retryLoad,
            icon: Icon(FontAwesomeIcons.arrowsRotate, size: 16.sp),
            label: Text(
              'Retry',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryStart,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(Map<String, dynamic> article, int index) {
    final gradients = [
      [const Color(0xFFFFEAA7), const Color(0xFFFDCB6E)],
      [const Color(0xFF74B9FF), const Color(0xFF0984E3)],
      [const Color(0xFFFD79A8), const Color(0xFFE84393)],
      [const Color(0xFF55EFC4), const Color(0xFF00B894)],
      [const Color(0xFFA29BFE), const Color(0xFF6C5CE7)],
    ];

    final gradient = gradients[index % gradients.length];

    return GestureDetector(
      onTap: () => controller.openArticle(
        article['article_id'] as String,
        article['title'] as String,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.all(20.w),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradient,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text('📖', style: TextStyle(fontSize: 28.sp)),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['title'],
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.alignLeft,
                        size: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        article['words'],
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Icon(
                        FontAwesomeIcons.clock,
                        size: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        article['readTime'],
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    article['excerpt'],
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: (article['tags'] as List<String>).map((tag) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bgSecondary,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryStart,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

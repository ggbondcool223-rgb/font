import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'font_master_search_logic.dart';
import '../../utils/colors.dart';

class FontMasterSearchView extends GetView<FontMasterSearchLogic> {
  const FontMasterSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterTabs(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSearchResults(),
                _buildRecentSearches(),
                _buildPopularTags(),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 52.h,
        bottom: 14.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.white.withOpacity(0.9),
                    size: 16.sp,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search fonts...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16.sp,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  Obx(
                    () => controller.searchQuery.value.isNotEmpty
                        ? GestureDetector(
                            onTap: () => controller.clearSearch(),
                            child: Icon(
                              FontAwesomeIcons.circleXmark,
                              color: Colors.white.withOpacity(0.9),
                              size: 16.sp,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 1.h),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Obx(
        () => Row(
          children: controller.filters.map((filter) {
            final isSelected = controller.selectedFilter.value == filter;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: () => controller.selectFilter(filter),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryStart
                        : AppColors.bgSecondary,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryStart
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
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
    );
  }

  Widget _buildSearchResults() {
    return Obx(() {
      // Show loading state
      if (controller.isSearching.value) {
        return Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 12.h),
          padding: EdgeInsets.all(40.w),
          child: Center(
            child: Column(
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 16.h),
                Text(
                  'Searching...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Don't show results section if no search query
      if (controller.searchQuery.value.isEmpty) {
        return const SizedBox.shrink();
      }

      // Show empty state
      if (controller.searchResults.isEmpty) {
        return Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 12.h),
          padding: EdgeInsets.all(40.w),
          child: Center(
            child: Column(
              children: [
                Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 48.sp,
                  color: AppColors.textSecondary.withOpacity(0.3),
                ),
                SizedBox(height: 16.h),
                Text(
                  'No fonts found',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Try different keywords',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Show results
      return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 12.h),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search Results (${controller.searchResults.length})',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            ...controller.searchResults.map(
              (result) => _buildResultCard(result),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildResultCard(Map<String, dynamic> result) {
    final previewImage = result['preview_image'] as String?;
    final hasPreviewImage = previewImage != null && previewImage.isNotEmpty;

    return GestureDetector(
      onTap: () => controller.openFontDetail(
        result['font_id'] as String,
        result['name'] as String,
        result['source'] as String,
      ),
      child: Container(
        padding: EdgeInsets.only(bottom: 16.h),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.bgSecondary, width: 1.h),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                gradient: hasPreviewImage
                    ? null
                    : const LinearGradient(
                        colors: [Color(0xFF74B9FF), Color(0xFF0984E3)],
                      ),
                borderRadius: BorderRadius.circular(12.r),
                color: hasPreviewImage ? Colors.white : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: hasPreviewImage
                    ? Transform.scale(
                        scale: 1.4,
                        child: Image.asset(
                          previewImage,
                          width: 80.w,
                          height: 80.h,
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.center,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                'Aa',
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: result['name'] as String,
                                  color: const Color(0xFF2D3436),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Text(
                          'Aa',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: result['name'] as String,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    result['name'] as String,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(
                            result['category'] as String,
                          ),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          result['category'] as String,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              FontAwesomeIcons.chevronRight,
              size: 16.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'builtin':
        return AppColors.primaryStart;
      case 'custom':
        return const Color(0xFFE17055);
      case 'local':
        return const Color(0xFF00B894);
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildRecentSearches() {
    return Obx(() {
      // Don't show if there are no recent searches or if there's an active search
      if (controller.recentSearches.isEmpty ||
          controller.searchQuery.value.isNotEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 12.h),
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.clearSearchHistory(),
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.primaryStart,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ...controller.recentSearches.map(
              (search) => GestureDetector(
                onTap: () => controller.searchFromHistory(search),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.bgSecondary,
                        width: 1.h,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.clock,
                        size: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          search,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        FontAwesomeIcons.arrowTurnUp,
                        size: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPopularTags() {
    return Obx(() {
      // Don't show if there's an active search
      if (controller.searchQuery.value.isNotEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 12.h),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Popular Tags',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.h,
              children: controller.popularTags.map((tag) {
                return GestureDetector(
                  onTap: () => controller.searchByTag(tag),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bgSecondary,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tag,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          FontAwesomeIcons.hashtag,
                          size: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }
}

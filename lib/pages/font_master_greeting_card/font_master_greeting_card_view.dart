import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'font_master_greeting_card_logic.dart';
import '../../utils/colors.dart';
import '../../utils/color_utils.dart';
import '../../utils/text_box_data.dart';
import '../../components/font_master_greeting_card_canvas.dart';

class FontMasterGreetingCardView extends GetView<FontMasterGreetingCardLogic> {
  const FontMasterGreetingCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Column(
        children: [
          _buildNavBar(),
          Expanded(
            child: Obx(
              () =>
                  controller.isEmpty.value ? _buildEmptyState() : _buildCardList(),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
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
        'Greeting Cards',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.envelope,
            size: 80.sp,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Greeting Cards',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Tap + to create your first card',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      return GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 1.0,
        ),
        itemCount: controller.cards.length,
        itemBuilder: (context, index) {
          final card = controller.cards[index];
          return _buildCardItem(card);
        },
      );
    });
  }

  Widget _buildCardItem(card) {
    return GestureDetector(
      onTap: () => controller.viewCardDetail(card),
      onLongPress: () => controller.deleteCard(card),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Stack(
            children: [
              // Card preview (scaled down)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: 300,
                  height: 300,
                  child: GreetingCardCanvas(
                    textBoxes: TextBoxData.listFromJson(card.textBoxesData),
                    backgroundColor: ColorUtils.hexToColor(card.backgroundColor),
                    isInteractive: false,
                  ),
                ),
              ),
              // Overlay for long press hint
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Text(
                    'Long press to delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: controller.createNewCard,
      backgroundColor: AppColors.primaryStart,
      child: Icon(Icons.add, color: Colors.white, size: 28.sp),
    );
  }
}


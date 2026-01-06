import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'font_master_tab_logic.dart';
import '../font_master_home/font_master_home_view.dart';
import '../font_master_greeting_card/font_master_greeting_card_view.dart';
import '../font_master_settings/font_master_settings_view.dart';
import '../../utils/colors.dart';

class FontMasterTabView extends GetView<FontMasterTabLogic> {
  const FontMasterTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const FontMasterHomeView(),
      const FontMasterGreetingCardView(),
      const FontMasterSettingsView(),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(
      () => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.borderLight, width: 1.h),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
                  _buildTabItem(
                    icon: FontAwesomeIcons.font,
                    label: 'Fonts',
                    index: 0,
                    currentIndex: controller.currentIndex.value,
                    onTap: () => controller.changeTab(0),
                  ),
                  _buildTabItem(
                    icon: FontAwesomeIcons.envelope,
                    label: 'Cards',
                    index: 1,
                    currentIndex: controller.currentIndex.value,
                    onTap: () => controller.changeTab(1),
                  ),
                  _buildTabItem(
                    icon: FontAwesomeIcons.gear,
                    label: 'Settings',
                    index: 2,
                    currentIndex: controller.currentIndex.value,
                    onTap: () => controller.changeTab(2),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    final isActive = index == currentIndex;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: isActive
                  ? AppColors.primaryStart
                  : AppColors.textSecondary,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: isActive
                    ? AppColors.primaryStart
                    : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }
}

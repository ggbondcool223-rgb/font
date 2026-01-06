import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/colors.dart';

class FontMasterStatusBar extends StatelessWidget {
  const FontMasterStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '9:41',
            style: TextStyle(color: Colors.white, fontSize: 14.sp),
          ),
          Row(
            children: [
              Icon(FontAwesomeIcons.signal, color: Colors.white, size: 14.sp),
              SizedBox(width: 6.w),
              Icon(FontAwesomeIcons.wifi, color: Colors.white, size: 14.sp),
              SizedBox(width: 6.w),
              Icon(
                FontAwesomeIcons.batteryThreeQuarters,
                color: Colors.white,
                size: 14.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

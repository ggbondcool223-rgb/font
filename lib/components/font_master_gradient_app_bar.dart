import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/colors.dart';

class FontMasterGradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool centerTitle;

  const FontMasterGradientAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: centerTitle,
        leading: leading,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(52.h);
}


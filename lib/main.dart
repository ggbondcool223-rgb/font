import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_master/pages/font_master_come/font_master_come_binding.dart';
import 'package:font_master/pages/font_master_come/font_master_come_view.dart';
import 'package:font_master/pages/font_master_font_detail/font_master_font_detail_run.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'utils/colors.dart';
import 'utils/theme_service.dart';
import '../pages/font_master_tab/font_master_tab_view.dart';
import '../pages/font_master_tab/font_master_tab_binding.dart';

import '../pages/font_master_home/font_master_home_view.dart';
import '../pages/font_master_home/font_master_home_binding.dart';

import '../pages/font_master_font_detail/font_master_font_detail_view.dart';
import '../pages/font_master_font_detail/font_master_font_detail_binding.dart';

import '../pages/font_master_search/font_master_search_view.dart';
import '../pages/font_master_search/font_master_search_binding.dart';

import '../pages/font_master_greeting_card/font_master_greeting_card_view.dart';
import '../pages/font_master_greeting_card/font_master_greeting_card_binding.dart';

import '../pages/font_master_card_editor/font_master_card_editor_view.dart';
import '../pages/font_master_card_editor/font_master_card_editor_binding.dart';

import '../pages/font_master_settings/font_master_settings_view.dart';
import '../pages/font_master_settings/font_master_settings_binding.dart';

import '../pages/font_master_article_list/font_master_article_list_view.dart';
import '../pages/font_master_article_list/font_master_article_list_binding.dart';

import '../pages/font_master_article_reading/font_master_article_reading_view.dart';
import '../pages/font_master_article_reading/font_master_article_reading_binding.dart';
List<GetPage<dynamic>> Font = [
  GetPage(
    name: '/',
    page: () => const FontMasterComeView(),
    binding: FontMasterComeBinding(),
  ),
  GetPage(
    name: '/master_tab',
    page: () => const FontMasterTabView(),
    binding: FontMasterTabBinding(),
  ),
  GetPage(
    name: '/master_home',
    page: () => const FontMasterHomeView(),
    binding: FontMasterHomeBinding(),
  ),
  GetPage(
    name: '/font_detail_run',
    page: () => FontMasterFontDetailRun(),
  ),
  GetPage(
    name: '/font_detail',
    page: () => const FontMasterFontDetailView(),
    binding: FontMasterFontDetailBinding(),
  ),
  GetPage(
    name: '/master_search',
    page: () => const FontMasterSearchView(),
    binding: FontMasterSearchBinding(),
  ),
  GetPage(
    name: '/greeting_card',
    page: () => const FontMasterGreetingCardView(),
    binding: FontMasterGreetingCardBinding(),
  ),
  GetPage(
    name: '/card_editor',
    page: () => const FontMasterCardEditorView(),
    binding: FontMasterCardEditorBinding(),
  ),
  GetPage(
    name: '/master_settings',
    page: () => const FontMasterSettingsView(),
    binding: FontMasterSettingsBinding(),
  ),
  GetPage(
    name: '/article_list',
    page: () => const FontMasterArticleListView(),
    binding: FontMasterArticleListBinding(),
  ),
  GetPage(
    name: '/article_reading',
    page: () => const FontMasterArticleReadingView(),
    binding: FontMasterArticleReadingBinding(),
  ),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Get.putAsync(() => ThemeService().init());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Obx(
            () => GetMaterialApp(
              debugShowCheckedModeBanner: false,
              getPages: Font,
              initialRoute: '/',
              theme: _buildTheme(themeService.currentFontFamily.value),
            ),
          );
        },
      ),
    );
  }

  ThemeData _buildTheme(String? fontFamily) {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primaryStart,
      scaffoldBackgroundColor: AppColors.bgSecondary,
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryStart,
        surface: AppColors.bgPrimary,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          color: Colors.white,
          fontFamily: fontFamily,
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(12.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(12.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryStart),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        color: AppColors.borderLight,
      ),
    );
  }
}

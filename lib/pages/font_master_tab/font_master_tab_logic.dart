import 'package:get/get.dart';
import '../font_master_greeting_card/font_master_greeting_card_logic.dart';
import '../font_master_home/font_master_home_logic.dart';

class FontMasterTabLogic extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
    
    // 当切换到 Home Tab (index 0) 时，刷新字体列表
    if (index == 0) {
      _refreshHome();
    }
    // 当切换到 Greeting Card Tab (index 1) 时，刷新贺卡列表
    else if (index == 1) {
      _refreshGreetingCards();
    }
  }

  void _refreshHome() {
    try {
      if (Get.isRegistered<FontMasterHomeLogic>()) {
        final homeLogic = Get.find<FontMasterHomeLogic>();
        homeLogic.refreshFonts();
      }
    } catch (e) {
    }
  }

  void _refreshGreetingCards() {
    try {
      if (Get.isRegistered<FontMasterGreetingCardLogic>()) {
        final greetingCardLogic = Get.find<FontMasterGreetingCardLogic>();
        greetingCardLogic.loadCards();
      }
    } catch (e) {
    }
  }

  void refreshAll() {
    _refreshHome();
    _refreshGreetingCards();
  }
}


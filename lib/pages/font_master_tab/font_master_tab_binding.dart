import 'package:get/get.dart';
import 'font_master_tab_logic.dart';
import '../font_master_home/font_master_home_logic.dart';
import '../font_master_greeting_card/font_master_greeting_card_logic.dart';
import '../font_master_settings/font_master_settings_logic.dart';

class FontMasterTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FontMasterTabLogic());
    Get.lazyPut(() => FontMasterHomeLogic());
    Get.lazyPut(() => FontMasterGreetingCardLogic());
    Get.lazyPut(() => FontMasterSettingsLogic());
  }
}


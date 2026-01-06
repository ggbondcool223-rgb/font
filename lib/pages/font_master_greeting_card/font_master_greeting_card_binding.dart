import 'package:get/get.dart';
import 'font_master_greeting_card_logic.dart';

class FontMasterGreetingCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FontMasterGreetingCardLogic());
  }
}


import 'package:get/get.dart';
import 'font_master_font_detail_logic.dart';

class FontMasterFontDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FontMasterFontDetailLogic());
  }
}


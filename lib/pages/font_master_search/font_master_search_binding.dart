import 'package:get/get.dart';
import 'font_master_search_logic.dart';

class FontMasterSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FontMasterSearchLogic());
  }
}


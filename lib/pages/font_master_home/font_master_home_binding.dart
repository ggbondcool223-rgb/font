import 'package:get/get.dart';
import 'font_master_home_logic.dart';

class FontMasterHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FontMasterHomeLogic());
  }
}


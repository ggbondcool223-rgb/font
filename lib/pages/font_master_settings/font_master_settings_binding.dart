import 'package:get/get.dart';
import 'font_master_settings_logic.dart';

class FontMasterSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FontMasterSettingsLogic());
  }
}


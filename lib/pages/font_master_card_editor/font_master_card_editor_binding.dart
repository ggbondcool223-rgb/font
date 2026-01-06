import 'package:get/get.dart';
import 'font_master_card_editor_logic.dart';

class FontMasterCardEditorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FontMasterCardEditorLogic());
  }
}


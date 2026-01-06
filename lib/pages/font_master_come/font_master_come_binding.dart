import 'package:get/get.dart';

import 'font_master_come_logic.dart';

class FontMasterComeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      FontMasterComeLogic(),
      permanent: true,
    );
  }
}

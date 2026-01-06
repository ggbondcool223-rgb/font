import 'package:get/get.dart';
import 'font_master_article_reading_logic.dart';

class FontMasterArticleReadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FontMasterArticleReadingLogic());
  }
}


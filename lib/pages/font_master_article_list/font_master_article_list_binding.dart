import 'package:get/get.dart';
import 'font_master_article_list_logic.dart';

class FontMasterArticleListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FontMasterArticleListLogic());
  }
}


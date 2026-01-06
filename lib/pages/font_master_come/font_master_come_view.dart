import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'font_master_come_logic.dart';

class FontMasterComeView extends GetView<FontMasterComeLogic> {
  const FontMasterComeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.jqwoprsc.value
              ? const CircularProgressIndicator(color: Colors.blueAccent)
              : buildError(),
        ),
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              controller.kmtu();
            },
            icon: const Icon(
              Icons.restart_alt,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}

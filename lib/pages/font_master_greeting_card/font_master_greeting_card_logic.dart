import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../db_font_master/data.dart';
import '../../db_font_master/db_font_master_entity.dart';
import '../../utils/index.dart';

class FontMasterGreetingCardLogic extends GetxController {
  final RxList<GreetingCardEntity> cards = <GreetingCardEntity>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isEmpty = true.obs;

  final _db = FontMasterDatabase();

  @override
  void onInit() {
    super.onInit();
    loadCards();
  }

  Future<void> loadCards() async {
    isLoading.value = true;

    try {
      final result = await _db.getAllGreetingCards();
      cards.value = result;
      isEmpty.value = result.isEmpty;
    } catch (e) {
      errorToast('Failed to load greeting cards');
    } finally {
      isLoading.value = false;
    }
  }

  void createNewCard() {
    Get.toNamed('/card_editor')?.then((result) {
      if (result == true) {
        // Card was saved, reload list
        loadCards();
      }
    });
  }

  void editCard(String cardId) {
    Get.toNamed('/card_editor', arguments: cardId)?.then((result) {
      if (result == true) {
        // Card was updated, reload list
        loadCards();
      }
    });
  }

  Future<void> deleteCard(GreetingCardEntity card) async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Delete Card'),
        content: Text('Are you sure you want to delete this greeting card?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _db.deleteGreetingCard(card.cardId);
        successToast('Card deleted');
        loadCards();
      } catch (e) {
        errorToast('Failed to delete card');
      }
    }
  }

  void viewCardDetail(GreetingCardEntity card) {
    editCard(card.cardId);
  }
}


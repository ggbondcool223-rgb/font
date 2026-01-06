import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

void successToast(String msg) {
  Get.snackbar(
    'Success',
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.green,
    colorText: Colors.white,
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    icon: const Icon(Icons.check_circle, color: Colors.white),
  );
}

void errorToast(String msg) {
  Get.snackbar(
    'Error',
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    icon: const Icon(Icons.error, color: Colors.white),
  );
}

void infoToast(String msg) {
  Get.snackbar(
    'Info',
    msg,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.blue,
    colorText: Colors.white,
    duration: const Duration(seconds: 2),
    margin: const EdgeInsets.all(16),
    borderRadius: 12,
    icon: const Icon(Icons.info, color: Colors.white),
  );
}

String getDateString(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String extractDateFromDateTime(String dateTimeString) {
  try {
    final dateTime = DateTime.parse(dateTimeString);
    return getDateString(dateTime);
  } catch (e) {
    return dateTimeString.split(' ')[0];
  }
}


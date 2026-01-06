import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageSaver {
  static Future<bool> requestPermission() async {
    if (await Permission.photos.isGranted) {
      return true;
    }

    final status = await Permission.photos.request();
    if (status.isGranted) {
      return true;
    }

    if (await Permission.storage.isGranted) {
      return true;
    }

    final storageStatus = await Permission.storage.request();
    return storageStatus.isGranted;
  }

  static Future<bool> saveToGallery(Uint8List imageBytes, String fileName) async {
    try {
      final result = await ImageGallerySaverPlus.saveImage(
        imageBytes,
        quality: 100,
        name: fileName,
      );

      if (result is Map) {
        return result['isSuccess'] == true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<Uint8List?> captureWidget(
    GlobalKey key, {
    double pixelRatio = 3.0,
  }) async {
    try {
      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      
      if (boundary == null) {
        return null;
      }

      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }
}

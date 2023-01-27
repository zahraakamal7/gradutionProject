import 'dart:io';
import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/controller/authController.dart';
import 'package:flight_booking_sys/controller/scaffoldController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_api_availability/google_api_availability.dart';
import '../services/networkService.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScaffoldController.controller.showAppbar.value = false;
    WidgetsBinding.instance!.addPostFrameCallback((_) => getReady());
    return Scaffold(
      body: Center(
          child: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            'assets/educationloco.jpg',
            fit: BoxFit.fill,
          ),
        ),
        height: Get.height / 9,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          shape: BoxShape.circle,
        ),
      )),
    );
  }

  Future getReady() async {
    Get.put(NetworkService()).init();
    final AuthController auth = AuthController.controller;
    // final NotificationService ns = Get.find<NotificationService>();
    GetStorage box = GetStorage();
    GooglePlayServicesAvailability? playStoreAvailability;
    try {
      if (!Platform.isIOS)
        playStoreAvailability = await GoogleApiAvailability.instance
            .checkGooglePlayServicesAvailability(false);
      else
        playStoreAvailability = GooglePlayServicesAvailability.values[0];
    } on PlatformException {
      playStoreAvailability = GooglePlayServicesAvailability.unknown;
    }
    // if (box.read("guest") ?? false) {
    //   print("I am guest.");
    //   auth.isAuth.value = false;
    //   auth.isloginedIn.value = true;
    //   ScaffoldController.controller.firstRoute.value = MainRoute;
    //   Get.offAllNamed(MainRoute);
    // } else

    if (box.read("auth") ?? false) {
      await auth.getUser();
      // if (ns.data.keys.length > 0) {
      //   Get.rawSnackbar(message: "${ns.data.values.elementAt(0)}");
      //   ns.data.clear();
      // }
    } else {
      // not guest
      if (box.hasData("fireToken") ||
          playStoreAvailability != GooglePlayServicesAvailability.success) {
        // await auth.regitserGuestUser();
        ScaffoldController.controller.firstRoute.value = RegisterationRoute;
        ScaffoldController.controller.showAppbar.value = false;
        await Get.offAllNamed(RegisterationRoute);
      } else
        box.listenKey("fireToken", (value) async {
          // await auth.regitserGuestUser();
          ScaffoldController.controller.firstRoute.value = RegisterationRoute;
          ScaffoldController.controller.showAppbar.value = false;
          await Get.offAllNamed(RegisterationRoute);
        });
    }
  }
}

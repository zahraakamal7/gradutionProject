import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/controller/scaffoldController.dart';
import 'package:flight_booking_sys/model/materialModel.dart';
import 'package:flight_booking_sys/services/preDataService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import '../api/apiEndpoints.dart';
import '../model/userModel.dart';
import 'notificationApiController.dart';
import 'reportController.dart';

class AuthController extends GetxController {
  static AuthController get controller => Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController(), permanent: true);
  Rx<UserModel?> user = Rx(null);
  RxMap<String, List<MaterialModel>> stageMaterial =
      RxMap<String, List<MaterialModel>>();
  Rx<UserType> userType = Rx(UserType.Unknown);
  final logger = Logger();
  final box = GetStorage();
  final showHidden = RxBool(false);
  final Rx<bool> isRegisterForm = Rx<bool>(false);
  //fields controller
  final TextEditingController firstName = TextEditingController(text: "");
  final TextEditingController lastName = TextEditingController(text: "");
  final TextEditingController email = TextEditingController(text: "");
  final TextEditingController username = TextEditingController(text: "");
  final TextEditingController phoneNumber = TextEditingController(text: "");
  final TextEditingController password = TextEditingController(text: "");
  final RxString birthDate = "".obs;
  final birthDateInvalid = RxBool(false);
  final isVisiblePassword = RxBool(false);
  final isloginedIn = RxBool(false);
  //isloading
  final isLoading = RxBool(false);
  final GlobalKey<FormState> registerationFormKey = GlobalKey<FormState>();
  RxBool isAuth = false.obs;
  String userTypeText() {
    return userType.value == UserType.Teacher
        ? "معلم"
        : userType.value == UserType.Student
            ? "طالب"
            : "غير معروف";
  }

  void loginUser() async {
    isLoading.value = true;
    final res = await loginUserApi(username.text, password.text);
    res.fold((l) {
      logger.e(l!.errors);
      Get.rawSnackbar(
          message: l.message == "" ? "حدث خطآ حاول مجددا" : l.message);
      isLoading.value = false;
    }, (r) async {
      box.write("guest", false);
      box.write("auth", true);
      print("I am auth.");

      isAuth.value = true;
      isloginedIn.value = true;
      user.value = r!.user;
      if (user.value!.userType == 2) _filterMaterialStage();
      userType.value = UserType.values[user.value!.userType!];
      //logger.i(r.data);
      isLoading.value = false;
      await Get.putAsync<PreDataService>(PreDataService().init,
          permanent: true);
      ScaffoldController.controller.firstRoute.value = MainRoute;
      Get.offAllNamed(MainRoute);
      // Logger().i(r);
    });
  }

  Future getUser() async {
    isLoading.value = true;
    final res = await getUserApi();
    res.fold((l) {
      isLoading.value = false;
      box.write("guest", false);
      box.write("auth", false);
      isAuth.value = false;
      Logger().e(l!.errors);
      Get.rawSnackbar(
          backgroundColor: Theme.of(Get.context!).appBarTheme.backgroundColor!,
          message: l.errors == "" ? "حدث خطآ حاول مجددا" : l.errors);
      return;
    }, (r) async {
      isAuth.value = true;
      isloginedIn.value = true;
      user.value = r!.user;
      if (user.value!.userType == 2) _filterMaterialStage();
      userType.value = UserType.values[user.value!.userType!];
      //logger.i(r.data);
      isLoading.value = false;
      await Get.putAsync<PreDataService>(PreDataService().init,
          permanent: true);
      ScaffoldController.controller.firstRoute.value = MainRoute;
      Get.offAllNamed(MainRoute);
    });
  }

  // void regitserUser() async {
  //   isLoading.value = true;
  //   final res = await registerUserApi(
  //     firstName: firstName.text,
  //     lastName: lastName.text,
  //     userName: username.text,
  //     email: email.text,
  //     phoneNumber: phoneNumber.text,
  //     password: password.text,
  //     birthDate: birthDate.value,
  //   );
  //   res.fold((l) {
  //     logger.e(l!.errors);
  //     Get.rawSnackbar(
  //         backgroundColor: Theme.of(Get.context!).appBarTheme.backgroundColor!,
  //         message: l.errors == "" ? "حدث خطآ حاول مجددا" : l.errors);
  //     isLoading.value = false;
  //   }, (r) {
  //     box.write("guest", false);
  //     box.write("auth", true);
  //     print("I am auth.");
  //     isAuth.value = true;
  //     isloginedIn.value = true;
  //     user.value = r!.user;
  //     if (user.value!.userType == 2) _filterMaterialStage();
  //     //logger.i(r.data);
  //     isLoading.value = false;
  //     ScaffoldController.controller.firstRoute.value = MainRoute;
  //     Get.offAllNamed(MainRoute);
  //     // Logger().i(r);
  //   });
  // }

  // Future regitserGuestUser() async {
  //   isLoading.value = true;
  //   final res = await registerGuestApi(box.read("fireToken"));
  //   res.fold((l) {
  //     logger.e(l!.errors);
  //     Get.rawSnackbar(
  //         message: l.message == "" ? "حدث خطآ حاول مجددا" : l.message);
  //     isLoading.value = false;
  //   }, (r) {
  //     box.write("guest", true);
  //     box.write("auth", false);
  //     print("I am guest.");
  //     isloginedIn.value = true;
  //     isAuth.value = false;
  //     //logger.i(r!.data);
  //     isLoading.value = false;
  //     ScaffoldController.controller.firstRoute.value = MainRoute;
  //     Get.offAllNamed(MainRoute);
  //     // Logger().i(r);
  //   });
  // }

  Future logout() async {
    final res = await logoutUserApi();
    res.fold((l) {
      logger.e(l!.errors);
      Get.rawSnackbar(
          message: l.message == "" ? "حدث خطآ حاول مجددا" : l.message);
      isLoading.value = false;
    }, (r) async {
      isLoading.value = false;
      box.write("auth", false);
      box.write("guest", false);
      print("I am not auth.");
      isAuth.value = false;
      isloginedIn.value = false;
      ScaffoldController.controller.firstRoute.value = RegisterationRoute;
      await Get.delete<PreDataService>();
      final notificationController =
          Get.isRegistered<NotificationApiController>();
      if (notificationController)
        await Get.delete<NotificationApiController>(force: true);
      if (Get.isRegistered<ReportController>())
        await Get.delete<ReportController>(force: true);
      //ReportController
      Get.offAllNamed(RegisterationRoute);
    });
  }

  Future refreshFireBaseToken(String old, String newToken) async {
    final res = await replaceTokenApi(old, newToken);
    res.fold((l) {
      logger.e(l!.errors);
      Get.rawSnackbar(
          message: l.message == "" ? "حدث خطآ حاول مجددا" : l.message);
      isLoading.value = false;
    }, (r) async {
      isLoading.value = false;
    });
  }

  void _filterMaterialStage() {
    // stageMaterial
    stageMaterial.clear();
    user.value!.materialsStages!.forEach((e) {
      if (!stageMaterial.containsKey(e!.stage!.name!)) {
        stageMaterial[e.stage!.name!] =
            List<MaterialModel>.empty(growable: true);
      }
      stageMaterial[e.stage!.name!]!.add(e.material!);
    });
  }
}

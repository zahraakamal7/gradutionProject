import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_booking_sys/api/apiEndpoints.dart';
import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/controller/authController.dart';
import 'package:flight_booking_sys/model/dailyMaterialModel.dart';
import 'package:flight_booking_sys/model/errorModel.dart';
import 'package:flight_booking_sys/model/responseModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class DailyMaterialController extends GetxController {
  static DailyMaterialController get controller =>
      Get.isRegistered<DailyMaterialController>()
          ? Get.find<DailyMaterialController>()
          : Get.put(DailyMaterialController(), permanent: true);

  final scrollController = ScrollController();
  Logger logger = Logger(
    printer: PrettyPrinter(),
  );
  CancelToken cancelToken = CancelToken();
  final isFetching = false.obs;
  final isFinished = false.obs;
  DateTime? latestLoading;
  final isError = false.obs;
  final selectedDay = "".obs;
  Rx<DailyMaterialModel?> dailyMaterial = Rx<DailyMaterialModel?>(null);
  RxList<DailyMaterialModel?> dailyMaterials = RxList<DailyMaterialModel?>();
  RxString selectedClass = RxString("");
  int skip = 0;
  int iteration = 1;
  @override
  void onInit() {
    super.onInit();
    if (UserType.Teacher == AuthController.controller.userType.value)
      selectedClass.value = AuthController
          .controller.user.value!.materialsStages!.first!.stage!.name!;
    scrollController.addListener(_onScroll);
    if (latestLoading == null) latestLoading = DateTime.now();
    preFetchData();
  }

  Future fetchDailyMaterials() async {
    isFetching.value = true;
    Either<ErrorModel?, ResponseModel?> res;
    Map parms = {};
    if (AuthController.controller.userType.value == UserType.Teacher) {
      parms["class_id"] = AuthController.controller.user.value!.materialsStages!
          .where((ms) => ms!.stage!.name == selectedClass.value)
          .first!
          .classId;
    }
    res = await getDailyMaterialsApi(data: parms);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      if (r!.dailyMaterials!.length > 0)
        selectedDay.value = r.dailyMaterials!.first.day!;
      dailyMaterials.clear();
      dailyMaterials.addAll(r.dailyMaterials!);
    });

    isFetching.value = false;
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.5); //threshold
  }

  void _onScroll() {
    if (isFinished.value) {
      return;
    }
    if (_isBottom && !isFetching.value) {
      print("fetch data");
      isFetching.value = true;
      final now = DateTime.now();

      final debounce = latestLoading!.isAfter(now)
          ? 0
          : now.difference(latestLoading!).inSeconds;

      Future.delayed(Duration(seconds: debounce < 3 ? 3 - debounce : 0),
          () async {
        await fetchDailyMaterials();
        latestLoading = DateTime.now();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void reset() {
    isFetching.value = false;
    isFinished.value = false;
    isError.value = false;
    latestLoading = DateTime.now();
    dailyMaterial.value = null;
    skip = 0;
    iteration = 1;
    cancelToken.cancel("cancelled");
    cancelToken = CancelToken();
  }

  Future<void> preFetchData() async {
    isFinished.value = false;
    isError.value = false;
    dailyMaterial.value = null;
    dailyMaterials.clear();
    skip = 0;
    iteration = 1;
    cancelToken.cancel("cancelled");
    cancelToken = CancelToken();
    if (!isFetching.value) {
      print("fetch data");
      isFetching.value = true;
      final now = DateTime.now();
      final debounce = latestLoading!.isAfter(now)
          ? 0
          : now.difference(latestLoading!).inSeconds;
      Future.delayed(Duration(seconds: debounce < 3 ? 3 - debounce : 0),
          () async {
        await fetchDailyMaterials();
        latestLoading = DateTime.now();
      });
    }
  }
}

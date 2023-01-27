import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_booking_sys/api/apiEndpoints.dart';
import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/controller/authController.dart';
import 'package:flight_booking_sys/model/examModel.dart';
import 'package:flight_booking_sys/model/errorModel.dart';
import 'package:flight_booking_sys/model/responseModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ExamTableController extends GetxController {
  static ExamTableController get controller =>
      Get.isRegistered<ExamTableController>()
          ? Get.find<ExamTableController>()
          : Get.put(ExamTableController(), permanent: true);

  final scrollController = ScrollController();
  Logger logger = Logger(
    printer: PrettyPrinter(),
  );
  CancelToken cancelToken = CancelToken();
  final isFetching = false.obs;
  final isFinished = false.obs;
  DateTime? latestLoading;
  final isError = false.obs;
  Rx<ExamModel?> examTable = Rx<ExamModel?>(null);
  RxList<ExamModel?> examTables = RxList<ExamModel?>();
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
    res = await getExaminationTable(data: parms);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      examTables.clear();
      examTables.addAll(r!.examsTable!);
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
    examTable.value = null;
    skip = 0;
    iteration = 1;
    cancelToken.cancel("cancelled");
    cancelToken = CancelToken();
  }

  Future<void> preFetchData() async {
    isFinished.value = false;
    isError.value = false;
    examTable.value = null;
    examTables.clear();
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

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_booking_sys/api/apiEndpoints.dart';
import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/controller/authController.dart';
import 'package:flight_booking_sys/model/degreeModel.dart';
import 'package:flight_booking_sys/model/errorModel.dart';
import 'package:flight_booking_sys/model/responseModel.dart';
import 'package:flight_booking_sys/services/preDataService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class CertificateController extends GetxController {
  static CertificateController get controller =>
      Get.isRegistered<CertificateController>()
          ? Get.find<CertificateController>()
          : Get.put(CertificateController(), permanent: true);

  final scrollController = ScrollController();
  Logger logger = Logger(
    printer: PrettyPrinter(),
  );
  CancelToken cancelToken = CancelToken();
  final isFetching = false.obs;
  final isFinished = false.obs;
  DateTime? latestLoading;
  final isError = false.obs;
  RxList<DegreeModel?> certificate = RxList<DegreeModel?>();
  RxString selectedSemester = RxString("");
  int skip = 0;
  int iteration = 1;
  @override
  void onInit() {
    super.onInit();
    selectedSemester.value =
        PreDataService.servicesController.semesters.first.name!;
    scrollController.addListener(_onScroll);
    if (latestLoading == null) latestLoading = DateTime.now();
    preFetchData();
  }

  Future getCertificate() async {
    isFetching.value = true;
    Either<ErrorModel?, ResponseModel?> res;
    Map<String, dynamic> parms = {};

    parms["semester_id"] = PreDataService.servicesController.semesters
        .where((ms) => ms.name == selectedSemester.value)
        .first
        .id;

    res = await getCertificateApi(data: parms);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      certificate.clear();
      certificate.addAll(r!.degrees!);
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
        await getCertificate();
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

    skip = 0;
    iteration = 1;
    cancelToken.cancel("cancelled");
    cancelToken = CancelToken();
  }

  Future<void> preFetchData() async {
    isFinished.value = false;
    isError.value = false;

    certificate.clear();
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
        await getCertificate();
        latestLoading = DateTime.now();
      });
    }
  }
}

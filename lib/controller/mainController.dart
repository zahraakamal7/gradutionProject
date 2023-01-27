import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_booking_sys/api/apiEndpoints.dart';
import 'package:flight_booking_sys/model/errorModel.dart';
import 'package:flight_booking_sys/model/flightOffer.dart';
import 'package:flight_booking_sys/model/responseModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class MainController extends GetxController {
  static MainController get controller => Get.isRegistered<MainController>()
      ? Get.find<MainController>()
      : Get.put(MainController(), permanent: true);

  /* flight offers */
  final scrollController = ScrollController();
  Logger logger = Logger(
    printer: PrettyPrinter(),
  );
  CancelToken cancelToken = CancelToken();
  final isFetching = false.obs;
  final isFinished = false.obs;
  DateTime? latestLoading;
  final isError = false.obs;
  RxList<FlightOffer> flightOffers = RxList.empty();
  int skip = 0;
  int iteration = 1;
  /* end offers */
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    if (latestLoading == null) latestLoading = DateTime.now();
    // preFetchData();
  }

  Future fetchFlightOffers() async {
    isFetching.value = true;
    Either<ErrorModel?, ResponseModel?> res;
    res = await getFlightOfferApi(skip: skip, limit: 10);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      flightOffers.addAll(r!.flightOffers!);
      skip += 10;
      iteration += 1;
      if (r.count! < iteration) {
        isFinished.value = true;
      }
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
        await fetchFlightOffers();
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
    flightOffers.clear();
    skip = 0;
    iteration = 1;
    cancelToken.cancel("cancelled");
    cancelToken = CancelToken();
  }

  Future<void> preFetchData() async {
    isFinished.value = false;
    isError.value = false;
    flightOffers.clear();
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
        await fetchFlightOffers();
        latestLoading = DateTime.now();
      });
    }
  }
}

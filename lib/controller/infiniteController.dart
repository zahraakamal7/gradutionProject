import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../model/errorModel.dart';
import '../model/responseModel.dart';

class ShowItemsController extends GetxController {
  Logger logger = Logger(
    printer: PrettyPrinter(),
  );
  CancelToken cancelToken = CancelToken();
  final isFetching = false.obs;
  final isFinished = false.obs;

  final isError = false.obs;
  DateTime? latestLoading;
  final items = [].obs;
  int skip = 0;
  int iteration = 1;

  static ShowItemsController get con => Get.isRegistered<ShowItemsController>()
      ? Get.find<ShowItemsController>()
      : Get.put(ShowItemsController(), permanent: false);
  final scrollController = ScrollController();
  ShowItemsController() {
    scrollController..addListener(_onScroll);
    if (latestLoading == null) latestLoading = DateTime.now();
    // items.addAll([]);
    // Future.value(fetchRecentProducts());
  }
  Future fetchRecentProducts() async {
    isFetching.value = true;
    Either<ErrorModel?, ResponseModel?>?
        res; //TODO:: add get to scroll infinite

    res!.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      items.addAll(r!.data!.keys);
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
        await fetchRecentProducts();
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
    items.clear();
    skip = 0;
    iteration = 1;
    cancelToken.cancel("cancelled");
    cancelToken = CancelToken();
  }

  Future<void> preFetchData() async {
    isFinished.value = false;
    isError.value = false;
    items.clear();
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
        await fetchRecentProducts();
        latestLoading = DateTime.now();
      });
    }
  }
}

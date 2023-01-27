import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_booking_sys/api/apiEndpoints.dart';
import 'package:flight_booking_sys/model/currencyModel.dart';
import 'package:flight_booking_sys/model/errorModel.dart';
import 'package:flight_booking_sys/model/responseModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:supercharged/supercharged.dart';

class ExchangeCurrencyController extends GetxController {
  RxList<CurrencyModel> currencyPrices = RxList.empty(growable: true);
  static ExchangeCurrencyController get controller =>
      Get.isRegistered<ExchangeCurrencyController>()
          ? Get.find<ExchangeCurrencyController>()
          : Get.put(ExchangeCurrencyController(), permanent: false);

  final RxList<Map<String, dynamic>> currencyDropdown =
      RxList.empty(growable: true);
  final RxString firstCurrency = "".obs;
  final RxString secondCurrency = "".obs;
  TextEditingController value = TextEditingController();
  TextEditingController result = TextEditingController();

  Logger logger = Logger(
    printer: PrettyPrinter(),
  );
  CancelToken cancelToken = CancelToken();
  final isFetching = false.obs;
  final isFinished = false.obs;
  final isError = false.obs;
  @override
  void onInit() {
    super.onInit();
    // fetchCurrency();
  }

  void changeCurrnecy() {
    final firstCurr = firstCurrency.value == "دولار أمريكي"
        ? CurrencyModel()
        : currencyPrices
            .where((ele) => ele.nameAr == firstCurrency.value)
            .first;
    final secCurr = secondCurrency.value == "دولار أمريكي"
        ? CurrencyModel()
        : currencyPrices
            .where((ele) => ele.nameAr == secondCurrency.value)
            .first;
    double changes = 0;
    if (value.text == "") value.text = "0";
    if (firstCurrency.value == secondCurrency.value)
      changes = value.text.toDouble()!;
    else if (secondCurrency.value == "دولار أمريكي") {
      changes = value.text.toDouble()! / firstCurr.dollar!;
    } else if (firstCurrency.value == "دولار أمريكي") {
      changes = value.text.toDouble()! * secCurr.dollar!;
    } else {
      changes = value.text.toDouble()! / firstCurr.dollar!;
      changes = changes * secCurr.dollar!;
    }
    final fraction = changes.toString().split('.')[1];
    result.text = changes.toStringAsFixed(0) +
        (fraction.toInt() == 0
            ? ""
            : "." + fraction.substring(0, fraction.length < 2 ? 1 : 2));
  }

  // void fetchCurrency() async {
  //   isFetching.value = true;
  //   Either<ErrorModel?, ResponseModel?>? res;
  //   res = await getCurrencyTodayApi();
  //   res.fold((l) {
  //     logger.e(l!.errors);
  //   }, (r) {
  //     currencyPrices.clear();
  //     currencyDropdown.clear();
  //     currencyPrices.addAll(r!.currenciesModel!);
  //     currencyPrices.forEach((element) {
  //       currencyDropdown
  //           .add({"value": element.nameAr, "label": element.nameAr});
  //     });
  //     currencyDropdown.add({"value": "دولار أمريكي", "label": "دولار أمريكي"});

  //     isFinished.value = true;
  //   });

  //   isFetching.value = false;
  // }
}

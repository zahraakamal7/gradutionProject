import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/controller/authController.dart';
import 'package:flight_booking_sys/controller/reportFormController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GlobalMiddleware extends GetMiddleware {
  final authController = AuthController.controller;
  String? currentPage;
  @override
  RouteSettings? redirect(String? route) {
    return authController.isloginedIn.value || route == RegisterationRoute
        ? null
        : RouteSettings(name: RegisterationRoute);
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    print('>>> Page ${page!.name} called');
    print('>>> User ${authController.user.value?.phoneNumber} logged');
    currentPage = page.name;
    // return authController.username != null
    //     ? page.copyWith(parameter: {'user': authController.username})
    //     : page;
    // if (page.name == RegisterationRoute)
    //   ScaffoldController.controller.showAppbar.value = false;
    return page;
  }

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    // This function will be called right before the Bindings are initialize,
    // then bindings is null
    bindings = [];
    return bindings;
  }

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    print('Bindings of ${page.toString()} are ready');

    return page;
  }

  @override
  Widget onPageBuilt(Widget page) {
    print('Widget ${page.toStringShort()} will be showed');

    return page;
  }

  @override
  void onPageDispose() {
    if (this.currentPage == ReportFormRoute) {
      Get.delete<ReportFormController>();
    }
    print('PageDisposed ${this.currentPage}');
  }
}

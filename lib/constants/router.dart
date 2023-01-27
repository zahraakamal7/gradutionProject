import 'dart:io';

import 'package:flight_booking_sys/constants/pageMiddleware/GlobalMiddleware.dart';
import 'package:flight_booking_sys/view/auth/registerationView.dart';
import 'package:flight_booking_sys/view/certificateView.dart';
import 'package:flight_booking_sys/view/commentView.dart';
import 'package:flight_booking_sys/view/dailyTableView.dart';
import 'package:flight_booking_sys/view/examTableView.dart';
import 'package:flight_booking_sys/view/notificationView.dart';
import 'package:flight_booking_sys/view/reportFormView.dart';
import 'package:get/get.dart';
import '../constants/constantsVariables.dart';
import '../constants/extensions.dart';
import '../view/mainView.dart';
import '../view/splashView.dart';

class Routers {
  static var route = [
    GetPage(name: SpalshRoute, page: () => SplashView().scaffold()),
    GetPage(
        name: MainRoute,
        page: () => MainView().scaffold(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        middlewares: [GlobalMiddleware()],
        name: RegisterationRoute,
        page: () => RegisterationView().scaffold()),
    GetPage(
        name: DailyTableRoute,
        page: () => DailyTableView().scaffold(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: ExamTableRoute,
        page: () => ExamTableView().scaffold(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: ReportFormRoute,
        page: () => ReportFormView().scaffold(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: CommentRoute,
        page: () => CommentView().scaffold(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: NotificationRoute,
        page: () => NotificationView().scaffold(),
        middlewares: [GlobalMiddleware()]),
    GetPage(
        name: CertificateTableRoute,
        page: () => CertificateView().scaffold(),
        middlewares: [GlobalMiddleware()]),
  ];
}

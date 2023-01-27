import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_booking_sys/api/apiEndpoints.dart';
import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/controller/authController.dart';
import 'package:flight_booking_sys/controller/reportController.dart';
import 'package:flight_booking_sys/model/errorModel.dart';
import 'package:flight_booking_sys/model/notificationModel.dart';
import 'package:flight_booking_sys/model/responseModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class NotificationApiController extends GetxController {
  static NotificationApiController get controller =>
      Get.isRegistered<NotificationApiController>()
          ? Get.find<NotificationApiController>()
          : Get.put(NotificationApiController(), permanent: true);

  final reportController = ReportController.controller;
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
  Rx<NotificationModel?> notification = Rx<NotificationModel?>(null);
  RxList<NotificationModel?> notifications = RxList<NotificationModel?>();
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
    // connectToChannel();
    preFetchData();
  }

  Future fetchNotifications() async {
    isFetching.value = true;
    Either<ErrorModel?, ResponseModel?> res;
    Map<String, dynamic> parms = {};
    if (AuthController.controller.userType.value == UserType.Teacher) {
      parms["class_id"] = AuthController.controller.user.value!.materialsStages!
          .where((ms) => ms!.stage!.name == selectedClass.value)
          .first!
          .classId;
    }
    res = await getNotificationsApi(data: parms);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      notifications.clear();
      notifications.addAll(r!.notifications!);
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
        await fetchNotifications();
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
    notification.value = null;
    skip = 0;
    iteration = 1;
    cancelToken.cancel("cancelled");
    cancelToken = CancelToken();
  }

  Future<void> preFetchData() async {
    isFinished.value = false;
    isError.value = false;
    notification.value = null;
    notifications.clear();
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
        await fetchNotifications();
        latestLoading = DateTime.now();
      });
    }
  }

  Channel? notificationChannel;
  Future connectToChannel() async {
    notificationChannel = ReportController.controller.pusher.value!.subscribe(
        "private-user_notification.${AuthController.controller.user.value!.id}");

    await notificationChannel!
        .bind('App\\Events\\AuthNotification', bindNotificationSocket);
  }

  bindNotificationSocket(event) {
    if (event is String) event = jsonDecode(event);
    print(event);
    final notification = NotificationModel.fromJson(event['notify']);

    if (event["type"] == "add") {
      notifications.insert(0, notification);
    } else if (event["type"] == "delete") {
      final index =
          notifications.indexWhere((element) => element!.id == notification.id);
      if (index == -1) {
        print(index);
      }
      notifications.removeAt(index);
      notifications.refresh();
    }
    // if (notification.comment != null) {
    //   final comment = notification.comment;
    //   final commentController =
    //       CommentController.controller(reportId: comment!.reportId!);

    //   commentController.comments.add(comment);
    // }
  }

  void markSeen(NotificationModel notification) async {
    //markSeenNotification
    isFetching.value = true;
    Either<ErrorModel?, ResponseModel?> res;
    Map<String, dynamic> parms = {};
    parms["notify_id"] = notification.id;
    res = await markSeenNotification(data: parms);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      final index = notifications.indexWhere((p0) => p0!.id == notification.id);
      notifications[index]!.seen = true;
      notifications.refresh();
      // notifications.clear();
      // notifications.addAll(r!.notifications!);
    });

    isFetching.value = false;
  }
}

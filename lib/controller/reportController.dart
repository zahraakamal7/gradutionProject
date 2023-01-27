import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flight_booking_sys/api/apiEndpoints.dart';
import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/controller/authController.dart';
import 'package:flight_booking_sys/controller/notificationApiController.dart';
import 'package:flight_booking_sys/model/errorModel.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:get_storage/get_storage.dart';
import '../model/reportModel.dart';
import 'package:flight_booking_sys/model/responseModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ReportController extends GetxController {
  Rx<FlutterPusher?> pusher = Rx(null);
  static ReportController get controller => Get.isRegistered<ReportController>()
      ? Get.find<ReportController>()
      : Get.put(ReportController(), permanent: true);
  final auth = AuthController.controller;
  final reportsQueryType = 0
      .obs; // 0 absent report ,1 general report,2 specific report , 3 exam report ,4 assignment
  final selectedMaterial = "الكل".obs;
  final selectedClass = "الكل".obs;

  /* flight offers */
  ScrollController scrollController = ScrollController();
  Logger logger = Logger(
    printer: PrettyPrinter(),
  );
  CancelToken cancelToken = CancelToken();
  final isFetching = false.obs;
  final isFinished = false.obs;
  DateTime? latestLoading;
  final isError = false.obs;
  RxList<ReportModel> reports = RxList.empty();
  int skip = 0;
  int iteration = 1;
  /* end offers */
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    if (latestLoading == null) latestLoading = DateTime.now();
    preFetchData();
    connectReportChannel();
  }

  Future fetchreports() async {
    isFetching.value = true;
    Either<ErrorModel?, ResponseModel?> res;
    Map<String, dynamic> parms = {};
    if (auth.userType.value == UserType.Teacher) {
      if (selectedClass.value != "الكل") {
        parms["class_id"] = auth.user.value!.materialsStages!
            .where((ms) => ms!.stage!.name == selectedClass.value)
            .first!
            .classId;
      }
      if (selectedMaterial.value != "الكل") {
        parms["material_id"] = auth.user.value!.materialsStages!
            .where((ms) => ms!.material!.name == selectedMaterial.value)
            .first!
            .materialId;
      }
    }
    if (reportsQueryType.value > 0) {
      parms["type"] = reportsQueryType.value - 1;
    }
    res = await getReportsApi(skip: skip, limit: 10, data: parms);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      reports.addAll(r!.reports!);
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
        await fetchreports();
        latestLoading = DateTime.now();
      });
    }
  }

  @override
  void dispose() async {
    await pusher.value!.disconnect();
    super.dispose();
  }

  void reset() {
    isFetching.value = false;
    isFinished.value = false;
    isError.value = false;
    latestLoading = DateTime.now();
    reports.clear();
    skip = 0;
    iteration = 1;
    cancelToken.cancel("cancelled");
    cancelToken = CancelToken();
  }

  Future<void> preFetchData() async {
    isFinished.value = false;
    isError.value = false;
    reports.clear();
    skip = 0;
    iteration = 1;
    cancelToken.cancel("cancelled");
    cancelToken = CancelToken();
    scrollController = new ScrollController();
    scrollController.addListener(_onScroll);
    if (!isFetching.value) {
      print("fetch data");
      isFetching.value = true;
      final now = DateTime.now();
      final debounce = latestLoading!.isAfter(now)
          ? 0
          : now.difference(latestLoading!).inSeconds;
      Future.delayed(Duration(seconds: debounce < 3 ? 3 - debounce : 0),
          () async {
        await fetchreports();
        latestLoading = DateTime.now();
      });
    }
  }

  void deleteReport(ReportModel report) async {
    //report
    isFetching.value = true;
    Either<ErrorModel?, ResponseModel?> res;
    Map<String, dynamic> parms = {};
    parms["report_id"] = report.id;
    res = await deleteReportApi(data: parms);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      reports.removeWhere((element) => element.id == report.id);
      showUniformSnack("تم حذف تبليغ بنجاح");
    });

    isFetching.value = false;
  }

  void connectReportChannel() async {
    try {
      String token = GetStorage().read<String>("token")!;
      PusherOptions options = PusherOptions(
        host: '3.74.16.10',
        port: 6001,
        cluster: "mt1",
        encrypted: false,
        auth: PusherAuth(
          'http://3.74.16.10:8009/api/broadcasting/auth',
          headers: {
            "Content-Type": "application/json",
            'accept': 'application/json',
            'Authorization': "Bearer $token",
          },
        ),
      );
      pusher.value = FlutterPusher("hello", options, enableLogging: true);

      await pusher.value!.connect(
          onConnectionStateChange: (connectionState) async {
        print("${connectionState!.currentState}");
      }, onError: (connectionError) {
        print("${connectionError!.message}");
      });
    } catch (e) {
      Logger().e(e);
    }
    final notification = NotificationApiController.controller;
    await notification.connectToChannel();
    await connectToChannel();
  }

  Channel? generalReportChannel;
  Channel? studentReportChannel;
  Channel? classReportChannel;
  Future connectToChannel() async {
    if (UserType.Student == auth.userType.value) {
      // general , wajb , amthan , absent ,
      studentReportChannel = pusher.value!
          .subscribe("private-absent_report.${auth.user.value!.id}");

      await studentReportChannel!
          .bind('App\\Events\\AbsentSockets', bindReportSocket);
      classReportChannel = pusher.value!
          .subscribe("private-class_report.${auth.user.value!.classId}");

      await classReportChannel!
          .bind('App\\Events\\ReportClassSockets', bindReportSocket);
    }
    generalReportChannel = pusher.value!
        .subscribe("private-general_reports.${auth.user.value!.schoolId}");

    await generalReportChannel!
        .bind('App\\Events\\ReportGeneralSockets', bindReportSocket);
  }

  bindReportSocket(event) {
    if (event is String) event = jsonDecode(event);
    // print(event);
    ReportModel report = ReportModel.fromJson(event["report"]);
    if (report.issuerId == auth.user.value!.id) return;
    if (event["type"] == "add") {
      if (reportsQueryType.value - 1 == report.type! ||
          reportsQueryType.value == 0) reports.insert(0, report);
    } else if (event["type"] == "delete") {
      reports.removeWhere((element) => element.id == report.id);
    } else if (event["type"] == "edit") {
      final index = reports.indexWhere((element) => element.id == report.id);
      reports[index] = report;
      reports.refresh();
    }
  }

  void showFeedback(BuildContext context) async {
    TextEditingController feeds = TextEditingController();
    await Get.dialog(Dialog(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        height: 50,
        color: Theme.of(context).primaryColor,
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "قم بإبداء رأيك بالمدرسة او شكوى",
              style: TextStyle(color: Theme.of(context).colorScheme.background),
            )
          ],
        ),
      ),
      buildBeautifulTextField(context, "اكتب رأيك بكل صراحة",
          hintText: "المدرسة راذعة جدا", maxLines: 5, controller: feeds),
      Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
                child: OutlinedButton(
                    onPressed: () {
                      submitFeed(feeds.text);
                      Get.back();
                    },
                    child: Text("إرسال")))
          ],
        ),
      )
    ])));
  }

  void submitFeed(String text) async {
    Either<ErrorModel?, ResponseModel?> res;
    res = await postFeedApi(text);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      showUniformSnack("تم إضافة المراجعة بنجاح");
    });
  }
}

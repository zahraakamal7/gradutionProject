import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flight_booking_sys/api/apiEndpoints.dart';
import 'package:flight_booking_sys/constants/constantsVariables.dart';
import 'package:flight_booking_sys/controller/reportController.dart';
import 'package:flight_booking_sys/model/errorModel.dart';
import 'package:flight_booking_sys/model/responseModel.dart';
import 'package:flight_booking_sys/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_compression/image_compression.dart';
import 'package:image_compression/image_compression_io.dart';
import 'package:images_picker/images_picker.dart';
import 'package:logger/logger.dart';
import 'package:mime_type/mime_type.dart';
import 'package:url_launcher/url_launcher.dart';
import 'authController.dart';

class ReportFormController extends GetxController {
  Logger logger = Logger(
    printer: PrettyPrinter(),
  );
  final isFetching = false.obs;
  static ReportFormController get controller =>
      Get.isRegistered<ReportFormController>()
          ? Get.find<ReportFormController>()
          : Get.put(ReportFormController(), permanent: false);
  final currentReport = Rx<int>(-1);
  final isEdit = false.obs;
  final reportsQueryType = "".obs;
  final selectedClass = "".obs;
  final selectedMaterial = "".obs;
  RxList<Media> images = RxList();
  Rx<UserModel?> selectedUser = Rx<UserModel?>(null);
  Map<String, int> reportTypes = {
    "خاص": 2,
    "امتحان": 3,
    "واجب": 4,
  };
  @override
  void onInit() {
    super.onInit();
    print("on init report form");
    reportsQueryType.value = "خاص";
    selectedClass.value = AuthController
        .controller.user.value!.materialsStages!.first!.stage!.name!;
    selectedMaterial.value = AuthController
        .controller.stageMaterial[selectedClass.value]!.first.name!;
  }

  TextEditingController body = TextEditingController();
  TextEditingController url = TextEditingController();
  void addNewReport() async {
    if (url.text.length > 0) if (!await canLaunch(url.text)) {
      showUniformSnack("الرجاء لصق رابط صحيح");
      return;
    }
    Map<String, dynamic> parms = {};
    parms["type"] = reportTypes[reportsQueryType.value];
    if (url.text.length > 0) {
      parms["link"] = url.text;
    }
    parms["body"] = body.text.trim().length == 0 ? null : body.text;
    parms["material_id"] = AuthController
        .controller.user.value!.materialsStages!
        .where((ms) => ms!.material!.name == selectedMaterial.value)
        .first!
        .materialId;
    if (reportTypes[reportsQueryType.value] == 2) {
      if (selectedUser.value == null) {
        print("user is required");
        return;
      }
      parms["user_id"] = selectedUser.value!.id;
    } else {
      parms["class_id"] = AuthController.controller.user.value!.materialsStages!
          .where((ms) => ms!.stage!.name == selectedClass.value)
          .first!
          .classId;

      List<String> _images = getImagesBase64();
      parms["images"] = _images;
    }
    isFetching.value = true;
    Either<ErrorModel?, ResponseModel?> res;
    res = await addReportsApi(data: parms);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      ReportController.controller.reports.insert(0, r!.report!);
      reportsQueryType.value = "خاص";
      selectedClass.value = AuthController
          .controller.user.value!.materialsStages!.first!.stage!.name!;
      selectedMaterial.value = AuthController
          .controller.stageMaterial[selectedClass.value]!.first.name!;
      selectedUser.value = null;
      body.text = "";
      url.text = "";
      Get.back();
      showUniformSnack("تمت إضافة تبليغ بنجاح");
    });

    isFetching.value = false;
  }

  List<String> getImagesBase64() {
    List<String> _images = List.empty(growable: true);
    if (images.length > 0) {
      images.forEach((element) {
        final file = File(element.path);
        final input = ImageFile(
          rawBytes: file.readAsBytesSync(),
          filePath: file.path,
        );
        final output = compress(ImageFileConfiguration(
            input: input, config: Configuration(jpgQuality: 70)));
        String? mimeType = mime(element.path);
        _images.add("data:$mimeType;base64," + base64Encode(output.rawBytes));
      });
      return _images;
    }
    return [];
  }

  Future<List<UserModel>> searchUser(String query) async {
    List<UserModel> users = [];
    Map<String, dynamic> parms = {};
    parms["user_type"] = 3;
    //filter={"name":"class_id","value":["97ea5a9a-e7af-411b-9d5f-8302c55d8c43"]}
    parms["filter"] = {};
    parms["filter"]["name"] = "class_id";
    parms["filter"]["value"] = [
      AuthController.controller.user.value!.materialsStages!
          .where((ms) => ms!.stage!.name == selectedClass.value)
          .first!
          .classId
    ];
    parms["filter"] = jsonEncode(parms["filter"]);
    final res = await getUsersApi(data: parms);
    res.fold((l) {
      logger.e(l!.errors);
      users = [];
    }, (r) {
      users = r!.users!;
    });
    return users;
  }

  Future getImage() async {
    images.clear();
    int count = 4;
    if (isEdit.value) {
      final currentreport =
          ReportController.controller.reports.elementAt(currentReport.value);
      count = 4 - currentreport.images!.length;
      if (count <= 0) {
        return;
      }
    }
    List<Media>? res = await ImagesPicker.pick(
        count: count, pickType: PickType.image, gif: false);
    if (res != null) {
      res.forEach((element) {
        images.add(element);
      });
      if (isEdit.value) addImage();
    }
  }

  void deleteImage(int index) async {
    Map<String, dynamic> parms = {};

    parms["type"] = 2;
    parms["report_id"] =
        ReportController.controller.reports[currentReport.value].id;
    parms["image_id"] = ReportController
        .controller.reports[currentReport.value].images![index]!.id;
    isFetching.value = true;
    Either<ErrorModel?, ResponseModel?> res;
    res = await editReportApi(data: parms);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      ReportController.controller.reports[currentReport.value].images!
          .removeAt(index);
      ReportController.controller.reports.refresh();
    });

    isFetching.value = false;
  }

  void addImage() async {
    Map<String, dynamic> parms = {};

    parms["type"] = 1;
    parms["report_id"] =
        ReportController.controller.reports[currentReport.value].id;
    List<String> _images = getImagesBase64();
    parms["images"] = _images;
    isFetching.value = true;
    Either<ErrorModel?, ResponseModel?> res;
    res = await editReportApi(data: parms);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      ReportController.controller.reports[currentReport.value].images!
          .addAll(r!.images!);
      ReportController.controller.reports.refresh();
    });

    isFetching.value = false;
  }

  void updateBody() async {
    Map<String, dynamic> parms = {};
    if (url.text.length > 0) if (!await canLaunch(url.text)) {
      showUniformSnack("الرجاء لصق رابط صحيح");
      return;
    }

    if (url.text.length > 0) {
      parms["link"] = url.text;
    } else {
      parms["link"] = null;
    }
    parms["type"] = 0;
    parms["report_id"] =
        ReportController.controller.reports[currentReport.value].id;
    parms["body"] = body.text.trim().length == 0 ? null : body.text;
    isFetching.value = true;
    Either<ErrorModel?, ResponseModel?> res;
    res = await editReportApi(data: parms);
    res.fold((l) {
      logger.e(l!.errors);
    }, (r) {
      ReportController.controller.reports[currentReport.value].body = body.text;
      ReportController.controller.reports[currentReport.value].link =
          parms["link"];
      ReportController.controller.reports.refresh();
      Get.back();
      showUniformSnack("تم تعديل التبليغ بنجاح");
    });

    isFetching.value = false;
  }
}

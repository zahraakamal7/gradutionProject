import 'package:flight_booking_sys/controller/authController.dart';
import 'package:flight_booking_sys/model/commentModel.dart';
import 'package:flight_booking_sys/model/dailyMaterialModel.dart';
import 'package:flight_booking_sys/model/degreeModel.dart';
import 'package:flight_booking_sys/model/examModel.dart';
import 'package:flight_booking_sys/model/flightOffer.dart';
import 'package:flight_booking_sys/model/imageModel.dart';
import 'package:flight_booking_sys/model/materialModel.dart';
import 'package:flight_booking_sys/model/notificationModel.dart';
import 'package:flight_booking_sys/model/reportModel.dart';
import 'package:flight_booking_sys/model/semesterModel.dart';
import 'package:get_storage/get_storage.dart';

import 'errorModel.dart';
import 'userModel.dart';

class ResponseModel {
  ErrorModel? error;
  String? token;
  int? count;
  bool success = true;
  // model
  UserModel? user;
  List<UserModel>? users;
  FlightOffer? flightOffer;
  List<FlightOffer>? flightOffers;
  ReportModel? report;
  List<ReportModel>? reports;
  MaterialModel? material;
  List<MaterialModel>? materials;
  DailyMaterialModel? dailyMaterial;
  List<DailyMaterialModel>? dailyMaterials;
  ExamModel? examTable;
  List<ExamModel>? examsTable;
  DegreeModel? degree;
  List<DegreeModel>? degrees;
  SemesterModel? semester;
  List<SemesterModel>? semesters;
  ImageModel? image;
  List<ImageModel>? images;
  CommentModel? comment;
  List<CommentModel>? comments;
  NotificationModel? notification;
  List<NotificationModel>? notifications;
  Map<String, dynamic>? data;
//RegionModel
  // end model
  ResponseModel({this.error, this.token});

  // governorate
  //List<Governorate> governorates = List<Governorate>();
  ResponseModel.fromJson(Map<String, dynamic> json, {required String? type}) {
    error = ErrorModel(
        message: json['message'],
        code: json['code'] == null ? 800 : json['code'].toInt(),
        errors:
            json['errors'] == null ? Map<String, dynamic>() : json['errors']);
    if (error!.code != 200 && error!.code != 201) {
      if (error!.code == 402) AuthController.controller.logout();
      success = false;
      return;
    }
    if (json["count"] != null) count = json["count"];
    if (!(json["result"] is List)) return;
    final result = json["result"] as List;
    if (type == "user") {
      users = List.empty(growable: true);
      final token = json["token"];
      if (token != null) GetStorage().write("token", token);
      if (result.length > 0) {
        if (result.length == 1) {
          user = UserModel.fromJson(result[0])..token = token;
        }
        users = (result).map((e) => UserModel.fromJson(e)).toList();
      }
    } else if (type == "reports") {
      reports = List.empty(growable: true);
      if (result.length > 0) {
        if (result.length == 1) {
          report = ReportModel.fromJson(result[0]);
        }
        reports = (result).map((e) => ReportModel.fromJson(e)).toList();
      }
    } else if (type == "materials") {
      materials = List.empty(growable: true);
      if (result.length > 0) {
        if (result.length == 1) {
          material = MaterialModel.fromJson(result[0]);
        }
        materials = (result).map((e) => MaterialModel.fromJson(e)).toList();
      }
    } else if (type == "daily_materials") {
      dailyMaterials = List.empty(growable: true);
      if (result.length > 0) {
        if (result.length == 1) {
          dailyMaterial = DailyMaterialModel.fromJson(result[0]);
        }
        dailyMaterials =
            (result).map((e) => DailyMaterialModel.fromJson(e)).toList();
      }
    } else if (type == "exams") {
      examsTable = List.empty(growable: true);
      if (result.length > 0) {
        if (result.length == 1) {
          examTable = ExamModel.fromJson(result[0]);
        }
        examsTable = (result).map((e) => ExamModel.fromJson(e)).toList();
      }
    } else if (type == "semesters") {
      semesters = List.empty(growable: true);
      if (result.length > 0) {
        if (result.length == 1) {
          semester = SemesterModel.fromJson(result[0]);
        }
        semesters = (result).map((e) => SemesterModel.fromJson(e)).toList();
      }
    } else if (type == "degrees") {
      degrees = List.empty(growable: true);
      if (result.length > 0) {
        if (result.length == 1) {
          degree = DegreeModel.fromJson(result[0]);
        }
        degrees = (result).map((e) => DegreeModel.fromJson(e)).toList();
      }
    } else if (type == "editReport") {
      images = List.empty(growable: true);
      if (result.length > 0) {
        if (result.length == 1) {
          image = ImageModel.fromJson(result[0]);
        }
        images = (result).map((e) => ImageModel.fromJson(e)).toList();
      }
    } else if (type == "comment") {
      comments = List.empty(growable: true);
      if (result.length > 0) {
        if (result.length == 1) {
          comment = CommentModel.fromJson(result[0]);
        }
        comments = (result).map((e) => CommentModel.fromJson(e)).toList();
      }
    } else if (type == "notification") {
      notifications = List.empty(growable: true);
      if (result.length > 0) {
        if (result.length == 1) {
          notification = NotificationModel.fromJson(result[0]);
        }
        notifications =
            (result).map((e) => NotificationModel.fromJson(e)).toList();
      }
    }
    //exams

    //reports
    // if (type == "register_guest") {
    //   GetStorage().write("token", json["token"]);
    // } else {
    // if (type == "register" ||
    //     type == "login" ||
    //     type == "updateUser" ||
    //     type == "getUserInfo") {
    //   users = List.empty(growable: true);
    //   final token = json["token"];
    //   if (token != null) GetStorage().write("token", token);
    //   if (result.length > 0) {
    //     if (result.length == 1) {
    //       user = UserModel.fromJson(result[0])..token = token;
    //     }
    //     users = (result).map((e) => UserModel.fromJson(e)).toList();
    //   }
    // }
    //}
    data = json;
    success = true;
    if (json['token'] != null) token = json['token'];
  }
}

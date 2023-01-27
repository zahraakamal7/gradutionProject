import 'package:flight_booking_sys/model/imageModel.dart';
import 'package:flight_booking_sys/model/materialModel.dart';
import 'package:flight_booking_sys/model/stageModel.dart';
import 'package:flight_booking_sys/model/userModel.dart';

class ReportModel {
  String? id;
  String? issuerId;
  int? type;
  String? body;
  String? userId;
  String? link;
  String? classId;
  String? materialId;
  String? schoolId;
  DateTime? fromTime;
  DateTime? toTime;
  String? deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  UserModel? user;
  UserModel? issuer;
  List<ImageModel?>? images;
  StageModel? stage;
  MaterialModel? material;

  ReportModel({
    this.id,
    this.issuerId,
    this.type,
    this.body,
    this.userId,
    this.classId,
    this.materialId,
    this.schoolId,
    this.fromTime,
    this.toTime,
    this.link,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.issuer,
    this.images,
    this.stage,
    this.material,
  });
  ReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    link = json['link']?.toString();
    issuerId = json['issuer_id']?.toString();
    type = json['type']?.toInt();
    body = json['body']?.toString();
    userId = json['user_id']?.toString();
    classId = json['class_id']?.toString();
    materialId = json['material_id']?.toString();
    schoolId = json['school_id']?.toString();
    fromTime =
        json['from_time'] == null ? null : DateTime.parse(json['from_time']);
    toTime = json['to_time'] == null ? null : DateTime.parse(json['to_time']);
    deletedAt = json['deleted_at']?.toString();
    createdAt =
        json['created_at'] == null ? null : DateTime.parse(json['created_at']);
    updatedAt =
        json['updated_at'] == null ? null : DateTime.parse(json['updated_at']);

    user = (json['user'] != null) ? UserModel.fromJson(json['user']) : null;
    issuer =
        (json['issuer'] != null) ? UserModel.fromJson(json['issuer']) : null;
    stage = (json['stage'] != null) ? StageModel.fromJson(json['stage']) : null;
    material = (json['material'] != null)
        ? MaterialModel.fromJson(json['material'])
        : null;
    images = List<ImageModel>.empty(growable: true);
    if (json["images"] != null)
      json['images'].forEach((v) {
        images!.add(ImageModel.fromJson(v));
      });
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['issuer_id'] = issuerId;
    data['type'] = type;
    data['body'] = body;
    data['user_id'] = userId;
    data['class_id'] = classId;
    data['material_id'] = materialId;
    data['school_id'] = schoolId;
    data['from_time'] = fromTime;
    data['to_time'] = toTime;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    if (issuer != null) {
      data['issuer'] = issuer!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (stage != null) {
      data['stage'] = stage!.toJson();
    }
    if (material != null) {
      data['material'] = material!.toJson();
    }

    return data;
  }
}
